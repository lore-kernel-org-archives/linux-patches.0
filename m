Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B2653B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DEFC433C9;
	Sun, 17 Sep 2023 19:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979163;
	bh=z9inRm7nAVHq1PGqoAWDmAHf7An/vtyTeecZc5VHSAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rYT0mkY2Kottn8wegxQvx+QgH0XdzA6rYr8lJPBSnzRlZx/JHdAb7KGCFWGf0M9Vc
	 a1pqycFOQXZPcmwXfVibZleUto+FaUaTdZVa2Kyy6FDM8Hy7SUmZtRyU+cFxZPDJ3q
	 xChs8kMd1ikmOGnOEACtZAMTYD6Ggc5zHmQol9pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 233/406] fsi: aspeed: Reset master errors after CFAM reset
Date: Sun, 17 Sep 2023 21:11:27 +0200
Message-ID: <20230917191107.321714689@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

From: Eddie James <eajames@linux.ibm.com>

[ Upstream commit 52300909f4670ac552bfeb33c1355b896eac8c06 ]

It has been observed that sometimes the FSI master will return all 0xffs
after a CFAM has been taken out of reset, without presenting any error.
Resetting the FSI master errors resolves the issue.

Fixes: 4a851d714ead ("fsi: aspeed: Support CFAM reset GPIO")
Signed-off-by: Eddie James <eajames@linux.ibm.com>
Link: https://lore.kernel.org/r/20230612195657.245125-8-eajames@linux.ibm.com
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fsi/fsi-master-aspeed.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/fsi/fsi-master-aspeed.c b/drivers/fsi/fsi-master-aspeed.c
index 87edc77260d20..db0519da0f892 100644
--- a/drivers/fsi/fsi-master-aspeed.c
+++ b/drivers/fsi/fsi-master-aspeed.c
@@ -445,6 +445,8 @@ static ssize_t cfam_reset_store(struct device *dev, struct device_attribute *att
 	gpiod_set_value(aspeed->cfam_reset_gpio, 1);
 	usleep_range(900, 1000);
 	gpiod_set_value(aspeed->cfam_reset_gpio, 0);
+	usleep_range(900, 1000);
+	opb_writel(aspeed, ctrl_base + FSI_MRESP0, cpu_to_be32(FSI_MRESP_RST_ALL_MASTER));
 	mutex_unlock(&aspeed->lock);
 
 	return count;
-- 
2.40.1



