Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA85457CBC;
	Tue, 14 May 2024 11:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686208; cv=none; b=lkXK56F84gqfM3cSJmw1ssaZZ6OLMwCTWYywaVXWfzuH0MhlgbjkWWiUoDDpn4z2vgiH4TXwJOrSdxE7ctnkNyc1UhM0pMPWt6DDbQAJkLwlOLO/OvCnHuvvZ3sN9njdbIWB4b9H4/N6GVGCM//YKCZ+Z2aDMba8pnF6ejJlklA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686208; c=relaxed/simple;
	bh=Mofh6irf3Nb8fXS4VFx48ggHNSti9LRzlXRzaprrXK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4iEQTrJsnpx3IloQ71qkB98nJxpGnTVqEEHuEP/eGd/1OE0VdVyi0z4IiEwFIdFzdUwjuhMuOjt0HHC5RbhHM7MBwyq1cWbLu+dfEkynAWO46fpmfXLo28D6vHQYCUhOcEK/EXHx9DPz7uPs25MUq1f99THZQW6mCssgo7juJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Znua4nlW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Znua4nlW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31274C2BD10;
	Tue, 14 May 2024 11:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686208;
	bh=Mofh6irf3Nb8fXS4VFx48ggHNSti9LRzlXRzaprrXK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Znua4nlWeoxVTt6WcAlYTwkrGlrCcD24O4i9r5gQ3UStNpDl8c6HtlfAjoYb716uI
	 WLHw10h/DYOA09M47ITR1bmeXm6lvremh2KK0QgLcSP8kEuZMCos/X7if5w5TreET9
	 vUxFdJg/n6wyA+XIybmpk7bsGsdEMmDuf2oW/Qf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/236] octeontx2-af: avoid off-by-one read from userspace
Date: Tue, 14 May 2024 12:17:01 +0200
Message-ID: <20240514101022.597457272@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Bui Quang Minh <minhquangbui99@gmail.com>

[ Upstream commit f299ee709fb45036454ca11e90cb2810fe771878 ]

We try to access count + 1 byte from userspace with memdup_user(buffer,
count + 1). However, the userspace only provides buffer of count bytes and
only these count bytes are verified to be okay to access. To ensure the
copied buffer is NUL terminated, we use memdup_user_nul instead.

Fixes: 3a2eb515d136 ("octeontx2-af: Fix an off by one in rvu_dbg_qsize_write()")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/20240424-fix-oob-read-v2-6-f1f1b53a10f4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index cc5d342e026c7..a3c1d82032f55 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -999,12 +999,10 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	u16 pcifunc;
 	int ret, lf;
 
-	cmd_buf = memdup_user(buffer, count + 1);
+	cmd_buf = memdup_user_nul(buffer, count);
 	if (IS_ERR(cmd_buf))
 		return -ENOMEM;
 
-	cmd_buf[count] = '\0';
-
 	cmd_buf_tmp = strchr(cmd_buf, '\n');
 	if (cmd_buf_tmp) {
 		*cmd_buf_tmp = '\0';
-- 
2.43.0



