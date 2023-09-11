Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77B71170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:15:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48449C433C8;
	Mon, 11 Sep 2023 14:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441739;
	bh=LfENJ8jLacGzuCwW9yr2JWPetS2Hh+53peexpr9+wss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBE5KYYz9cw8Wk2N7Sj1UNEQLhWZbX7mZNH/zubaBqL6yjWDeh/w6xWxjF7STl3GG
	 5taq9yTV78wDOdEiAOxZXC2lwkk8Zyb8+ko9nX689fLYHVvRNcBMxKMUdNOugWY65A
	 l4egulARu3X+B0rXrQLmq5fSB7aRzWPBb1wzXHNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eddie James <eajames@linux.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 519/739] fsi: aspeed: Reset master errors after CFAM reset
Date: Mon, 11 Sep 2023 15:45:18 +0200
Message-ID: <20230911134705.610170502@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 7cec1772820d3..5eccab175e86b 100644
--- a/drivers/fsi/fsi-master-aspeed.c
+++ b/drivers/fsi/fsi-master-aspeed.c
@@ -454,6 +454,8 @@ static ssize_t cfam_reset_store(struct device *dev, struct device_attribute *att
 	gpiod_set_value(aspeed->cfam_reset_gpio, 1);
 	usleep_range(900, 1000);
 	gpiod_set_value(aspeed->cfam_reset_gpio, 0);
+	usleep_range(900, 1000);
+	opb_writel(aspeed, ctrl_base + FSI_MRESP0, cpu_to_be32(FSI_MRESP_RST_ALL_MASTER));
 	mutex_unlock(&aspeed->lock);
 	trace_fsi_master_aspeed_cfam_reset(false);
 
-- 
2.40.1



