Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2BAA1547F0;
	Thu, 12 Dec 2024 15:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018271; cv=none; b=gLJ1Vt5wKsBP7jslUjIaCqGTJK5pVjSvbr67UISB2lFlQfNs4Ux6bqSYW0+GE58CHbt8gSBdZXSX24AAMmeOAyr6z2TsDLePSf0f8NoalvBYdX45I839aZWXFPkdj8wWYvipg4A/24v00v76xsAJAkWsOBvF6s910S3Vvn3roxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018271; c=relaxed/simple;
	bh=pVePtFmig52YruBYZMr68ffYc3Ux2+e43YsuCViswD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N9CS8mJnIWG7XXb1vjOt0T2aogp/+SwmQRMuZTqzU7D3cM2Kr0cGghmFbYwqREHpJavR4dHedQzWtsP7aectig/Fqsym7N8U+Fsdh8G7YMIYYKZbxotvUMx0c5NyTuY6iLlwLBL0QhAXmdlmEXbwupvRzzxGeXkMGjxDR4U56eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SquwGQC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SquwGQC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00816C4CECE;
	Thu, 12 Dec 2024 15:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018270;
	bh=pVePtFmig52YruBYZMr68ffYc3Ux2+e43YsuCViswD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SquwGQC+o2L0tkn+x7Nmti5MsTOsCqXprThamyePhZBFNROI1xX3Py53AIO0C5xXq
	 Jt5XB7ca5bJPsbQy3qL6VVVhsdUMSeW4D7hrir6DrTqiP6JOYqKDOYsN890Ogii046
	 GGYZRlpp4/9+oBJFTOClpsGw2fIwR1GIVczOWSig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/356] jfs: add a check to prevent array-index-out-of-bounds in dbAdjTree
Date: Thu, 12 Dec 2024 15:59:25 +0100
Message-ID: <20241212144254.328621877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nihar Chaithanya <niharchaithanya@gmail.com>

[ Upstream commit a174706ba4dad895c40b1d2277bade16dfacdcd9 ]

When the value of lp is 0 at the beginning of the for loop, it will
become negative in the next assignment and we should bail out.

Reported-by: syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=412dea214d8baa3f7483
Tested-by: syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com
Signed-off-by: Nihar Chaithanya <niharchaithanya@gmail.com>
Signed-off-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jfs/jfs_dmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 39957361a7eed..f9009e4f9ffd8 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2891,6 +2891,9 @@ static void dbAdjTree(dmtree_t *tp, int leafno, int newval, bool is_ctl)
 	/* bubble the new value up the tree as required.
 	 */
 	for (k = 0; k < le32_to_cpu(tp->dmt_height); k++) {
+		if (lp == 0)
+			break;
+
 		/* get the index of the first leaf of the 4 leaf
 		 * group containing the specified leaf (leafno).
 		 */
-- 
2.43.0



