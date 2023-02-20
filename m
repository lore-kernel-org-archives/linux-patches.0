Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E639363BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C658C433EF;
	Mon, 20 Feb 2023 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901538;
	bh=WFWFEqbwYDhovhRzvINfurSA2RPOXvEef9O4DzZK0mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohT2UlaxgSAERcPjAlIYDc4z4Cwuna16dqwDFIQfId3IoR0oUdzYg8Um/q775DllS
	 myoy4JHwwC2eFsfimvyhWIiTfIS0sVXxVH+HOZwnbgxIQw6QhlR+NfQVfyLL/Igwsj
	 Ki0yJNyYOdliFogXUn3Ishm64S75Jox2LJvkmIXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 055/118] mmc: jz4740: Work around bug on JZ4760(B)
Date: Mon, 20 Feb 2023 14:36:11 +0100
Message-Id: <20230220133602.654475729@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Cercueil <paul@crapouillou.net>

commit 3f18c5046e633cc4bbad396b74c05d46d353033d upstream.

On JZ4760 and JZ4760B, SD cards fail to run if the maximum clock
rate is set to 50 MHz, even though the controller officially does
support it.

Until the actual bug is found and fixed, limit the maximum clock rate to
24 MHz.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230131210229.68129-1-paul@crapouillou.net
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/jz4740_mmc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1053,6 +1053,16 @@ static int jz4740_mmc_probe(struct platf
 	mmc->ops = &jz4740_mmc_ops;
 	if (!mmc->f_max)
 		mmc->f_max = JZ_MMC_CLK_RATE;
+
+	/*
+	 * There seems to be a problem with this driver on the JZ4760 and
+	 * JZ4760B SoCs. There, when using the maximum rate supported (50 MHz),
+	 * the communication fails with many SD cards.
+	 * Until this bug is sorted out, limit the maximum rate to 24 MHz.
+	 */
+	if (host->version == JZ_MMC_JZ4760 && mmc->f_max > JZ_MMC_CLK_RATE)
+		mmc->f_max = JZ_MMC_CLK_RATE;
+
 	mmc->f_min = mmc->f_max / 128;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 


