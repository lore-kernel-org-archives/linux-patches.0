Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A23423A85;
	Wed,  9 Sep 2026 13:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962045; cv=none; b=nGqFTdqC7DXvcYjX3dWtBplXtXwCVC9fXAD/NlaxTmOA7d1lXVKeAhDM2U71KFRZk9YsIK3yGMsGM0P7NvgewKqYjzLPcAtNt8gO16bR+QvcFOmhCOSm4lluSy7Kyd1ngf1UTbqsNAvCd0kBNSBD3foMhf/2Xv1n5QoTzPLM+cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962045; c=relaxed/simple;
	bh=HeAb2bpkKct76jQFGgCsf8pBS2U7lBx6Lfz8Esn7Is0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdJLIpyUy2N7oYfMi2THLPKV57X8OHRV4qU/IpdFswSUCTHXYAdMDpCdXcefCTzrpAquxowYt1C7xyz2cNIruhGEWvmhAuDq3uts85K978B6jx+oURbtbFv90dz/qvEJAZ+u2OfYnjN0gtKn6DAsr8tvrKTQhA6TEAaH854z0S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HiHH8CdR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HiHH8CdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F147C1F00A3A;
	Wed,  9 Sep 2026 13:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962044;
	bh=+MW9dPWc/2vWm3AVJVgziz5EtIHI9d8hsC65b5aTU9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HiHH8CdRG4Bq7kxUB+Qfh3m9qkHiUYTuBasOhcNy5o8tKGrHBnaznvWFuBWgQ9aWT
	 /gglGd6i+QbrRyzI6JteUhX1wNFutruNX61zo6O6tXwUOJ86QBphnVOdvNTVXdj7qF
	 tk46E2El+dgyEUoA5soWek9D/mCHyAsRkfHyj4G0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taimuraz Kaitmazov <taimuraz@kaitmazov.com>,
	Lizhi Hou <lizhi.hou@amd.com>
Subject: [PATCH 7.2 153/556] accel/amdxdna: return early from a zero-length flush
Date: Wed,  9 Sep 2026 15:37:13 +0200
Message-ID: <20260909134235.817018663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taimuraz Kaitmazov <taimuraz@kaitmazov.com>

commit dc14753664240cedf669623b27ae9922b0618b25 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -1247,6 +1247,9 @@ static int amdxdna_flush_bo(struct amdxd
 		return -EINVAL;
 
 	size = min(abo->mem.size, end) - offset;
+	if (!size)
+		return 0;
+
 	if (is_import_bo(abo))
 		drm_clflush_sg(abo->base.sgt);
 	else if (amdxdna_gem_vmap(abo))


