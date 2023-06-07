Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C933925D
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F3DC4339C;
	Wed,  7 Jun 2023 20:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169514;
	bh=lEhW/FTuxT+V1hXf12myk915uajF7raM3r2o9j1OBdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qK8h4zmxCJqk77Uw7qoHYWuF/oJhHkPuYU57Gwn9ld0POL6ninmb7JUTLtQ9YxuuY
	 CzGaX5pPWfO1WhGU/H4M9vHVgrBRU5qA86NzoN8NHUszEwhHWmAVvRYwpvMcF43yOL
	 7/aiXk26vkErRrfkuFXuAUKITFPqxozPqxosSwCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 110/286] nbd: Fix debugfs_create_dir error checking
Date: Wed,  7 Jun 2023 22:13:29 +0200
Message-ID: <20230607200926.680295325@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ivan Orlov <ivan.orlov0322@gmail.com>

[ Upstream commit 4913cfcf014c95f0437db2df1734472fd3e15098 ]

The debugfs_create_dir function returns ERR_PTR in case of error, and the
only correct way to check if an error occurred is 'IS_ERR' inline function.
This patch will replace the null-comparison with IS_ERR.

Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>
Link: https://lore.kernel.org/r/20230512130533.98709-1-ivan.orlov0322@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index e1c954094b6c0..dd0adcf745ff5 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1666,7 +1666,7 @@ static int nbd_dev_dbg_init(struct nbd_device *nbd)
 		return -EIO;
 
 	dir = debugfs_create_dir(nbd_name(nbd), nbd_dbg_dir);
-	if (!dir) {
+	if (IS_ERR(dir)) {
 		dev_err(nbd_to_dev(nbd), "Failed to create debugfs dir for '%s'\n",
 			nbd_name(nbd));
 		return -EIO;
@@ -1692,7 +1692,7 @@ static int nbd_dbg_init(void)
 	struct dentry *dbg_dir;
 
 	dbg_dir = debugfs_create_dir("nbd", NULL);
-	if (!dbg_dir)
+	if (IS_ERR(dbg_dir))
 		return -EIO;
 
 	nbd_dbg_dir = dbg_dir;
-- 
2.39.2



