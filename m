Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444C013AA5F;
	Fri,  6 Dec 2024 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497396; cv=none; b=uflPArvddW8EnjGxyI+5YqLhfFPB19uGWFy5RDuWCKr1cWOrdCYAz4jG+KnmnUn/LAJ6PymkJgt9eX0jNnU27cO6PhZQvnvq+7C8np0CkDl5qDxcjHe2Fq1URTDtexe0H8fTsKAlO3LW6nrFGHkBEBhiiQO8dNBks77LZAUiUtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497396; c=relaxed/simple;
	bh=RKMgt+mzFECb0dKDr0VJUIXg8m0A91C9FnH21OHQmiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlPIupUZtjZEPEAI28hNYs0bOpypCHIUqtVeGdk7pQSB5P4bbhBnXMEQJ5cxLPLUFZPFjcjzQ2dtzEpwCeyQ1wpq3RWwBtzDnFx/A1ECtFblpOd1wy1ERxhaVN/U9VnOH0UsA3NBjR6I88TbJ95HFetLVeMxzBBSvcaay9n1AAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+fOI352; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+fOI352"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFAADC4CED1;
	Fri,  6 Dec 2024 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497396;
	bh=RKMgt+mzFECb0dKDr0VJUIXg8m0A91C9FnH21OHQmiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+fOI352Nq8NsBNOSnidAaa5VuJx5ORY1la1Sz655RAG7dihKZrVcFZxEyZuDoPeh
	 NwkYYAqdkSzPbz9nWu/qvl+tIRg8JFfDnJL0JSlV5A6gyuW43lGFd+cHPJ7s+sDE8k
	 6iGyZUO/JnK+p1IvTK/Mr/PsBDw0/9Nrn6VnJVa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 248/676] net: rfkill: gpio: Add check for clk_enable()
Date: Fri,  6 Dec 2024 15:31:07 +0100
Message-ID: <20241206143703.019100057@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 4e32d659524e0..b12edbe0ef45c 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -31,8 +31,12 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
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



