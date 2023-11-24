Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BA434189;
	Fri, 24 Nov 2023 19:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQc3b0LH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC8CC433C8;
	Fri, 24 Nov 2023 19:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852643;
	bh=3yLj1Ew0IYC6SdI7tqMLEWkH85LUTO8uPadn8aNsa8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQc3b0LHPCbOO+ceZ28MBRaokpwfmmK4iMGnroyGIxULXJjezu1L8o+Yv0PaofIqF
	 H1UKuayVSQnO1mdjHJhZR9b0pqve62AhPxQmjTLRmtwH8tpakNc3QurdE+dhtwoppm
	 9JlSr5nDFdGiP83+3Posb1RmvpjITlCj/JG+OjNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+debee9ab7ae2b34b0307@syzkaller.appspotmail.com,
	Juntong Deng <juntong.deng@outlook.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/193] fs/jfs: Add check for negative db_l2nbperpage
Date: Fri, 24 Nov 2023 17:52:37 +0000
Message-ID: <20231124171948.400768169@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juntong Deng <juntong.deng@outlook.com>

[ Upstream commit 525b861a008143048535011f3816d407940f4bfa ]

l2nbperpage is log2(number of blks per page), and the minimum legal
value should be 0, not negative.

In the case of l2nbperpage being negative, an error will occur
when subsequently used as shift exponent.

Syzbot reported this bug:

UBSAN: shift-out-of-bounds in fs/jfs/jfs_dmap.c:799:12
shift exponent -16777216 is negative

Reported-by: syzbot+debee9ab7ae2b34b0307@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=debee9ab7ae2b34b0307
Signed-off-by: Juntong Deng <juntong.deng@outlook.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index a9c078fc2302a..06dda2c7a6e24 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -180,7 +180,8 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_nfree = le64_to_cpu(dbmp_le->dn_nfree);
 
 	bmp->db_l2nbperpage = le32_to_cpu(dbmp_le->dn_l2nbperpage);
-	if (bmp->db_l2nbperpage > L2PSIZE - L2MINBLOCKSIZE) {
+	if (bmp->db_l2nbperpage > L2PSIZE - L2MINBLOCKSIZE ||
+		bmp->db_l2nbperpage < 0) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
-- 
2.42.0



