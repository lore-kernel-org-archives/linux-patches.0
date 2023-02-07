Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523F33212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C6C433EF;
	Tue,  7 Feb 2023 13:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675774860;
	bh=EnmhB9oXT4JF82erTgjorlkxGaYjs/YL+ntIQBZylJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9sSLadJZGNDvO8UK8jTsmygVTSJsx2uY3N6HLz4zJCIA0O+zllM7M/InsygICcUS
	 OfyZkZz0r0YhqgzFuLagmndbeov1mdLGjAg+ClgcB5K6Zt9Fp6GzO1Q+I3/AVLG4xY
	 G3Cp1eAyUTIoQUezinutFlK836ompoiNRzicG6eI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/208] ASoC: SOF: ipc4-mtrace: prevent underflow in sof_ipc4_priority_mask_dfs_write()
Date: Tue,  7 Feb 2023 13:54:32 +0100
Message-Id: <20230207125635.149493163@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit ea57680af47587397f5005d7758022441ed66d54 ]

The "id" comes from the user.  Change the type to unsigned to prevent
an array underflow.

Fixes: f4ea22f7aa75 ("ASoC: SOF: ipc4: Add support for mtrace log extraction")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/Y8laruWOEwOC/dx9@kili
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-mtrace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/ipc4-mtrace.c b/sound/soc/sof/ipc4-mtrace.c
index 70dea8ae706e..0ec6ef681012 100644
--- a/sound/soc/sof/ipc4-mtrace.c
+++ b/sound/soc/sof/ipc4-mtrace.c
@@ -344,9 +344,10 @@ static ssize_t sof_ipc4_priority_mask_dfs_write(struct file *file,
 						size_t count, loff_t *ppos)
 {
 	struct sof_mtrace_priv *priv = file->private_data;
-	int id, ret;
+	unsigned int id;
 	char *buf;
 	u32 mask;
+	int ret;
 
 	/*
 	 * To update Nth mask entry, write:
@@ -357,9 +358,9 @@ static ssize_t sof_ipc4_priority_mask_dfs_write(struct file *file,
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
-	ret = sscanf(buf, "%d,0x%x", &id, &mask);
+	ret = sscanf(buf, "%u,0x%x", &id, &mask);
 	if (ret != 2) {
-		ret = sscanf(buf, "%d,%x", &id, &mask);
+		ret = sscanf(buf, "%u,%x", &id, &mask);
 		if (ret != 2) {
 			ret = -EINVAL;
 			goto out;
-- 
2.39.0



