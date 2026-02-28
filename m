Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B564A341C;
	Sat, 28 Feb 2026 17:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301310; cv=none; b=biuOIUlF0NnkC1/IsFp6wjpXPgmZMIiQkAZEuXX6ro7HiulhtV7+oiZQHPv4FJIjqZDqMIjl0r6/B7JX0HdLot1PheqVlCV5ubcIGYNmj8wwvIDg9QTiNJiIegvk8g3C0AJfEbJH3boZZzp33av01SIoQROot1CYr1ZKkAdheWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301310; c=relaxed/simple;
	bh=XMJpDTLdhtk0HnBKXtLfwrh8DmxRCR19o+jYxY50M94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofgWfC9zlEMXrgHnGcAaSn6UaJfi/IvgJp5AHwfReh5rS+snHmY0oOvD/E3F8FWAEjgMi0Vps2VoeazOVDuswH4tinBqjmHDzrYyiHOUTKzx9LFSz6LA7zvGes4lV7yOVe3mrb1FBGJSDERBxVhJBvmwWZyX9d4OfOWVTdG5cJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s2dBcI7e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s2dBcI7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C348C116D0;
	Sat, 28 Feb 2026 17:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301310;
	bh=XMJpDTLdhtk0HnBKXtLfwrh8DmxRCR19o+jYxY50M94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s2dBcI7eQZilL31ko7zBv8DIbMoTcjyruPCG1pWc6rxPBLC9Nq/EOcdZXkTcLF9t5
	 O5l1i5o7CCADbFiMLfafoOkQWvbzil+LXoPlXhOtUeaU7nU0cXz+nL7zTTyBc/BF+1
	 zbEudck9Tuwt2QIlcBzUeUVSfFNv3MJ/xtDVZeGCP7bdl6B4kjYHSLGEUI/m6dhHDo
	 owYNMT9rRlGajMm7+aeGRdGIUOrntACP0x/TlhGU3sbWkKMm6zb6ig71ppUPk6jzuP
	 UIB62Z2ZkbYenpErRfwSmHCe0BDBSwbF28RnLlOWlM9bMrVjJFpFh0xTuDYY1LssCb
	 sM47USZvqOSYw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Breno Leitao <leitao@debian.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Pratyush Yadav <pratyush@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 495/752] arm64: kernel: initialize missing kexec_buf->random field
Date: Sat, 28 Feb 2026 12:43:26 -0500
Message-ID: <20260228174750.1542406-495-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yeoreum Yun <yeoreum.yun@arm.com>

[ Upstream commit 15dd20dda979ebab72f6df97845828e78d63ab91 ]

Commit bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
introduced the kexec_buf->random field to enable random placement of
kexec_buf.

However, this field was never properly initialized for kexec images
that do not need to be placed randomly, leading to the following UBSAN
warning:

[  +0.364528] ------------[ cut here ]------------
[  +0.000019] UBSAN: invalid-load in ./include/linux/kexec.h:210:12
[  +0.000131] load of value 2 is not a valid value for type 'bool' (aka '_Bool')
[  +0.000003] CPU: 4 UID: 0 PID: 927 Comm: kexec Not tainted 6.18.0-rc7+ #3 PREEMPT(full)
[  +0.000002] Hardware name: QEMU QEMU Virtual Machine, BIOS 0.0.0 02/06/2015
[  +0.000000] Call trace:
[  +0.000001]  show_stack+0x24/0x40 (C)
[  +0.000006]  __dump_stack+0x28/0x48
[  +0.000002]  dump_stack_lvl+0x7c/0xb0
[  +0.000002]  dump_stack+0x18/0x34
[  +0.000001]  ubsan_epilogue+0x10/0x50
[  +0.000002]  __ubsan_handle_load_invalid_value+0xc8/0xd0
[  +0.000003]  locate_mem_hole_callback+0x28c/0x2a0
[  +0.000003]  kexec_locate_mem_hole+0xf4/0x2f0
[  +0.000001]  kexec_add_buffer+0xa8/0x178
[  +0.000002]  image_load+0xf0/0x258
[  +0.000001]  __arm64_sys_kexec_file_load+0x510/0x718
[  +0.000002]  invoke_syscall+0x68/0xe8
[  +0.000001]  el0_svc_common+0xb0/0xf8
[  +0.000002]  do_el0_svc+0x28/0x48
[  +0.000001]  el0_svc+0x40/0xe8
[  +0.000002]  el0t_64_sync_handler+0x84/0x140
[  +0.000002]  el0t_64_sync+0x1bc/0x1c0

To address this, initialise kexec_buf->random field properly.

Fixes: bf454ec31add ("kexec_file: allow to place kexec_buf randomly")
Suggested-by: Breno Leitao <leitao@debian.org>
Cc: stable@vger.kernel.org
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/all/oninomspajhxp4omtdapxnckxydbk2nzmrix7rggmpukpnzadw@c67o7njgdgm3/ [1]
Link: https://lore.kernel.org/all/20250825180531.94bfb86a26a43127c0a1296f@linux-foundation.org/ [2]
Link: https://lkml.kernel.org/r/20250826-akpm-v1-1-3c831f0e3799@debian.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/kexec_image.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
index 532d72ea42ee8..b70f4df15a1ae 100644
--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -41,7 +41,7 @@ static void *image_load(struct kimage *image,
 	struct arm64_image_header *h;
 	u64 flags, value;
 	bool be_image, be_kernel;
-	struct kexec_buf kbuf;
+	struct kexec_buf kbuf = {};
 	unsigned long text_offset, kernel_segment_number;
 	struct kexec_segment *kernel_segment;
 	int ret;
-- 
2.51.0

