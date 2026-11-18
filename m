Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038425;
	b=UDEFqyDMaH4vINDpmmQwKRZ/kbJtPunHIptxbaKtXdUkWA8beBwu0Lb2kXwPo8VB/7fY
	 4SvU63CWPlGtzLvPH3LTpxwNQYa4nu515ShJP89RnoEe/300u06R489mzPqmOKbmAF69+
	 YWipCPwAWadTELrKY/JKgi5dEAeG5S66BpphpeUIRw2QmkrLXP/qSpXXQUas85BohZHoN
	 gyHFPuQYL7SpHSI3Uhgc1vMLnKvsAQfvrUSX+GmheKzaZUw6G7SqbVcHO8tA/lEg/W0fV
	 gcawTuJs01Z1FIY2hRwPPpgLYXrfvIKH8dciHPEkpfQACPZfKFmjhtcrWcBNTUcEo2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9zy4hItJbcIWLHXN7G7HnhzbdObj8MCPxgFoidUQjhQ=;
	b=e/+GPv/k5XaLOVxFdXePsuIUBtVcGGOi4014JgCi3kY+ni/3L8q1xuBGCdMuqynRkeYc
	 bpPsJTk855P8oUmoUdRsqcgT7N35ZNrbX4i0gU7Q3OaOnFR3y7QtWEX1ZCltN6UwSWJRr
	 Nb8ws8oQOSNaQf2hJSSVyva/sHrVM+uQaI4fY1SGe558iHywezN9lvMz9MVEwmB0p6yff
	 YuomP1aLQkM6/ePxPealWwSiN8rrCvpFf+7MnpYEZoAlbzTrf5xYiEZLKMZaDWfiojBnM
	 nkA6Hu5qtjYO3VOs7KnyUgCTBOuqtxMa5WGbU9rKeJ63jzNdtvqF+aB5ZoNN/iDQipw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xy0IcrTk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB55A606A31C;
	Wed, 18 Nov 2026 21:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xy0IcrTk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AB41F000C4;
	Wed, 18 Nov 2026 21:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038425;
	bh=9zy4hItJbcIWLHXN7G7HnhzbdObj8MCPxgFoidUQjhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xy0IcrTk/sLlBIWJ5WnJuXWWPhbOCKQ097vXMpitD01CHxYykBppMQzTu9CRpf7WF
	 uJUx/b2iQ26r4O0cyk9Rn8/7hWMJTFv91S436tzaWAE/luCNJcy9BSAw/fh563tfkG
	 Qk8P5uGoQbiiQR/s25EOyZ05WIrHK2utEfnxk9hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1698/3318] f2fs: return -EIO for a lost inode block after cp_error
Date: Wed, 18 Nov 2026 15:38:40 +0100
Message-ID: <20261118150412.777582557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit 53b12b63304b34a3850a901c4de3cc6ad08e0aee ]

After cp_error, dirty node caches are dropped without being written.
If such an inode was never written, its NAT entry is still NEW_ADDR,
and reading its inode block returns -ENOENT.

f2fs_get_dnode_of_data() passes that -ENOENT up, and callers take it
as a hole. Since the inode block is missing, the next offset can only
advance one block, so fiemap walks block by block up to maxbytes,
about 2^30 blocks, while holding the inode lock. It took hours in a
power-off recovery test after shutdown and blocked unlink and umount
on the file.

Return -EIO instead of -ENOENT when the inode block itself is missing
after cp_error or shutdown. A missing direct or indirect node is still
reported as -ENOENT.

Cc: stable@kernel.org
Fixes: 28607bf3aa6f ("f2fs: drop dirty node pages when cp is in error status")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 8aa52629f788c..557372582346d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -785,8 +785,20 @@ int f2fs_get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 
 	if (!npage[0]) {
 		npage[0] = f2fs_get_node_page(sbi, nids[0]);
-		if (IS_ERR(npage[0]))
-			return PTR_ERR(npage[0]);
+		if (IS_ERR(npage[0])) {
+			err = PTR_ERR(npage[0]);
+			/*
+			 * cp_error drops dirty node caches, so the inode block
+			 * of an inode that was never written reads as NEW_ADDR
+			 * and returns -ENOENT. It is not a hole; the inode is
+			 * gone. Callers treat -ENOENT as a hole and keep
+			 * looking block by block (e.g. fiemap up to maxbytes).
+			 */
+			if (err == -ENOENT && (f2fs_cp_error(sbi) ||
+					is_sbi_flag_set(sbi, SBI_IS_SHUTDOWN)))
+				err = -EIO;
+			return err;
+		}
 	}
 
 	/* if inline_data is set, should not report any block indices */
-- 
2.53.0



