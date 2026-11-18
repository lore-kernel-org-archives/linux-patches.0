Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053797;
	b=Godg8s4TU/TLnbiO/hZkClP0Pk2YOFVGw54oE+w3mwnBeom5oG93sWDwTACDup0qsJ3B
	 u7htaGgr4682utvDzvdpEo9W9/CAtKU2u+2e+qsM8OS5qILoAz6R5Ul7mydVP2nWr70Xt
	 qqed/VxroGRzbYsBEc3dk+TSS90FfRKMXd2NytyhxuXZDiRKSXv6jAdWfq4zsHv1z8PGE
	 EbWXgOag1Rv+aM0VKYl+HUzjO09+qdbNd16gTwsyPTT+twAYSOXP1p2mnQMg/o7u4yNHc
	 mZahEeV35ERJ7v06xzsBXUhHXqlQWQt6NLLmCzC0TTP29S8PmIgcY2ZclaY/kslDLyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cuPrNCRy5vzY/6zR2MCAlgaoV9bnqh95YZtA5aExZp8=;
	b=ejpnkm3ydu9Bls4m8E0/VsSuUbe/q50ro3SAdKhS6ibFwELl/DL5OvSQ2TiguUFbD3UQ
	 NNTs85ZOI0e9fMkgEOAwKP1vnJxhPKQhSdttJZUlYqxua+haXRcBKSCyy3pXP7AL4Jbz1
	 cYoBQw/Fr8521ZmjhdQzlxgdk917FFQwt5HS+NRNRUgJuIMIpwTQCfPlnVPoZMRpcb5Hf
	 VqGxJA+ZUPERfEtJnpk2z1T29ZPJ1V5UWnbXHBfguDljqT+FBUDdQsnvy5BcdrbQ2ZMYm
	 CCIZfCxiMAsdqmtPeh3jiz2MUCB+4TCwY0jBEnK1yMNKLoAas6ICDZ7gXasVTpecUXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOuC4Wn1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63063606A31C;
	Thu, 19 Nov 2026 02:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOuC4Wn1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA7DC1F000C4;
	Thu, 19 Nov 2026 02:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053797;
	bh=cuPrNCRy5vzY/6zR2MCAlgaoV9bnqh95YZtA5aExZp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOuC4Wn10mgPCMLJE/zf65nYH/Cv6gv36JoM9GnsDFPtODxkwHgzL9MK5XtAz5NiK
	 c59OEmw3N6U0delUMEMsftJf+qJgSn1WgxI1wN9+z7+vtjMnI+voDx0QVotnwInof6
	 O3YkLeuc+ZrekYS/1oBZJqJK23MAb48MrCOvFKGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1046/2214] f2fs: return -EIO for a lost inode block after cp_error
Date: Wed, 18 Nov 2026 15:45:22 +0100
Message-ID: <20261118150054.176695307@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index e5a06a65a5398..65f3501b939e0 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -777,8 +777,20 @@ int f2fs_get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
 
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



