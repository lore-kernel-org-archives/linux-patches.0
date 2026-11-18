Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027036;
	b=n25hNUPAF8RXRCUYqTInb4wf20Vptj+j7OxJhKwpZl/J7fJae4ByyHA8XF6yeX12l2Q2
	 az54lTdezxSx0mVo7HouHhK6OnHvZ3dbqlUVDt21ecGywuZ4UVDnUpvbKbUcJ1laTE5PB
	 Uq9ldEMTEVpozvX7IAxxa260+gNjP4WvNSVqzRmPpgazpWX0yzPZ97mto7AFnn+1a+TPD
	 j+/lbKBlds/e3MGnb5dAvXtG/fLEWG5mSveLcb28pjpLxVSOdTrBJxIu0h6UA1khsGKQ4
	 fRkfIa1aA9AgvWy8HUKTlv2y+vkTWXsR1zk7Dazjy6ynU24hChNWLqjU17/zHmIy8yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xf06eYFp1tL5rjfFWYApFJ4NovXONbWg7io2WcuIToI=;
	b=MVEPxOj49ciYUG+hqW2h5B6jSs/p/RIpu3mtUC3MCDbKgcEqxvlbcCft/7dWZ3w8aHTu
	 Po14FkVu98F3FI5qE0o5ojQScaiSRA/BHy6LgGQuNDo8hAG6nw796s21Yo8U+icfi8NSO
	 3ZRNG++wq2izAHy2f+VJiYioekmlwve+0ie0rfkJ5WsePfIA3jxkJp6qTsXRtAr1f0FHg
	 yA6ycW1Jx/7AhWI0ueGRVzbEpWm2CnFOMp6YHVDcA0C+eEv7ISVP29TqHpN4wF50Mp1XL
	 EtHkgmF+UlFrb1PbJ1xVVM49G65bjsFfy1lgtF0x1TA9N2gybEjPDEUJMyzY7Rx8k3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FX8VEmB7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BA7606A32A;
	Wed, 18 Nov 2026 18:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FX8VEmB7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D9C1F000C4;
	Wed, 18 Nov 2026 18:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027036;
	bh=xf06eYFp1tL5rjfFWYApFJ4NovXONbWg7io2WcuIToI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FX8VEmB7WYOEQZZTU6zEEY0EbaHpR8/a+wBFu32HvOnJAe2DpfbuDtA61Yek6mf39
	 zGRLCql+m/TYi72prO1dCfUzz8d5WqT2iDgUnNjNKIw1jCINN8JjXIwDuw8AysSj5V
	 YJeJvyi7UbGzB6lXAVbB/p3MZwBk/3uzrIs54gaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	syzbot@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1605/2151] ext4: fix orig_mlen initialization in ext4_map_blocks()
Date: Wed, 18 Nov 2026 15:55:40 +0100
Message-ID: <20261118150220.334411245@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 3ec0eefc07cb9e2bb1193f1fa3d8157302a737f5 ]

Save orig_mlen after clamping map->m_len to INT_MAX. Otherwise, the
unclamped value may be passed below, bypassing its overflow protection.

Fixes: 5bb12b1837c0 ("ext4: Add support for EXT4_GET_BLOCKS_QUERY_LEAF_BLOCKS")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Tested-by: syzbot@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20261009103033.2920530-6-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 47ce682ae17fa..d46d243d53c47 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -702,7 +702,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	struct extent_status es;
 	int retval;
 	int ret = 0;
-	unsigned int orig_mlen = map->m_len;
+	unsigned int orig_mlen;
 #ifdef ES_AGGRESSIVE_TEST
 	struct ext4_map_blocks orig_map;
 
@@ -718,6 +718,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (unlikely(map->m_len > INT_MAX))
 		map->m_len = INT_MAX;
+	orig_mlen = map->m_len;
 
 	/* We can handle the block number less than EXT_MAX_BLOCKS */
 	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
-- 
2.53.0



