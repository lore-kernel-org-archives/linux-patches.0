Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065022;
	b=oxeeTow279I9LymT4YoDeVl3XBJu4GDK/wcMSSkfUqm8e/NMAqjcHUiV+Av8NYVLxxvY
	 Inoe9UG5TlcABJohMGf5WXRQ544B7BbYGjvTV1UBVxqcDMAqu7fdk+CWyfs1oAsh7MvgS
	 1C1tLX4WSInZzvJljESb7OP2nU21sx4Z8cG/0AKc3xLwZuYwFk7LOljCNswgq8f+QUbCq
	 XwxYkVbRjunY7KFJphPQB30T2uBNLsYrNrahoD+ZDlnC1NTAEWFbMZiGl+irewx2C9oMZ
	 u9FQIp/VxZM/JBfmHT4FQs1yK85AYPCNSv8gwERIgnzN9FPkJki1lvJzFEyyNxhoizQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pkEIY4x3WT20z/Q6PyRGXq2miMa14xYXig9uZJwGP6g=;
	b=Ay2EUlaVW+P1e68TBIBo8P2r3NwJKAz9LjyPJTyO2I362ZD/xOPzmgZd2FOE8ahUhjSe
	 wD3szrW79S5St5OQYfVXSYvhssEqUswhb9QDZ3PugGuYQQyS+bpQY4LKQsl/ZDImLKR5z
	 qPJAWyB+Etqu7vjecqgXjZ2C2SzRi+QlV1ZyRDZ3GEscWIU34exfe/clp187XnjNM3HEZ
	 +8EfGt+6C9f9rnCM3EKFPJ1SA7Ns5Z10SdQQDI0Wn5QnoEzmhNUO8XXccbfnoDwy5rwRM
	 EZOsHxQ8xP45lLdRHRYwIKuRtAojdp0TWvvHY4zKxsM41bgbh33mtdZD2W8i59u5sbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j2Fxs9wC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7200606A336;
	Sat,  7 Nov 2026 15:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j2Fxs9wC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7821F0089F;
	Sat,  7 Nov 2026 15:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065021;
	bh=pkEIY4x3WT20z/Q6PyRGXq2miMa14xYXig9uZJwGP6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2Fxs9wCZtC5inr9vM1eEv3h/tR2MsTUJapQPApz10QSzsJGmSgM+1vSrggl0+m33
	 Lngh55NlKlTps/SQFZKut2rag5uacNnoiQ8Cj+VyABxiKvsSo25rFPsqzQKHUgMDtI
	 alxlGJGjvzMK7nY2owoWb7a/+r5zAydGrp3u4+9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0841/1257] fuse: fix copy_file_range reply handling race
Date: Sat,  7 Nov 2026 08:52:17 -0500
Message-ID: <20261107135002.553160889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 49266440cbedb..bf79c6eb3062c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3042,7 +3042,7 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	}
 	err = fuse_simple_request(fm, &args);
 	if (err == -ENOSYS) {
-		if (fc->no_copy_file_range_64) {
+		if (args.opcode == FUSE_COPY_FILE_RANGE) {
 			fc->no_copy_file_range = 1;
 			err = -EOPNOTSUPP;
 		} else {
@@ -3053,7 +3053,7 @@ static ssize_t __fuse_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (err)
 		goto out;
 
-	bytes_copied = fc->no_copy_file_range_64 ?
+	bytes_copied = args.opcode == FUSE_COPY_FILE_RANGE ?
 		outarg.size : outarg_64.bytes_copied;
 
 	if (bytes_copied > len) {
-- 
2.53.0



