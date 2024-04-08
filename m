Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB227F465;
	Mon,  8 Apr 2024 14:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584853; cv=none; b=Iws3TuBN1E2fIZOswOFFDydDX7WqOOfXAOCivW1/zRGdXTbH5L8FMmo3BSwGEgoza3NcFlCyAaEB59jk1expRD/73WO3fCxdJlrsFm//qCn8euUGFiNvMy5h/Xf5/MS0ERane1eppIghYKv/waGQSmTuybaxT6ORQw2YvzfMRW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584853; c=relaxed/simple;
	bh=8mXusxGfRKpGPVH/zR2OP7ebAur9R8ixoMfRYwyydvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ji4dJjv9XV8xjcgSEgyyjf2JTriCnqE1e4ETxKX/VQUz7iJ0W/2aYXknD1VruLDpN7Bh4GcwAJr6v4RPEnff3aXiYUx6jLXPCRMhT5xAC2z4sAwb8csD8VPNZ6hMYj9pQaAfAWO+7D7tHN2dw7D6kAI6vZSHYa/MY4SUSyHaLGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+EbdN7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+EbdN7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040B9C433C7;
	Mon,  8 Apr 2024 14:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584853;
	bh=8mXusxGfRKpGPVH/zR2OP7ebAur9R8ixoMfRYwyydvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+EbdN7WHyrTWap4AwH/9YBCU2h4pRQodATmI+qH++KNMe+8E4aoGiZnfpYnzhAAB
	 LNKWHeUStBv1gchVKJU6/SrKeIvq4kxFhp/GyN2eqqsnLcWAsfGnzKVUSsNOwf2yni
	 Y+mVUqKFhlINcdsWeAFL9Z0PFTf0So9kkWO1I5SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.15 578/690] usb: cdc-wdm: close race between read and workqueue
Date: Mon,  8 Apr 2024 14:57:24 +0200
Message-ID: <20240408125420.546657468@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 339f83612f3a569b194680768b22bf113c26a29d upstream.

wdm_read() cannot race with itself. However, in
service_outstanding_interrupt() it can race with the
workqueue, which can be triggered by error handling.

Hence we need to make sure that the WDM_RESPONDING
flag is not just only set but tested.

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20240314115132.3907-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -485,6 +485,7 @@ out_free_mem:
 static int service_outstanding_interrupt(struct wdm_device *desc)
 {
 	int rv = 0;
+	int used;
 
 	/* submit read urb only if the device is waiting for it */
 	if (!desc->resp_count || !--desc->resp_count)
@@ -499,7 +500,10 @@ static int service_outstanding_interrupt
 		goto out;
 	}
 
-	set_bit(WDM_RESPONDING, &desc->flags);
+	used = test_and_set_bit(WDM_RESPONDING, &desc->flags);
+	if (used)
+		goto out;
+
 	spin_unlock_irq(&desc->iuspin);
 	rv = usb_submit_urb(desc->response, GFP_KERNEL);
 	spin_lock_irq(&desc->iuspin);


