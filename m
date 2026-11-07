Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065372;
	b=OtHQ2X4oXGnvFvpFhJ6Jf/pO98LGNLZTQwT+x4deEbje0uWnO5Ffbiz8+LHsFpgicohd
	 mT0KuzI7uBrWu3cFUgz7zUS+miytAO6voKw7Y+xooSi59DrKN1Wn0l4uaE7sDpmUvmWcy
	 deY/NehVglvRPkCel4M4CzWh91d5ac93koaNq6MQlgweKzt1fMi9QlgWHErBJmAuW5RI8
	 LUCeHK1RdhTpPUol4DaOoIPIF3JtKRGWcAzv6ZhdF/BWY22rCOLcQEwrQrYDlZ9fMn1D+
	 klMGxSe1O5I5Gsro7U95/7FKjURkKg7zDJTI625wU1GYRUeuTqHMOXU+gxIUrPmRU6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0B9jCT1FXiD8ASjKVSdYcrWmCxTYK95o/LcdQTvmPHc=;
	b=DrQyYoQ7e1f+fgJCYdhw2mc9Js8+iUzSsoy0nCMBFcMX/8rkxIl6dAdDqFa6eaD1ZfcQ
	 0srh553+OZyKwoe3Zkp/st8dJCIcMnmhCSmTKwD/ak5UEmEcVv059+MDU5cyrt5Aa25qy
	 vsdz0LLJIKTw6VhTX8Tbe8YZKSV0XbBK20sUfiVOsqs+KbkXxkuXVePKc1i1deljsdKd7
	 u4/LZQ5GpG3MA9cW3Ly6UIDU3oZQ7RKcJtylI1kevJCBhKO0lZksLD5hsxvtTGQjXjWZN
	 s0CvqC4zBlS0xavVxZLiHVNNpkY1LWD7vhKiEmA6mTsK6UyVpXTZcU8nEF/Qq3cfv1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W96P7mQY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4AF606A335;
	Sat,  7 Nov 2026 15:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W96P7mQY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1161F0089F;
	Sat,  7 Nov 2026 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065372;
	bh=0B9jCT1FXiD8ASjKVSdYcrWmCxTYK95o/LcdQTvmPHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W96P7mQYB5bb3ZbB40d0YOMxowo81+3ph02E976w0dqF4TdkykQRsyM9FM6fgZtJp
	 Yq46kBt9Xtv73u6U9JOLQPWY7POlj0ShL1/JeOgQqOGn6npFVBDlVWSPha2v2JeG0C
	 ZqBHod8FamheS504Y2+e5RGjX9yB2UzjzHebQbrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Garcia <berto@igalia.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1102/1257] ext4: refuse encryption when block size > page size
Date: Sat,  7 Nov 2026 08:56:38 -0500
Message-ID: <20261107135009.700759823@linuxfoundation.org>
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

From: Alberto Garcia <berto@igalia.com>

[ Upstream commit 0e341d1d29db11c29211d2b8870a515c26589d5a ]

Encryption is not supported when a filesystem's block size is larger
than the page size, and commit 709f0f1f1bf5 ("ext4: add checks for
large folio incompatibilities when BS > PS") added a check to refuse
mounting such a filesystem.

However, it is also possible to enable the "encrypt" feature on a
filesystem that is already mounted (with tune2fs -O encrypt). Once
that happens it won't be possible to mount the filesystem again in
the future, but there is nothing preventing the user from setting an
encryption policy while the filesystem is still mounted.

Fix this by refusing to set an fscrypt context in ext4_set_context()
when the block size is larger than the page size.

Fixes: 709f0f1f1bf5 ("ext4: add checks for large folio incompatibilities when BS > PS")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Alberto Garcia <berto@igalia.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Link: https://patch.msgid.link/093b40e9df29fc102907092f4ff73461f4cfcbfd.1790343958.git.berto@igalia.com
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/crypto.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 1a0fccb084ef5..318b2eaea7412 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -156,6 +156,15 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (ext4_test_inode_flag(inode, EXT4_INODE_DAX))
 		return -EOPNOTSUPP;
 
+	/*
+	 * Encryption is not supported when the block size is larger
+	 * than the page size.  This is rejected at mount time by
+	 * ext4_check_large_folio(), and this check here is for the case
+	 * when the 'encrypt' feature is enabled on a mounted filesystem.
+	 */
+	if (inode->i_sb->s_blocksize > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
 	res = ext4_convert_inline_data(inode);
 	if (res)
 		return res;
-- 
2.53.0



