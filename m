Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89B52F0C74;
	Fri,  7 Aug 2026 15:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115737; cv=none; b=mZVrkZmHnTgqD8OVSoyA5rZuk5VMiGqNSyg9X6zf8TvPoV5pttU95fk5nDxSr9JjBt8imaiWXf3wFwj2YgQmRfA07f3u8VsPysoe/KAEWqKashfc58YEHJ+ahX01Ot2JDT3VoiZJ4Zyvv2L7LvA762OwYz3c3Krf6Mr/EqQRgHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115737; c=relaxed/simple;
	bh=leHBjHKT66qozlfhbQkQO5Fic8JA4u3k8xZaCtIM5Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq1cEt6l7P5iGNFrKlLjZYb6JRum8+Yyre1E0q+NOK53aOWYV/XYk2JhpHIwHoyC0IknrrpWObPmEjKDcxeGGZzNs1voGpW7V29d/BqzzTdJzudNAdC4c18d3RpPWi6LYiWqypkoOwD9L2I0A2Ze2xEg7TigiYUdZXEWT0TV9Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SBSc+Mdq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SBSc+Mdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6421F000E9;
	Fri,  7 Aug 2026 15:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115735;
	bh=HEIxZ2OkK4SaRRe8F+iH5rY6i4V149KqoGzGNGJWdgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SBSc+MdqSveVfCkPNZ2MYDjv9PF2pFhqFKa2EjNHcZ5oWGnMiPIk2uxQ+F5o7ckte
	 9572OT2AvMiR84xAUFAyznwViiPtxCC65XnG0J9FHVbIytkI08MQsn2Fyk3d0ZcCJw
	 m3zKIs4VHIjokRLLB+8hPRjGLfx2OlPYkzAtZ6tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>
Subject: [PATCH 6.18 337/396] drm/vmwgfx: avoid destroy_workqueue(NULL) on vkms init failure
Date: Fri,  7 Aug 2026 16:38:17 +0200
Message-ID: <20260807143431.556300683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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


