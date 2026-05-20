Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07D53EAC83;
	Wed, 20 May 2026 17:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298647; cv=none; b=OJU6fucDKm5GEEtFLnELh/udzSmmDcsRk6+w21erN2x//e/G2NNK2G44TbeLjr7Xt1nqvel2KDwIuw50jxQPYdFbRv4VZce+ZWjaGk1qaVDxpf5drd5lREUbzr0MgLHGmHiqW5cPZdDXitFAJzLzcKJM+fVigPBpLK6bQC+VIDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298647; c=relaxed/simple;
	bh=GeRADYgwcRLcP1hRrtqTYP/V6kbf/nUbi6ngrvqmt/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwUwwaYrRJBdCelnP1Sioof4phT+RRsTAThDnVtO6Dko0/JqFRk16LgzaNarOZg1NTZem36MN7hT5JlWYQxpIUG12IKx8LahIOOpsZI0q0skYRItEW3fq7j+S4A6qshWY6aJ5no5bEm5gvSoVw2rTSpfWCRnbuhd35y4H7d6pic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bvn/oNUC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bvn/oNUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 625271F000E9;
	Wed, 20 May 2026 17:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298645;
	bh=O2awhu1UU/vDXHxAka9zUEELrlBpSp9a6w2wNbqDHQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bvn/oNUCk/GnNnXMoW9/GVfnYfZb/plgHYRqVdrIsk0Mf4UkGACtsSrere44S+8hg
	 PLg/2Q0ueSZn7xD4Fn9d/Rgl4v8aKJlRlFuj6yB1vXwYSfFwxmS2wO310+vnDwRYTB
	 hjwZvbIyppFLLDlv2ww5MOuegxjUqvBfXK7oFUUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 483/957] HID: usbhid: fix deadlock in hid_post_reset()
Date: Wed, 20 May 2026 18:16:06 +0200
Message-ID: <20260520162144.999273350@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 8df2c1b47ee3cd50fd454f75c7a7e2ae8a6adf72 ]

You can build a USB device that includes a HID component
and a storage or UAS component. The components can be reset
only together. That means that hid_pre_reset() and hid_post_reset()
are in the block IO error handling. Hence no memory allocation
used in them may do block IO because the IO can deadlock
on the mutex held while resetting a device and calling the
interface drivers.
Use GFP_NOIO for all allocations in them.

Fixes: dc3c78e434690 ("HID: usbhid: Check HID report descriptor contents after device reset")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 758eb21430cda..df3cc89dfb37f 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1552,7 +1552,7 @@ static int hid_post_reset(struct usb_interface *intf)
 	 * configuration descriptors passed, we already know that
 	 * the size of the HID report descriptor has not changed.
 	 */
-	rdesc = kmalloc(hid->dev_rsize, GFP_KERNEL);
+	rdesc = kmalloc(hid->dev_rsize, GFP_NOIO);
 	if (!rdesc)
 		return -ENOMEM;
 
-- 
2.53.0



