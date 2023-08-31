Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B33F8498
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:12:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28FCC433C9;
	Thu, 31 Aug 2023 11:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480344;
	bh=YObumt3eHckTNvyTsTNsInt8TltWDcWG5NHtU+jJcVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qk8wJ35J/P7bzQ6aCXkSEcHCykZ4AqaUZqEVBXtJlXNPj2IG+NI2AeU422vNHhFsR
	 sS/2QmTC94UyxbaBwfA0iQjdKZGLuY/eF7t2qshU5nh6QPpRkh807VFaaPz8RD6gjk
	 MmKbqJs+CFQV4p7DS3jUAepwrwb5YLKtbrgLP0HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <andrea.righi@canonical.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 6.4 2/9] module/decompress: use vmalloc() for zstd decompression workspace
Date: Thu, 31 Aug 2023 13:11:29 +0200
Message-ID: <20230831111127.784527986@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831111127.667900990@linuxfoundation.org>
References: <20230831111127.667900990@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <andrea.righi@canonical.com>

commit a419beac4a070aff63c520f36ebf7cb8a76a8ae5 upstream.

Using kmalloc() to allocate the decompression workspace for zstd may
trigger the following warning when large modules are loaded (i.e., xfs):

[    2.961884] WARNING: CPU: 1 PID: 254 at mm/page_alloc.c:4453 __alloc_pages+0x2c3/0x350
...
[    2.989033] Call Trace:
[    2.989841]  <TASK>
[    2.990614]  ? show_regs+0x6d/0x80
[    2.991573]  ? __warn+0x89/0x160
[    2.992485]  ? __alloc_pages+0x2c3/0x350
[    2.993520]  ? report_bug+0x17e/0x1b0
[    2.994506]  ? handle_bug+0x51/0xa0
[    2.995474]  ? exc_invalid_op+0x18/0x80
[    2.996469]  ? asm_exc_invalid_op+0x1b/0x20
[    2.997530]  ? module_zstd_decompress+0xdc/0x2a0
[    2.998665]  ? __alloc_pages+0x2c3/0x350
[    2.999695]  ? module_zstd_decompress+0xdc/0x2a0
[    3.000821]  __kmalloc_large_node+0x7a/0x150
[    3.001920]  __kmalloc+0xdb/0x170
[    3.002824]  module_zstd_decompress+0xdc/0x2a0
[    3.003857]  module_decompress+0x37/0xc0
[    3.004688]  init_module_from_file+0xd0/0x100
[    3.005668]  idempotent_init_module+0x11c/0x2b0
[    3.006632]  __x64_sys_finit_module+0x64/0xd0
[    3.007568]  do_syscall_64+0x59/0x90
[    3.008373]  ? ksys_read+0x73/0x100
[    3.009395]  ? exit_to_user_mode_prepare+0x30/0xb0
[    3.010531]  ? syscall_exit_to_user_mode+0x37/0x60
[    3.011662]  ? do_syscall_64+0x68/0x90
[    3.012511]  ? do_syscall_64+0x68/0x90
[    3.013364]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8

However, continuous physical memory does not seem to be required in
module_zstd_decompress(), so use vmalloc() instead, to prevent the
warning and avoid potential failures at loading compressed modules.

Fixes: 169a58ad824d ("module/decompress: Support zstd in-kernel decompression")
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/module/decompress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/module/decompress.c
+++ b/kernel/module/decompress.c
@@ -241,7 +241,7 @@ static ssize_t module_zstd_decompress(st
 	}
 
 	wksp_size = zstd_dstream_workspace_bound(header.windowSize);
-	wksp = kmalloc(wksp_size, GFP_KERNEL);
+	wksp = vmalloc(wksp_size);
 	if (!wksp) {
 		retval = -ENOMEM;
 		goto out;
@@ -284,7 +284,7 @@ static ssize_t module_zstd_decompress(st
 	retval = new_size;
 
  out:
-	kfree(wksp);
+	vfree(wksp);
 	return retval;
 }
 #else


