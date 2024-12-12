Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CAB23EC07;
	Thu, 12 Dec 2024 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021361; cv=none; b=p0dS0CI0Poz+4o2ZPOWE/aXMlMfwTJGifsuVn/nevNDvhiVqX73Hc4O1OlpVWcTx4v/G9Cn93rnBxGzpZ1ArLEa+fH3x7LxvFB6kyaSNmBzyw8FuIoT9jWQHr2B2zWClNOV1xFUI4UIb6LKB+ShQhxw99yPbTkjHdSTIcJZbrVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021361; c=relaxed/simple;
	bh=geeh9+2EjfATAAkccU2ZVPBWlzWZ0AW3anOGKN6bB4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTHj+clk6mkka+EoPTxe8vUYtE0FjR8UYkT6t4pfMEi4/EzG6BuzIIxNQUJOu/ecfOWNy9nlnAfwvhsp+vMWp85jIdpFlo5LHcaXo1B4Z3bxEOtibveWd7s7Z2fpVTGVf+U0Wr7LRP7r0ig0qvSxLoKecbUeYK+EJEkrnuu4Cdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afLik/FH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afLik/FH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA36C4CECE;
	Thu, 12 Dec 2024 16:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021360;
	bh=geeh9+2EjfATAAkccU2ZVPBWlzWZ0AW3anOGKN6bB4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afLik/FHuV5+V+UtMXJ0ki9UbNloqMeAVJBz379x7AsUTdIL/CAQ38hLX5iibfpq2
	 m83G/wUELljWqqALNeVbidwf/6yRF5xdKeEsjsa1EtgvKiYE5u2gMNCmfdBOlwj4DQ
	 DNUFmW7YLBPdz14oCTJW566hZXAH4LUSGVnHkfB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+412dea214d8baa3f7483@syzkaller.appspotmail.com,
	Nihar Chaithanya <niharchaithanya@gmail.com>,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 686/772] jfs: add a check to prevent array-index-out-of-bounds in dbAdjTree
Date: Thu, 12 Dec 2024 16:00:31 +0100
Message-ID: <20241212144418.263402475@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 30a56c37d9ecf..6509102e581a1 100644
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



