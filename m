Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585911;
	b=VX/RpEQKlcxCPUNov7Wtrbb+e6Lu9rByMXqh1bOug8ITxXUcYKoUPkjiEScNTVsofhRK
	 FphpxeW9xnMYbEpjfsR4vBeAWZYrL4PlkJ7FRNZzHBFIIwlqrcNJJV1v0Y0P+gCudjCLU
	 fYkPawzeLELghXtjzKKDjysWpdCN0fXSw1s/GjW5eWm08KrTfkQzUqxdPL8Mo+LcwRJTC
	 FetRF89Ydd8PR3uhPtr6EyT3zbm8usbApyLIbzMcEk0sFuzterSaqsTYRlAblfXAPh8mj
	 XpF65EUdZvMSKvv82KgReZhqU6FkS2/VMpfpfIjlC5kvmNL3u8dPdLlcYdX4JqJf6Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XxbB6KfV3ZGBeOrMvZjmRNnbp/jeakRf8P8PI+evpt4=;
	b=ykn7V+IK6uZz9GalkKCIUEo+4X24YtbItToXY9M6VtGWwRfchfuM4DRGUlExy38jCUCE
	 biSepJMtDo1PAtOpZasrqMSuG4veUizXCw6ZK/yPSTZbiB2BYYhBOyjzkaQ2ZdJ8DX7JN
	 QMW77JGKp+NxR1PA24XKJrCasNG2auUoITYjwhdn9YUv6Du1kEEUPCZSGNo1jmGbdHcBC
	 1coLIqhlY9p6erIukn2q92lwdMSigApw0LLb1eMvkNIYDDISuJJxC/VPuwFlQRlhRPolp
	 7jOGO6htCeC8qT9Fp3xVFAtxul4SfTClwjsao89uy4cAzhIuquDlJiSORtjP922TTFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=reCjGK92;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DADB606FFFA;
	Fri, 13 Nov 2026 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=reCjGK92
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E981F000C6;
	Fri, 13 Nov 2026 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585911;
	bh=XxbB6KfV3ZGBeOrMvZjmRNnbp/jeakRf8P8PI+evpt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=reCjGK92fTYTwpPb8eQ6mye7G4qeO/Z75zymJZQRajVWNePDt7m08ugWtEYCibgu/
	 b+6zFihFbwquLg7XvXTxG3rAFlt5FLLJhXAL8fpJ6C5eHgigiVAUStnQbUL8LyfgjU
	 WS2D7ReMaB/VCiWOAGaH9pNRd/9g42uMGMZ8x/8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 475/507] f2fs: return -EIO for a lost inode block after cp_error
Date: Fri, 13 Nov 2026 10:52:59 -0500
Message-ID: <20261113153813.025087753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
[ sashal: Adapted node-cache access to the existing folio interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b23fe1383009a..70593f95abfb5 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -835,8 +835,20 @@ int f2fs_get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 
 	if (!dn->inode_folio) {
 		nfolio[0] = f2fs_get_inode_folio(sbi, nids[0]);
-		if (IS_ERR(nfolio[0]))
-			return PTR_ERR(nfolio[0]);
+		if (IS_ERR(nfolio[0])) {
+			err = PTR_ERR(nfolio[0]);
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
 	} else {
 		nfolio[0] = dn->inode_folio;
 	}
-- 
2.53.0



