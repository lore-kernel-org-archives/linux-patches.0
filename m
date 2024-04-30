Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BC912B176;
	Tue, 30 Apr 2024 11:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474875; cv=none; b=iFk9gF1jrcnqSPTKYNDFnVMFz2m/rXyj1YJgDxBvmh+9E3RGQvXn6emzdOQ2bFN5QGPhuIhB6xQpVBWAhXU9vWu3Bj2PIbzSlmcy2syHOEvRWf6KNuc2OiPtLJL65uqzjOeiDtIgPhqne4P0w1kt/kumsCZHXvcLz7Ga0aGTV9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474875; c=relaxed/simple;
	bh=HfZTZf5LbS0y+PL459qh16pWWetlHLHEQ0M26YnESWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UTKwjjXwtV52DJiUXi2aU1gouy7y9s49sDNQhXB6ZZCYPQz7pp14//xEZVLqz0XkqH8mUzX306umkMVqEIYKAeiR+r+ohWDzu9yJfpDuYQKBs73J55ScSQj4tWLKzPwkz7hKlK1yJinXI3AouvUv5t8pFL8nbwmLMn5m+ruRk7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=biz5jiD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biz5jiD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6449C4AF19;
	Tue, 30 Apr 2024 11:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474875;
	bh=HfZTZf5LbS0y+PL459qh16pWWetlHLHEQ0M26YnESWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biz5jiD6JQsrS4Z2iSsg9gVQ668AM1NtVhJgQ+LEUDIbDATFbwA5VcsB3+nEKdyLv
	 MpxUdWl5roM9xL+iuMTANU1ZHqrFncoPY6ER+o1g3ctG3tfk1ZqI4dP/AdKp1H9M1l
	 ZvtC5xCXMTSgujmTJcOMQ65xR9w4ZZDY4x9v18os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	": Aleksander Morgado" <aleksandermj@chromium.org>,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>,
	=?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH 5.10 062/138] Revert "usb: cdc-wdm: close race between read and workqueue"
Date: Tue, 30 Apr 2024 12:39:07 +0200
Message-ID: <20240430103051.251329135@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 1607830dadeefc407e4956336d9fcd9e9defd810 upstream.

This reverts commit 339f83612f3a569b194680768b22bf113c26a29d.

It has been found to cause problems in a number of Chromebook devices,
so revert the change until it can be brought back in a safe way.

Link: https://lore.kernel.org/r/385a3519-b45d-48c5-a6fd-a3fdb6bec92f@chromium.org
Reported-by:: Aleksander Morgado <aleksandermj@chromium.org>
Fixes: 339f83612f3a ("usb: cdc-wdm: close race between read and workqueue")
Cc: stable <stable@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -471,7 +471,6 @@ out_free_mem:
 static int service_outstanding_interrupt(struct wdm_device *desc)
 {
 	int rv = 0;
-	int used;
 
 	/* submit read urb only if the device is waiting for it */
 	if (!desc->resp_count || !--desc->resp_count)
@@ -486,10 +485,7 @@ static int service_outstanding_interrupt
 		goto out;
 	}
 
-	used = test_and_set_bit(WDM_RESPONDING, &desc->flags);
-	if (used)
-		goto out;
-
+	set_bit(WDM_RESPONDING, &desc->flags);
 	spin_unlock_irq(&desc->iuspin);
 	rv = usb_submit_urb(desc->response, GFP_KERNEL);
 	spin_lock_irq(&desc->iuspin);


