Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210925;
	b=ZD/ykb2uY8jr2wxV2mQ1qnePOV+Ppq5njabqzzr66/YIuqRY8B1E/DvowdHh2A9cTXlr
	 3t9jXue4xU2Zhpem5GTPPd7e905SOh2sLV05HJ9uA+bmFIFi34bVYq+2ziKVvYxgZ+ju3
	 6xiEr34O4Sv+ih3XabI6G9gin0OHLbDVTuncgQALIMiMNe9wK3vSN2YP6YWfm/FWJQMar
	 yrXO3D9pqDRtXIdlheBO9dUqj1bF1CFQdl4UW+PMFr3NgUVn+Rx4ndErNUR7SAWsNmwNj
	 fq3Nm7ESIYX/eVyqevsCFAiXdJAqlZj0Bc7IRMa//h3W4C0pAgf0Js95XjP/Cvfjrow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7FLcdwmYNWfjD7i+KtjIAwfbfnSNONTnLUjGYTwF/Bc=;
	b=A1PpGzKVt62VtUP+8CYgMFeyWVJOoyyU6n6/f9obw8RKbzhOeHV8+D31AXOxgWw7aI8h
	 I8hBWEXq8Vmjm0mbRC5PJHZdmjzlEQ6zKFm4jmgVTnw2nE+I6fMFh9LD4pcfxmdrJJCIm
	 St29NmEGKNfMBYyqqWcm++4JPNYXquQWMCnKDlzqSp9ztvuZ+GG5r2SgohGfyw8W9vVpQ
	 GlLO2niZXuTUly+iwx/4IO5fup9dv3tGYb+swTmw6wvx0j5YOOn8xo+F14cW4QaIVXkQw
	 8reYy1P2+0QVhWYA5zs8m/oYY6327BSAx8im5uoZ6DKD7E+pifsDr8WMis5A53kTq+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmIPAEUH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD006606A31E;
	Wed, 28 Oct 2026 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WmIPAEUH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371D11F01825;
	Wed, 28 Oct 2026 18:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210924;
	bh=7FLcdwmYNWfjD7i+KtjIAwfbfnSNONTnLUjGYTwF/Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WmIPAEUHBT6yfIWqnjbltqjP+AU951kIapyNPibeD5i+KViucbkUIUAJ3KmcfCLRf
	 dsow/stn51jwcC0apMtlyCHDHaxF+oaJHOW1wStY5Ifuv614aw0q1scMKFdAVHkGK8
	 609C6cfWlaMxPRBMZUq1e25FS6p2oOpWgxZf284s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaofeng Chen <zhaofeng.chen@certik.com>,
	Yuxiao Wang <yuxiao.wang@certik.com>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 5.15 197/571] nitro_enclaves: fix use-after-free on SLOT_ALLOC failure
Date: Wed, 28 Oct 2026 17:55:44 +0100
Message-ID: <20261028170012.682187121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuxiao Wang <yuxiao.wang@certik.com>

commit 9bc184a2eda8b773c88ecbff934001ad649b9cc1 upstream.

When ne_create_vm_ioctl() fails the SLOT_ALLOC request after
anon_inode_getfile() has succeeded, the error path calls
fput(enclave_file) and then frees ne_enclave.

In normal userspace context, fput() defers the final __fput() via
task_work. ne_enclave_release() therefore runs after ne_enclave has
already been freed and dereferences ne_enclave->slot_uid, causing a
use-after-free: KASAN: slab-use-after-free in ne_enclave_release.

The enclave has no slot allocated and is not yet linked into the
enclaves list on this error path, so ne_enclave_release() is expected
to return early when slot_uid is zero. However, reading slot_uid
already accesses the freed object.

Clear enclave_file->private_data before fput() on the error path.
ne_enclave_release() then returns immediately when private_data is
NULL, leaving the ioctl error path as the sole owner of ne_enclave.
This is safe because the file has not been fd_install()'d yet.

Tested on an AWS EC2 m5.2xlarge with CONFIG_KASAN=y. Without the
patch, the reproducer triggers a KASAN slab-use-after-free on every
SLOT_ALLOC failure. With the patch, no KASAN report is produced and
the SLOT_ALLOC error is still returned. Normal enclave creation and
teardown are unaffected.

Fixes: 9c8eb50fe9e2 ("nitro_enclaves: Add logic for terminating an enclave")
Cc: stable@vger.kernel.org
Co-developed-by: Zhaofeng Chen <zhaofeng.chen@certik.com>
Signed-off-by: Zhaofeng Chen <zhaofeng.chen@certik.com>
Signed-off-by: Yuxiao Wang <yuxiao.wang@certik.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
Link: https://patch.msgid.link/20260909124400.27857-1-graf@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1654,6 +1654,7 @@ static int ne_create_vm_ioctl(struct ne_
 	return enclave_fd;
 
 put_file:
+	enclave_file->private_data = NULL;
 	fput(enclave_file);
 put_fd:
 	put_unused_fd(enclave_fd);


