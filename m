Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020499;
	b=oExWcrcDMa5VahkXwSHuRKhWkOcr63WZXJt9xVimxobDtkpdBkqg/4SAKisHvCE9Pb8N
	 yHHp0SysrvyniKxsUe1bAARFUCIIJUI+mvAgv1WBgm1sYLL6QnaOS/+q1wAWWbUHe5b1i
	 EtTQ1IajkK6sZBdshadeSN5x9tUwM6nVOFkB0pJpMlPUKytH/O8nw5m7sLGzrY5KhbRzi
	 h5TNBh+7gbO/rjBMtz+xaRwFJ+TLmeShUguSmPiTt3Le8SGyUfQN3Zqh/NQJYZpYRJ/R1
	 znN7NkmegcdwVL/58P0qbzZiY1m2KnUPXlkjG5cFVA+0MgeVUBy2yxGA6Lxg57qitOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AgCMgJBC5VJq/4au6a3SNTaWS865UE7J1sIZw5u6H9Y=;
	b=Uzz2piiFA4clrxuNF1LBrt1guxm8HG9dN+E2cf1VCX8jvVmzYTLF/UFCh9vzCKNLkqGQ
	 /i4Q+dJyNzCzDanE6nmce9GlGo37m3asY7NeDtQ6s3qyhnaovVEGFWl6phTydjnmdb9yI
	 oksdJQhiW4/0BuuPdnHQQsYhgiTvQeHu9sFQi+Vq4sr6myCB6M+KVBEVldHApd2vOOehu
	 +krHDoqcjcdXvWFRWJCIm/+HTXhK2yOCZ0Gs8SV+8SMQJDj6NEclN7VCTAB/+rt2wJQTm
	 /AsZoqE+BU2WOEh/2Daz72z2VbMGuxKxQjnjguON96aiSl1rc0eEWQEoyTXlWuVRObQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WgDWwtXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D39606A325;
	Wed, 18 Nov 2026 16:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WgDWwtXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9341F000C5;
	Wed, 18 Nov 2026 16:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020499;
	bh=AgCMgJBC5VJq/4au6a3SNTaWS865UE7J1sIZw5u6H9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgDWwtXEM0xbEnxYH4vRPMuQIsJcFScs0B5EgLyDWy170I41qwLoRBPHC9HTpEM4F
	 7o5pSvwXNfapInn5ONuNIEwLMbJq7yH+8qkVYF7dtHQIHFOmMBRRW44cwiAvKiNfMt
	 BsebXaTWdzZHu0nq6Kccu3nuJnHjRDH9XwXetX8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	syzbot@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1966/2651] ext4: fix orig_mlen initialization in ext4_map_blocks()
Date: Wed, 18 Nov 2026 15:53:26 +0100
Message-ID: <20261118150357.273498561@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 6697c33d3aa33..bd1c14b983768 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -703,7 +703,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	struct extent_status es;
 	int retval;
 	int ret = 0;
-	unsigned int orig_mlen = map->m_len;
+	unsigned int orig_mlen;
 #ifdef ES_AGGRESSIVE_TEST
 	struct ext4_map_blocks orig_map;
 
@@ -719,6 +719,7 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
 	 */
 	if (unlikely(map->m_len > INT_MAX))
 		map->m_len = INT_MAX;
+	orig_mlen = map->m_len;
 
 	/* We can handle the block number less than EXT_MAX_BLOCKS */
 	if (unlikely(map->m_lblk >= EXT_MAX_BLOCKS))
-- 
2.53.0



