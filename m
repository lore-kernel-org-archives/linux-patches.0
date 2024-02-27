Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BBB13B7A0;
	Tue, 27 Feb 2024 13:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042306; cv=none; b=LgoybjIJn/dzLP6s7ajef/78qnRVyXFvw6qSZNHIZLFFl4psUR91rOmwE4HRPDOKxKPX8HU01TjmDumdsU+yBC7zZkhtaipctJD6aHKWdvZ9LJoODaH1sUE9kAivY34j3DFok6b+0tdwxpHEra54VL0I6Lh5A/yE9otrEZ0AeyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042306; c=relaxed/simple;
	bh=/e23Qz8WUJhf+pQjvHvl6t2m5307Mdss3ys0DOO1rms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuUNxqp1geSefe6lAYNL7bzlYyqnMQZn97nt8U4EDUhkCzFDubwiTFLQDU2WhNtgmaezUFng9FhRtSQL9LY90eNc2AsfQmi8iH4k+KAuPrvrEoaYFqzF27rcmtG2UvhI24lSYhYLYzBCBCeH0culc59eRNrxn5l4EACmciN6PhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KR+PTpJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KR+PTpJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD87FC433C7;
	Tue, 27 Feb 2024 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042306;
	bh=/e23Qz8WUJhf+pQjvHvl6t2m5307Mdss3ys0DOO1rms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KR+PTpJLIxhcsfL3vRHAQIYwvo7SqJmSXpzkBAMSOj4bkp4K2viwtzAssZTIryLDc
	 kWJM/pr4JmD4SEAklGrf0JpYcGbRjtDcFn8W6RQa0wJDnCUiZaP29YXB7paVYTchxb
	 h03VU2olYdxlifV4OthjZZaWtTCN0sNWZyeSN2do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/299] bus: imx-weim: fix valid range check
Date: Tue, 27 Feb 2024 14:25:33 +0100
Message-ID: <20240227131632.910333522@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 7bca405c986075c99b9f729d3587b5c45db39d01 ]

When the range parsing was open-coded the number of u32 entries to
parse had to be a multiple of 4 and the driver checks this. With
the range parsing converted to the range parser the counting changes
from individual u32 entries to a complete range, so the check must
not reject counts not divisible by 4.

Fixes: 2a88e4792c6d ("bus: imx-weim: Remove open coded "ranges" parsing")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/imx-weim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/imx-weim.c b/drivers/bus/imx-weim.c
index 42c9386a7b423..f9fd1582f150d 100644
--- a/drivers/bus/imx-weim.c
+++ b/drivers/bus/imx-weim.c
@@ -117,7 +117,7 @@ static int imx_weim_gpr_setup(struct platform_device *pdev)
 		i++;
 	}
 
-	if (i == 0 || i % 4)
+	if (i == 0)
 		goto err;
 
 	for (i = 0; i < ARRAY_SIZE(gprvals); i++) {
-- 
2.43.0



