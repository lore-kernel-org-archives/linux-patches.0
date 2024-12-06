Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703E347F53;
	Fri,  6 Dec 2024 14:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496367; cv=none; b=ByROBxjhfwQHY2nkkxHFLFMssNg7fCO955XQrGyekVCb+3IwxeaOxp7zyHK5ZqydNs1YZaR/2IndX1Z8WsdOitI5Yjzt6WD/54vP/iF3SfsGQIS1ii5D02Qz70n0cl6kHQ02KurF+z4Zn9rXLGcCXMg9VqSv6C+8ei9JElFv1qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496367; c=relaxed/simple;
	bh=SNm3ilOXi0UUiu84xpQgapxEMUkQtqZ4vtLsubteLJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sO83Z8TZH1GapR2bSn1AAAj0sio8ROs1Aspp5y4XqTUblzdTILaQicqhRygkKQnLANpwgjlF9arWJ7X3c04sTT4qY3En+InN+ec9Ggpa+L7b+i0xwkOi0ZnU21IJrSNUXZGOrzziAasmxBXq4hvlHV24fq36QGKDxMD8IBbZ+cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2MSbR2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2MSbR2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC905C4CED1;
	Fri,  6 Dec 2024 14:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496367;
	bh=SNm3ilOXi0UUiu84xpQgapxEMUkQtqZ4vtLsubteLJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2MSbR2QzZyVPLoPhxVggEqsFf8iXmhTh8Gcs4S3pSbdKiH4NBlPCfyxkNqCbGFBO
	 oMvm/uH7e10nA9MddPs34x0MFvyxE/0hMQhmxaRcs6LEiywFJzmtW87eBw0k5k9E7e
	 NSu7XIPkcXO8DF8Ri6Zr2QetaYwWFLeclzaF9bII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.12 132/146] drm/xe/migrate: use XE_BO_FLAG_PAGETABLE
Date: Fri,  6 Dec 2024 15:37:43 +0100
Message-ID: <20241206143532.734183058@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit c78f4399188369a55eed69cbf19a8aad2a65ac75 upstream.

On some HW we want to avoid the host caching PTEs, since access from GPU
side can be incoherent. However here the special migrate object is
mapping PTEs which are written from the host and potentially cached. Use
XE_BO_FLAG_PAGETABLE to ensure that non-cached mapping is used, on
platforms where this matters.

Fixes: 7a060d786cc1 ("drm/xe/mtl: Map PPGTT as CPU:WC")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241126181259.159713-4-matthew.auld@intel.com
(cherry picked from commit febc689b27d28973cd02f667548a5dca383d859a)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_migrate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -209,7 +209,8 @@ static int xe_migrate_prepare_vm(struct
 				  num_entries * XE_PAGE_SIZE,
 				  ttm_bo_type_kernel,
 				  XE_BO_FLAG_VRAM_IF_DGFX(tile) |
-				  XE_BO_FLAG_PINNED);
+				  XE_BO_FLAG_PINNED |
+				  XE_BO_FLAG_PAGETABLE);
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 


