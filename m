Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C114221D93;
	Thu, 12 Dec 2024 17:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025264; cv=none; b=Wshk8mbmTtJMGjcx4uBSeCXvz3n7rfuIdUcnCN/0lHQrik/WqYjcY54K5oUh1rNzS1b1jyrU5uCO9ihVMyaZVFeMxWym8hT60RgKe0FFwvNWT8z4xVc8fzAFPR4SYD+RGKG8tRi14TfKmAKngNoVOtXX1KA3ELa8VGuKs3nJ/nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025264; c=relaxed/simple;
	bh=TxQDqGGb60iZ4ExVxFHCssDMY17FmHns/E7JUC1zG3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BYlhnIuBONu+/rl6c/43MN0TuGGvBnixj7rAVUDZ8zPCVOkVgpZcZ2/B1fX+vrOxODgxkFIHl8TPURznR+JUfmwh96iHgzsTYgpSuKzhsOTHzQcv6HFxqxQY2kjUEG2TcFFSQ84olpw15MRxNe7//TDCuS7RDcjEeClg9kRAdb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SC0gNnfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SC0gNnfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9988C4CED3;
	Thu, 12 Dec 2024 17:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025264;
	bh=TxQDqGGb60iZ4ExVxFHCssDMY17FmHns/E7JUC1zG3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SC0gNnfwW9CFXzTL8VtO3fhlk/nHKX3tRUE++7WZ999kxrggjN9UjMtWjtK8hWs7P
	 1mR7DDnSwk2hlJadt9o2ZZYs3q6T3DcAJL9mD2Kgk8x4MMy3iGOmX8NJPcEokvDfqw
	 7I5NyPdvsgAcXKkg2WwhrkVrLv4IUthIxWztUF9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/321] net: rfkill: gpio: Add check for clk_enable()
Date: Thu, 12 Dec 2024 15:59:59 +0100
Message-ID: <20241212144233.185197045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



