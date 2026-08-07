Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F5B9476CCF;
	Fri,  7 Aug 2026 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117707; cv=none; b=bTxME6JEuNnwg3JNPRf/EwoAFGQDWwT5bDtj/PCxsAZ/WV2PZAwUN+HYYSAkJEyXGhlsT1NsnokExgXxjJSevDkziC/Yq2g2BWM0NlzHYqV7guyjdHE9c7Jb8vt3Vt+YB0utIjnZ9DLBTDnfd8PXhsRpnj7CsprcU4RZw/aiP64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117707; c=relaxed/simple;
	bh=HRT/R1frElsicWs7wOap1tgzg9TLbn3MEoiQcvtzYZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2CGNBNXjGmAm/o4rqS+CU5qLTkOJb4JAV7+lXb1q0qGVBhOFgy6gaEHmthYBZQWtpAt4FalMGMZ3TGnRGOJTRdX1t7kMjfNG2A9MxhNpTTdtuNiX70uVBgM0AT/F9PiKx54xgNIVThgQwrSBObEM0Bos5N9rnmCs2lzaLR9Sfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THqAdmQu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THqAdmQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68C21F000E9;
	Fri,  7 Aug 2026 15:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117706;
	bh=SNf0Rcq4cNjl3VfENWRmlxK9FXUH1/q3AI+sYTvPmrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THqAdmQu/mMvaBsz9XdndKUKPWmZuF2noNGwSLFopAoXyvDghhFgSyJtC0uC2bGgC
	 EmKzG2FuZ0TJ6EjeKk7lmoQGkYbIS0n3t4VLzYoB6EBqZF1wK6Yszzk7lTchSMtUzu
	 iV1S01KDIFm4rHnfjKULLsNOmmex/lNWpjw2ORro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 7.1 414/438] drm/vmwgfx: avoid destroy_workqueue(NULL) on vkms init failure
Date: Fri,  7 Aug 2026 16:40:10 +0200
Message-ID: <20260807143436.790270925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zack Rusin <zack.rusin@broadcom.com>

commit 05eaa887e7b4f40fba425f8a1d7a5a8a043092a6 upstream.

Two paths through vmw_vkms_init() can leave vmw->crc_workq NULL while
still leaving the rest of the driver in a state that calls
vmw_vkms_cleanup() at module unload:

  1. vmw_host_get_guestinfo(GUESTINFO_VBLANK, ...) failing or
     returning an oversized buffer -- the common case on hosts
     without a VBLANK guestinfo entry -- early-returned before the
     workqueue allocation.
  2. alloc_ordered_workqueue() returning NULL on memory pressure.

vmw_vkms_cleanup() then calls destroy_workqueue(NULL), which
dereferences wq->name and panics.

Fix the first case by removing the early return: vmw->vkms_enabled
is already false on the rpci-failure path so no work will ever be
queued, and allocating the workqueue unconditionally keeps the
control flow simple.  Fix the second case by guarding the cleanup
with a NULL check, since alloc_ordered_workqueue() can still fail
under low memory.

Fixes: 7b0062036c3b ("drm/vmwgfx: Implement virtual crc generation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260505222728.519626-9-zack.rusin@broadcom.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_vkms.c
@@ -214,14 +214,14 @@ vmw_vkms_init(struct vmw_private *vmw)
 	vmw->vkms_enabled = false;
 
 	ret = vmw_host_get_guestinfo(GUESTINFO_VBLANK, buffer, &buf_len);
-	if (ret || buf_len > max_buf_len)
-		return;
-	buffer[buf_len] = '\0';
+	if (!ret && buf_len <= max_buf_len) {
+		buffer[buf_len] = '\0';
 
-	ret = kstrtobool(buffer, &vmw->vkms_enabled);
-	if (!ret && vmw->vkms_enabled) {
-		ret = drm_vblank_init(&vmw->drm, VMWGFX_NUM_DISPLAY_UNITS);
-		vmw->vkms_enabled = (ret == 0);
+		ret = kstrtobool(buffer, &vmw->vkms_enabled);
+		if (!ret && vmw->vkms_enabled) {
+			ret = drm_vblank_init(&vmw->drm, VMWGFX_NUM_DISPLAY_UNITS);
+			vmw->vkms_enabled = (ret == 0);
+		}
 	}
 
 	vmw->crc_workq = alloc_ordered_workqueue("vmwgfx_crc_generator", 0);
@@ -236,7 +236,8 @@ vmw_vkms_init(struct vmw_private *vmw)
 void
 vmw_vkms_cleanup(struct vmw_private *vmw)
 {
-	destroy_workqueue(vmw->crc_workq);
+	if (vmw->crc_workq)
+		destroy_workqueue(vmw->crc_workq);
 }
 
 bool


