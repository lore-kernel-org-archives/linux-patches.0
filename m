Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D037F7EB;
	Tue, 14 May 2024 11:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687305; cv=none; b=FmanrBGHdNrHFUltAoC5WxBGrwngtedigAwXC6X+ggpRpVISDGnStRPWjQl95okzYUJqPTcxY1qMc8PRaMMI0oXsZd77oVnp56IHaN0LkKnKPmwWO02IJQhkkpAuPPUgZ9SoWCOIGmGaYVfoZTr/oO8Pme0gdm6reDgXBenWufw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687305; c=relaxed/simple;
	bh=OZ5Wxz376ioaR+bn7Htbtzy9h6g9FBxn6eEzw6DaQXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjGzE6PvPqmZxLnVzVwLqa2QxAjTe0NSKdEbCfe5TA+VfJSs7ETAigSq+1D7WBsxg3hzGD/QLcN8y6KfLNUEuQlY8BkXPdcYtMLvG4yHSEluxaCXXGlJqZ2/2YyxrUnW8LuHZkQXXfvNIABqFT6fhWfzAtQFzwC+KvT3FudSOms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXp0/gU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXp0/gU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E2AC32781;
	Tue, 14 May 2024 11:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687305;
	bh=OZ5Wxz376ioaR+bn7Htbtzy9h6g9FBxn6eEzw6DaQXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXp0/gU1NJSZdoHMOt4/V5vmlQXQMf7yVJG1qmIiSWnMFrI9G8pWC8dFfOfpamlNh
	 laFPlVIeY+zsiA4B4+62MpQFQiihDrox0Co54QaPZzXlaGm7zwhAgg4VjNUtKEofap
	 RmXqW+mJN/QHU/ZaIgxrn46SF5jmiqibBMlv+Vzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/111] octeontx2-af: avoid off-by-one read from userspace
Date: Tue, 14 May 2024 12:19:21 +0200
Message-ID: <20240514100958.006370391@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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
index 5205796859f6c..d212bab3ddbae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -420,12 +420,10 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
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



