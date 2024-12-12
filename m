Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4658A22E9FD;
	Thu, 12 Dec 2024 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019446; cv=none; b=dtr5+tSb2nvYsZdOKy9nVpsxZYFuchN1HSz2rnBRukSY6354PZiZrLMocJ2xyQe1ZmqXATik+LetLhZd5OsY+jOmgwMnpW/xyiV2HUJ7wyM0B4JqEKKxGXYOYHV0U3m8A3CfErz1mp1hftomeS37fR49t51tUU6JV7NMYjNTZzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019446; c=relaxed/simple;
	bh=11ktYjF89PxgRu6MRCA7TpoJPgxrAzP0z4/z/1EG340=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3QXstTnkKVkuXhRYv22H0E3dmeDkGlrZrbebhgYKN2kdLkRuQd2fc9nT2fmbvHyIC6uqAT1b9SPaAY82jR5k6N207SYZeOg03L1wFOjkaPc6ClNyGzl1YLKgSGWBCQRwa3kuQco7n/54VyBHhRUeHAOj8wHIGRj452EBiaH6jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCF9QEbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCF9QEbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE31C4CED0;
	Thu, 12 Dec 2024 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019445;
	bh=11ktYjF89PxgRu6MRCA7TpoJPgxrAzP0z4/z/1EG340=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCF9QEbAa+FYsUvdAxNB/sL9PL/eXUqAct8IvhVMiVddrMQiquOg/pcnyCb1DnZV6
	 vRxt1ULxB7Nebb/+ePsU1B+3bohQ4QqO4UjshzBeCVpFFw3YmPU/k8ZVB+i23akqG5
	 QuQihu/3xSdqWEFVPmkQvopCUuvhiJR3u8wcozPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/772] net: rfkill: gpio: Add check for clk_enable()
Date: Thu, 12 Dec 2024 15:52:17 +0100
Message-ID: <20241212144357.878033491@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingwei Zheng <zmw12306@gmail.com>

[ Upstream commit 8251e7621b25ccdb689f1dd9553b8789e3745ea1 ]

Add check for the return value of clk_enable() to catch the potential
error.

Fixes: 7176ba23f8b5 ("net: rfkill: add generic gpio rfkill driver")
Signed-off-by: Mingwei Zheng <zmw12306@gmail.com>
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Link: https://patch.msgid.link/20241108195341.1853080-1-zmw12306@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rfkill/rfkill-gpio.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index f74baefd855d3..2df5bf240b64a 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -30,8 +30,12 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 {
 	struct rfkill_gpio_data *rfkill = data;
 
-	if (!blocked && !IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
-		clk_enable(rfkill->clk);
+	if (!blocked && !IS_ERR(rfkill->clk) && !rfkill->clk_enabled) {
+		int ret = clk_enable(rfkill->clk);
+
+		if (ret)
+			return ret;
+	}
 
 	gpiod_set_value_cansleep(rfkill->shutdown_gpio, !blocked);
 	gpiod_set_value_cansleep(rfkill->reset_gpio, !blocked);
-- 
2.43.0



