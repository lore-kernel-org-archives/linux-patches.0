Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C157D3F23BE;
	Sat, 12 Sep 2026 09:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205731; cv=none; b=W3D4I2Hne6tqcGTXNFCIjB2uvFHzbTUeedNlMwWoPfbJ0jMe+4qhL+QHBfFvGrdnX4DhGTjPdB3Fcm4USJUQd1u6/eufB8/UDLigRAyJzZYq3UlcDHpV0kwXflbcHjNuc2z2oKk25xXqhng9FJXxRZk5tFUP9YadUIuhGSx3i94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205731; c=relaxed/simple;
	bh=u0+AL88UC6oJilOyS3KbScJyw05/QJnlWqvUBlRBPC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uLtRZ/XGTSdAGK73iyHRe8DdxDQ0eygSMY4HlLfKQRPG1iX0wr2PJEEG8JYulpLSmmoABIhJratTE0rv7icrVclc9TbRZTDQIS9kv+pKkUtFFZ2ozRGzFbe1nvkcovebmcoSNOqFniJewhnr2NYoDj4ti71zIyTpMs5OB+bznkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dzp4f42V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dzp4f42V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5D41F000FF;
	Sat, 12 Sep 2026 09:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205730;
	bh=swflrkWAYy1g2rPty+7igXvLTAJeSDoQa2rfnNWWki8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzp4f42VdxcuebeezLTBrK+4JXpbQ2jAayRSpbMP9PnRT8iO0y8lqpJYMbFuHdL5i
	 RBtHv/F9+MDIW69VjKpxore3UvMQwit/FIDg1I4Nf5td62NYQyKYO63D0vFF5VEnnL
	 OIMFpfP6ugcY6vgh3cFidhZ1qPjyjnv/C71I8r+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taimuraz Kaitmazov <taimuraz@kaitmazov.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0062/1518] accel/amdxdna: return early from a zero-length flush
Date: Sat, 12 Sep 2026 08:37:11 +0200
Message-ID: <20260912065624.854679302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>

[ Upstream commit dc14753664240cedf669623b27ae9922b0618b25 ]

SYNC_BO does not constrain its size, so a request for zero bytes reaches
drm_clflush_virt_range(), which ends with an unconditional
clflushopt(end - 1). For an empty range that is the byte before the
mapping, and abo->mem.kva comes from vmap(), so the access lands in the
guard page below the vmalloc area and faults:

  BUG: unable to handle page fault for address: ffffd16fbbc70fff
  #PF: supervisor read access in kernel mode
  Oops: Oops: 0000 [#1] SMP NOPTI
  CPU: 7 UID: 1000 Comm: sync_bo_probe
  RIP: 0010:drm_clflush_virt_range+0x3c/0x70
  Call Trace:
   amdxdna_drm_sync_bo_ioctl+0x124/0x430 [amdxdna]
   drm_ioctl+0x301/0x4c0
   __x64_sys_ioctl+0x115/0x2f0
   do_syscall_64+0xa6/0x3d0

Any process that can open the render node can do this. Reproduced 3 of 3
times on a Strix Point NPU (1022:17f0), by calling SYNC_BO with size 0 on
an AMDXDNA_BO_SHARE object. The import arm takes the same request but
flushes the whole scatterlist, so it survives it.

Nothing needs flushing for an empty range, so answer before choosing a
path.

Fixes: e252e3f3488a ("accel/amdxdna: Revise device bo creation and free")
Cc: stable@vger.kernel.org
Signed-off-by: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260817230655.356785-1-taimuraz@kaitmazov.com
[ moved the guard into amdxdna_drm_sync_bo_ioctl() because amdxdna_flush_bo() is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -949,6 +949,9 @@ int amdxdna_drm_sync_bo_ioctl(struct drm
 		goto put_obj;
 	}
 
+	if (!args->size)
+		goto unpin;
+
 	if (is_import_bo(abo))
 		drm_clflush_sg(abo->base.sgt);
 	else if (abo->mem.kva)
@@ -958,6 +961,7 @@ int amdxdna_drm_sync_bo_ioctl(struct drm
 	else
 		drm_WARN(&xdna->ddev, 1, "Can not get flush memory");
 
+unpin:
 	amdxdna_gem_unpin(abo);
 
 	XDNA_DBG(xdna, "Sync bo %d offset 0x%llx, size 0x%llx\n",


