Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F37B223C55;
	Thu, 12 Dec 2024 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025777; cv=none; b=OR3cjrvq17yVDCOzdj0Wx+KyJ1qiSbsId9ct+iliXGBjXh/X+Y8UEoiiR9PHsRmdPaNDAXJhvCycY4sQWLGqTxZOPjszJp+vpewdztBJdChLhsDyxqnNMV4UAP5V0e2NX74D4PthTZJ/kzhoQ0LXZlKKJGZ179v2lpViDxlU32Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025777; c=relaxed/simple;
	bh=TkKQcPoIY+hsXwNLswkjqLaDYKo7eNEzoeaQf39HEYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlN6xHhY9m+3GRAEg3Yt6KdQ93UZyLXZsktiCWjBYWgmbMzUMFdffLMcNT5MxH009adFzPUyS0tE5IAYRbInkSu5Srd+CqI6VetOlDg+XGOYEmxTOog15vSNo6bmqFeMCVd6wIO2Eym6JwIKrdhDd1f+Snr+IR1xiDdzX/qyLtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTKYdgRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTKYdgRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA601C4CECE;
	Thu, 12 Dec 2024 17:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025777;
	bh=TkKQcPoIY+hsXwNLswkjqLaDYKo7eNEzoeaQf39HEYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTKYdgRFVXkQ+o4T22Q5fgFvttQIRtSc8JDa4KtMJVckOf+OyiBTnt1/9g27cPJsb
	 P2rLRd77JA3gtE3MfKXxAa6prvBFDpB1jbbodVgTz78LjCoLPGB3YY7FSe5d+z7uAT
	 dVJRZLpKRnH+7ihfBKARSoIZ0sfsC/T2ORIhuDdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 285/321] jfs: add a check to prevent array-index-out-of-bounds in dbAdjTree
Date: Thu, 12 Dec 2024 16:03:23 +0100
Message-ID: <20241212144241.241736123@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d83ac5f5888a4..812945c8e3840 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -2953,6 +2953,9 @@ static void dbAdjTree(dmtree_t *tp, int leafno, int newval, bool is_ctl)
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



