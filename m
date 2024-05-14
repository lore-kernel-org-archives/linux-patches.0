Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BEA133402;
	Tue, 14 May 2024 11:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684514; cv=none; b=P+BtspMNJau6BVP8fn3+RuS0D/IXAi8ZtC7SGkftqWGidxlIY7iaUEi8fh32JUPNd1NQcZS/eCJvPgApuj02gzyUP7GOFJ2E33GJ6LoERhmgTIBg08rip+NxwY8sFPcjMyXFZw+Jiw4d3b4zdyl+3ck5wmYhBSQCmoLWV/aRwaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684514; c=relaxed/simple;
	bh=fqGVpp3oEW4sSiu9eK7l5YUadTB9dALqIlYgCi28Rc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYvJcf5K1IaU/F77YfduubYDzNOdxaI8frDMVeHOzyVS5NzncAQNRdHSPV2glsup25GF1tuSxn5nz/f33o2fAFJ94JbF3Wp+INTocsSZywUqFSbUb2SwxCjUY4OAHTIcNc13l4uITmZCjZtQZUTvcWWxxySJmroYgFGJ8i6rWM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=svOfL4kl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="svOfL4kl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2D9C2BD10;
	Tue, 14 May 2024 11:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684514;
	bh=fqGVpp3oEW4sSiu9eK7l5YUadTB9dALqIlYgCi28Rc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=svOfL4kl+OhibvyV//IRfK5d9URhDRaaz0bNA7rjCjxPdnn6qm7O6wxU2BiH3l7b9
	 QzT2nQiXQT6zhCvdIxSDH3jGi5xmMZxz2BvITUYimrdTKGlFGQcN3RkT7MKJ1M9btc
	 9NF5MCKc+o9s2pnR0xw2pMN5Uorc5LZDx7XdLt8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 050/301] octeontx2-af: avoid off-by-one read from userspace
Date: Tue, 14 May 2024 12:15:21 +0200
Message-ID: <20240514101034.134125127@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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
index d30e84803481d..feca86e429df2 100644
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



