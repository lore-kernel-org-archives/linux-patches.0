Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7393017BEAE;
	Tue, 10 Sep 2024 09:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962275; cv=none; b=Fd6q6BOZIfC9nG5mRD2wTx6ikeudA2Q5XeF4dEmyDu7Pa/RmHyyitDqEX/oGs1Yz/Xe9o8JjEWResH4cp9t84oX+xiLdPojfbatSv9cv9P14WWH2smh2BOh0udNRF2sGsIPQ06GAvnesnDm5WqwvBxKh6kPAI2vyDtVuSM5cI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962275; c=relaxed/simple;
	bh=KqMJub701axtq+9xYqB6y7zvgyNB7bQHPKBqkUkDq7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jb2F8JSqOUKEeXHip9GJ52wxLb3CBcVMOZPxY1SIodzhfAi9yg6dlUYDYC9IQF+WPWrpqX3GJyhFP5y+Ei7VO43J5PefojyA+mpdUDBSVOJD4ujXb3OFSo4KX9qCsBmU5Wu/7Nzl/BKbrjUvjF+3/qeNHUxiEae1aFKByuJrfiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dXFlKYtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dXFlKYtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB41FC4CEC3;
	Tue, 10 Sep 2024 09:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962275;
	bh=KqMJub701axtq+9xYqB6y7zvgyNB7bQHPKBqkUkDq7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dXFlKYtbyXxTcuOJMUbZVHTq7HUMzybwslA2ve80CEUZPRkK+QYBEN3dt8sQKH/h2
	 EKTlFSyGl8FhW3XIgJT5hAjCTUDY9JJfd4n9xgJwVZM/zVGmjn1XWkcH2Cl78dx8Oz
	 +90Dn7uRdie23w+tuQ2axVBxTL1vK7g0rR72OH9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 355/375] gpio: rockchip: fix OF node leak in probe()
Date: Tue, 10 Sep 2024 11:32:32 +0200
Message-ID: <20240910092634.522934141@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit adad2e460e505a556f5ea6f0dc16fe95e62d5d76 ]

Driver code is leaking OF node reference from of_get_parent() in
probe().

Fixes: 936ee2675eee ("gpio/rockchip: add driver for rockchip gpio")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://lore.kernel.org/r/20240826150832.65657-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 0bd339813110..365ab947983c 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -713,6 +713,7 @@ static int rockchip_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	pctldev = of_pinctrl_get(pctlnp);
+	of_node_put(pctlnp);
 	if (!pctldev)
 		return -EPROBE_DEFER;
 
-- 
2.43.0



