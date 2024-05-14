Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5315012FF70;
	Tue, 14 May 2024 10:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682525; cv=none; b=Wl3y8+6bPT+UR0pmLcQET3tiEGPq6HGOigliSMyK+FjMBimozAB8Pegkc7zP2PD4eID8WUCPSuiEOaJjuviodR+OYga9mfrHObeUxtPBCwwbovDbtFPwc65qz1LjMFKDZA7/8xEzzl9lgm7jrQQFeM8KT1y0EBFEB9rAPtdXRD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682525; c=relaxed/simple;
	bh=lXWcNTOjWCqiZ0IklJx9REI85gdQRtZETJqG7UFqzGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0jD7xFr1Pz4uN7ZaEpBveGrg8eIT00wtksEkTsyY79XstZeyy2GBj7Yr+ARwXtWqrmmha+xuUPkPrX72j2BqTBNyOx2LAjzMmgN2Wk0ieWmXCLECNEJOFx7ocS3ZPsWo8PzVuLmZelJqpThXvA/hHJ3Cv/RmuHP7B1rf6bfTj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsqH3JMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsqH3JMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5ADAC2BD10;
	Tue, 14 May 2024 10:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682525;
	bh=lXWcNTOjWCqiZ0IklJx9REI85gdQRtZETJqG7UFqzGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsqH3JMfkCH96Oiu+xMzD+NY6QyjVf8+Dn3f8f3B8iXoaCACWWHnLPhS44EhIjmox
	 nezpYJWYihE5Qwt7doWrACQUFyuPzq5j8uLI0kpb6Mv3BJsJDyg3+6dIaYp1Tw0ijL
	 x4NjFrddmN27ItV9UKnPPLL74j6qi/pZqWheZb+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 045/336] octeontx2-af: avoid off-by-one read from userspace
Date: Tue, 14 May 2024 12:14:09 +0200
Message-ID: <20240514101040.309464519@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index e6d7914ce61c4..e7eca8141e8c7 100644
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



