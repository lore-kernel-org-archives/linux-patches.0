Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03614320F;
	Tue, 14 May 2024 11:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687584; cv=none; b=a68vDkrpSxKkdUtYrYAVNtLYWsL/d/ZkCgCtjwJjK4evd/26IrYNAYjVJXoLNlU+FKnlyKO/mAsk/f3Hc5UtYj1OmkuorrKE/CrotqlBBz6VdpAIvhfJthZdPW7qptoKLvoL0MaqGGK+seYDxwFipDE8EgigtH3IhKpQrzsIN0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687584; c=relaxed/simple;
	bh=HpCtNEbriqAaoQysOmo37Trx272tFoynS1wAZocr6PE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=naFvkFgywAf5aAqBpcnxYFuc6d+KqTMOkJ4OoYaE4BtrT4m3P946jixJfA6ATSQsD8xKR8cjpB0QCn8z8T8wDJmPO4EReTzo2g4VMDUx/Hy1lgX0QyMzvIoUtqgWXyj/BLwqdJZn+IDRnYC+RrVU+F7e4QfUcuDt3fdG5CsIqJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xm/EHRVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xm/EHRVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C48BC2BD10;
	Tue, 14 May 2024 11:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687583;
	bh=HpCtNEbriqAaoQysOmo37Trx272tFoynS1wAZocr6PE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xm/EHRVGUvLa3ArHc97HrWvqo3miRpr3mdvYNLbK2lMf8jkznTGvi0IKTGDFvDclA
	 HifMZE8ISHjs7V5aqiQfC8qvTY/sEgzJ9GyhfxHdqdNEIiErt+U/Qzhin9MRbMqo0H
	 lLPojMFR7Ni6o8uz6yhf+B+Y0dYhdIBzfirkqToE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/168] octeontx2-af: avoid off-by-one read from userspace
Date: Tue, 14 May 2024 12:18:52 +0200
Message-ID: <20240514101007.979523756@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4dddf6ec3be87..e201827529513 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -559,12 +559,10 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
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



