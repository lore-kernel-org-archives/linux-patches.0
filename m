Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882AB446070;
	Thu, 30 Jul 2026 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424324; cv=none; b=d9gS7cwtzgQ0MvKrZCOMx6k7H2AGWSePsfKvtaqQLhHP/D4otreow2mBsLn6b8KJ/ow3CwaytG4kn90QL4kmeSNuBvnz1zJCCfRSviUouXG/GaWq362v1MDxwDbgBJ2p6GuXC+aSWZmEHjlwrBXH1rN3StPLSjOUU1eJJ6vM1mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424324; c=relaxed/simple;
	bh=s4G/6JNGcjAjguB4lsrAz375Anq5uCbLo87VhR1VdCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8Xiq94ZiAziLbW6RUlFg/ryaf/IzhHKa3SpE9edVV4OnqBX9qq1yNRRTrqRkqRKopUMOmMsqGOXUA5av7kCa9BzKEEbzSJivpt1Q66ngg3X7LTxs/Ft9NXEY0w6v/lZOcy7CWmIEWrmAHtO3WjIE0/vC1KpCXoMByoXPpBlK7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6Ljymy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6Ljymy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7AB1F00A3A;
	Thu, 30 Jul 2026 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424322;
	bh=MePmFLCVliZFZgvOuONfbVbd3O5NBPaRhmZZH6HbVz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6Ljymy5yV3TFfQtHQGcPGqxz6Q8NaCtr5RODr/0aQmrO5UVGZz/nFPMTR7SypvTK
	 F9ZABwQdh4bz+/aqqe2QDiCL0/irrfDQmIKvqT3kfLJfNYOLJkpRxHD++kwjANMOwK
	 XNdZSqzgDiybALJWWH9aupDfwzSMfrpd9gjc68qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Alessio Belle <alessio.belle@imgtec.com>
Subject: [PATCH 6.18 351/675] drm/imagination: acquire vm_ctx->lock before mapping memory to GPU VM
Date: Thu, 30 Jul 2026 16:11:21 +0200
Message-ID: <20260730141452.595826887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -746,6 +746,7 @@ pvr_vm_map(struct pvr_vm_context *vm_ctx
 
 	pvr_gem_object_get(pvr_obj);
 
+	mutex_lock(&vm_ctx->lock);
 	err = drm_gpuvm_exec_lock(&vm_exec);
 	if (err)
 		goto err_cleanup;
@@ -755,6 +756,7 @@ pvr_vm_map(struct pvr_vm_context *vm_ctx
 	drm_gpuvm_exec_unlock(&vm_exec);
 
 err_cleanup:
+	mutex_unlock(&vm_ctx->lock);
 	pvr_vm_bind_op_fini(&bind_op);
 
 	return err;


