Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DA81F669E;
	Tue,  3 Dec 2024 14:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236554; cv=none; b=AMVZ4J9H6EqydHTbq+RugHgcaCMiti45T2y9zeXc/KKwmmHvelvWzaHRfCVPzF5bLJyjBJTeQynUSD/B4lI5ifngeWvhlDBSql+Ihay3ToiOkajJWU6x8CRhWMvSA/Oopp91fesJwGoTUyTW6Fq+zXixrXL9r9j0/EmkPvFM/FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236554; c=relaxed/simple;
	bh=zuOiESzJT0srW4NhwGdPQMKC6NItT86E+IsdyV4Up6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSGE1pwGSjwYO+omFoKk37S4aRILtT+BcX3Iwr9vtkGSqJnWFYcANprLNFTu0xeQwVvko3FjgeIzi/pGANLfTVlQ1W7bc+ogbz1mexf047GivTfkQbNK+kWKkKFZLqBsLwWhR1999IAdVconompKyrkrVsa2zQzagiuOwGUtd/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OF9Eeqkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OF9Eeqkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73B0C4CED8;
	Tue,  3 Dec 2024 14:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236554;
	bh=zuOiESzJT0srW4NhwGdPQMKC6NItT86E+IsdyV4Up6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OF9EeqkttV1pLGCSHnUGhk8000/KirClNvSfrQuRWgN47f4aqG7e8KqWMEKl40F63
	 HKSuHkHVl3C2Bc11X82tB07CS1eT+97I1MFW/Q940Q6Vtt93b2cdoQoD3eUtT/QeB1
	 JPf/acHNMy7E2cNp7zotk1G28GdvV1k9ReDfBZp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingwei Zheng <zmw12306@gmail.com>,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 053/138] net: rfkill: gpio: Add check for clk_enable()
Date: Tue,  3 Dec 2024 15:31:22 +0100
Message-ID: <20241203141925.588308226@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 7524544a965fc..c1df7054c2f08 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -44,8 +44,12 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
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



