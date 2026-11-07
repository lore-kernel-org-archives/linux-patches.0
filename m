Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063456;
	b=KT0adyfgtc96IS5rgYg7DINcIAg3vNOESrm8HAcm+lETR1OzER3AG3QnT0tdYTGHllc+
	 vTQ8d08dtWyQXWpk5FPwwbN7rWwz5y+M6+v4QvKMYch8ixZXLREdGnJLqrjEC1hidYPg9
	 qunOJomcOBjt+2+lV4ku3m8DhDi2Aw/thdK4nuXgZ9AHb5Qs2pymRbh67jy7IBvsuK3wc
	 qoZi+7Ixi49TvA3j4eUJgwTp7QYSJefs6wf1QszzG0P5Cvk2HutHqHnzXI+44R8afhheC
	 PUQtPbpRgW94cMc7THvZqJE98zwDY9m+5IhISqnbRET+LsCe/ESt9GDDqIKsfSULVpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ea0TZHxX13NvMFWvargQRgBW/whXXyqQ5WzoLtehH4Q=;
	b=yOy7hs2cLPXfqoTk24HAgu53Dk4qQA26f9PdoCNeLt8lfmqCbbOw3KK6MYu5JYbctbuL
	 E8LKmS6MmCaV3bdXv1lHgHHDQtUV38g2wpa7f8WcPxDgAs0JsuhuD+nir6lH3FeVbcyd5
	 2a6XupuGJaer50nIVtcYXs+45rxqwmBHBh26AzXLd9bp9o1Qn8gfm5XYT3PlQLUlioS6u
	 xm4Fr6X3vUuKjMMdFbyO9gn+Wz8yxX6/opMFmE/uD6TiESLIoCI0+eoIp0PBx2GBIgZWc
	 anmUuoE1B9BmYd48Rlf37MK4a2NcQnoDawEGFo6D52lDVn5MstfdQNkKE6/0IH8eXFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6AiA4+0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4C260A5BE2;
	Sat,  7 Nov 2026 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c6AiA4+0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8C31F0089F;
	Sat,  7 Nov 2026 14:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063456;
	bh=ea0TZHxX13NvMFWvargQRgBW/whXXyqQ5WzoLtehH4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6AiA4+0HNQKE7H13yb1Kb4oPi+sm1djIOYigblt94IwBaUupvIprb51J4cCVaQTS
	 ZHqVegNJTxAZZN2g+cZloWwwbHTsCalP09/pMykFBXHMqaTutgBpQEs/+dV+y7b0OH
	 c+ukEInVuKJ+z1fpLURaxaKqUiecm0L+GlLhN0PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 613/869] fuse: fix copy_file_range reply handling race
Date: Sat,  7 Nov 2026 08:54:55 -0500
Message-ID: <20261107134913.849754490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit bf4ccbaad8bdff8c90fd290ed6135b63f89ee8a7 ]

__fuse_copy_file_range() selects its request opcode and output buffer
using fc->no_copy_file_range_64, then reads the flag again to handle the
reply. Copies to different destination inodes can run concurrently on
the same connection, so the flag may change while a request is pending.

For example, task A submits FUSE_COPY_FILE_RANGE_64 and waits for its
reply. Task B submits the same opcode, receives -ENOSYS and sets
no_copy_file_range_64. When A receives a successful reply, it reads the
uninitialized outarg.size instead of outarg_64.bytes_copied. This can
produce an incorrect return value, page cache invalidation range and
inode size update, and disclose stack contents if automatic stack
initialization is disabled.

If A also receives -ENOSYS, it instead mistakes that reply for rejection
of the legacy opcode and sets no_copy_file_range, skipping the legacy
fallback and unnecessarily disabling copy offload for the connection.

KCSAN reported the conflicting accesses:

  BUG: KCSAN: data-race in __fuse_copy_file_range / __fuse_copy_file_range

  read to 0xffff8881014a4d4d of 1 bytes by task 123 on cpu 4:
   __fuse_copy_file_range+0x1a7/0x6e0
   fuse_copy_file_range+0x54/0xd0
   vfs_copy_file_range+0x290/0x9d0
   __do_sys_copy_file_range+0x10f/0x2f0

  write to 0xffff8881014a4d4d of 8 bytes by task 119 on cpu 0:
   __fuse_copy_file_range+0x633/0x6e0
   fuse_copy_file_range+0x54/0xd0
   vfs_copy_file_range+0x290/0x9d0
   __do_sys_copy_file_range+0x10f/0x2f0

The bug can lead to leak kernel base address for KASLR bypass, the
corresponding reproducer can be provided per request.

Use args.opcode for both -ENOSYS handling and output buffer selection.
It records the opcode actually sent and is updated on fallback, keeping
each reply tied to its request regardless of concurrent flag updates.

Fixes: 7a37f55af7af ("fuse: add COPY_FILE_RANGE_64 that allows large copies")
Cc: stable@vger.kernel.org
Assisted-by: GPT-6 Astra
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 22b3f37ec88b8..f72d74e3c5f03 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3078,7 +3078,7 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	}
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
-		if (fc->no_copy_file_range_64) {
+		if (args.opcode == FUSE_COPY_FILE_RANGE) {
 			fc->no_copy_file_range = 1;
 			err = -EOPNOTSUPP;
 		} else {
@@ -3089,7 +3089,7 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (err)
 		goto out;
 
-	bytes_copied = fc->no_copy_file_range_64 ?
+	bytes_copied = args.opcode == FUSE_COPY_FILE_RANGE ?
 		outarg.size : outarg_64.bytes_copied;
 
 	if (bytes_copied > len) {
-- 
2.53.0



