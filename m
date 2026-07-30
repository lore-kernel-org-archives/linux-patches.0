Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9C643E9DF;
	Thu, 30 Jul 2026 15:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426025; cv=none; b=C1xkbpWxn43u09i+hMZZsTmzthThu+Ody+nMBY9MdRtxWASp8+WyNdnpO9PyT2ZzvCPcfNCsKadf2QG+UaPCN2vFWKRCxBbQuAFMe6sEpfEOwviH9ia6mFiTMjsWRCcU58Jw3v9zTsgMFhq2yt6UQZTJ/CiZoim7QzaJE/ws7ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426025; c=relaxed/simple;
	bh=4MN+xmdQlapJyJd1gf2hoXjH9dNCUtKhGtKeqomSvj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvdkUsATqmHcKpfdIoSNQ404BW1nDPTa9B/eihEDJaoOMrrVZKBKJ3+yo+/1NpS5YHh4srsaIhOtsD+S4njCHyvzch4WyZe8xG3a9FvGCgJRFVG95c+UPdnrqrQzRRkxhzPfdEfMShLr34lUo7nIkgEaZVV6jAzkZzj3kbRLTZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBcCrMX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBcCrMX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460FB1F00A3A;
	Thu, 30 Jul 2026 15:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426023;
	bh=o6LZ3RBnpsWDbrfQVJ0w60256f0EjsZXSMJo/Erj2FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBcCrMX5D9nxPGdr6eJKqIcwCrSiKEF1LTQZs7uvKxWrctWB3lbhkGQxLXk9ALeE0
	 0AUzjMIl1RLTxhZM52wR2wTqxFHKBkd2FfmBRgWH+ziKQwE38FihDZsRDtRIfiq85j
	 mNbzmoIdayitRZPH73t3TDBaYthqfGGX5CKZSnQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Alessio Belle <alessio.belle@imgtec.com>
Subject: [PATCH 6.12 272/602] drm/imagination: acquire vm_ctx->lock before mapping memory to GPU VM
Date: Thu, 30 Jul 2026 16:11:04 +0200
Message-ID: <20260730141441.687061267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

commit 17e2030f37600994440f875dc410615d5c66ee6d upstream.

The drm gpuvm code doesn't protect find operation against map operation,
and the driver needs to ensure a map operation shouldn't happen when a
find operation is in progress.

In some cases a find operation will be in progress when doing map/unmap
operations, and the find operation will do a NULL pointer dereference.

An example of the stack trace of such NULL dereference is shown below:

```
Unable to handle kernel access to user memory without uaccess routines at
virtual address 0000000000000010

[<ffffffff01e989d4>] drm_gpuva_find+0x28/0x6c [drm_gpuvm]
[<ffffffff01ed3a40>] pvr_vm_unmap+0x34/0x68 [powervr]
[<ffffffff01ec69da>] pvr_ioctl_vm_unmap+0x2e/0x50 [powervr]
[<ffffffff8080ce0a>] drm_ioctl_kernel+0x8e/0xdc
[<ffffffff8080d016>] drm_ioctl+0x1be/0x3e0
[<ffffffff802bec3e>] __riscv_sys_ioctl+0xba/0xc4
[<ffffffff80d858b2>] do_trap_ecall_u+0x23e/0x3f4
[<ffffffff80d92288>] handle_exception+0x168/0x174
```

As all occurences of drm_gpuva_find*() are already guarded by
vm_ctx->lock, make pvr_vm_map() to acquire this lock to prevent
disturbing any find operation. This fixes the NULL deference problem in
drm_gpuva_find*().

Cc: stable@vger.kernel.org
Fixes: ff5f643de0bf ("drm/imagination: Add GEM and VM related code")
Fixes: 4bc736f890ce ("drm/imagination: vm: make use of GPUVM's drm_exec helper")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Alessio Belle <alessio.belle@imgtec.com>
Link: https://patch.msgid.link/20260714073641.1935075-1-zhengxingda@iscas.ac.cn
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_vm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/imagination/pvr_vm.c
+++ b/drivers/gpu/drm/imagination/pvr_vm.c
@@ -741,6 +741,7 @@ pvr_vm_map(struct pvr_vm_context *vm_ctx
 
 	pvr_gem_object_get(pvr_obj);
 
+	mutex_lock(&vm_ctx->lock);
 	err = drm_gpuvm_exec_lock(&vm_exec);
 	if (err)
 		goto err_cleanup;
@@ -750,6 +751,7 @@ pvr_vm_map(struct pvr_vm_context *vm_ctx
 	drm_gpuvm_exec_unlock(&vm_exec);
 
 err_cleanup:
+	mutex_unlock(&vm_ctx->lock);
 	pvr_vm_bind_op_fini(&bind_op);
 
 	return err;


