Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DBC33F377;
	Sat, 28 Feb 2026 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301369; cv=none; b=iuCU6HGTaoOUlJOKe5mtduoXcDr++Co6XjZsohxfUtYuzXl3VNdl+lK5Pleev4oPBd4sM4vBpBjAFm33xLoOGxOI7CXrLk7HFP9LZWlq4jovPo5YCBK0zKNOE83aDu2ErqrsaXQmNqS8JWTUOrsMVCGZZ8ibIWMvpfBsGHvf0C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301369; c=relaxed/simple;
	bh=O5aNiLJoyiy/UOTviuDS1y3ZaxH8fE5X2bobRckl83s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJJWvWdWOp6TJctJ9kmHpfMdmEmuGaCPSY76xYe/BB1JZa7IeRD925OTBozEHrOLRTH38qcFIg9HhOw0KEf6n+vMHzj7hdjMZ2BcQ7rIwt3JQRKf/ZVnKKyr4bXyfEw91emcXwBBioB+Ye7BAz7Y+xXFT8RrGy55zhgp7Qjuhhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fRx+xC0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fRx+xC0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07C7C19424;
	Sat, 28 Feb 2026 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301369;
	bh=O5aNiLJoyiy/UOTviuDS1y3ZaxH8fE5X2bobRckl83s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRx+xC0/x7Jm6m7eIlWmT3xacDFutBiZ3E+bFbzvCTmon74QR9URMb1LsdbvbtQ96
	 5xlBx3+4vuxbGo8oE3HsFdRESn2v5xB/Tu2Ucc4Yvay5IAtU3qpKDEc1+9jn3UySek
	 VgA1l4NJBvsMJBpcMC1GHQObTzwGBFKO1c+8UXeIzUmJZ/TBajhfsFM7OyANAD6cp9
	 c5BqiLxiAh4Hv2YJ1XDzOPujjbBK9/int3bL6C3cioM0A8KxX1iosFqjbeURUfHo9e
	 amXdpbbBv2SxSCxZQRjarKbPpJKYqiII+r7of/kEVc9dJA+SyX4Xzz1DXz0ivGLpgm
	 VEqqfLuuMWzsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	stable@vger.kernel.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 558/752] reset: gpio: suppress bind attributes in sysfs
Date: Sat, 28 Feb 2026 12:44:29 -0500
Message-ID: <20260228174750.1542406-558-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 16de4c6a8fe9ff497ca1aba33ef0dbee09f11952 ]

This is a special device that's created dynamically and is supposed to
stay in memory forever. We also currently don't have a devlink between
it and the actual reset consumer. Suppress sysfs bind attributes so that
user-space can't unbind the device because - as of now - it will cause a
use-after-free splat from any user that puts the reset control handle.

Fixes: cee544a40e44 ("reset: gpio: Add GPIO-based reset controller")
Cc: stable@vger.kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-gpio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/reset-gpio.c b/drivers/reset/reset-gpio.c
index 2290b25b67035..15353ba5758c3 100644
--- a/drivers/reset/reset-gpio.c
+++ b/drivers/reset/reset-gpio.c
@@ -110,6 +110,7 @@ static struct platform_driver reset_gpio_driver = {
 	.id_table	= reset_gpio_ids,
 	.driver	= {
 		.name = "reset-gpio",
+		.suppress_bind_attrs = true,
 	},
 };
 module_platform_driver(reset_gpio_driver);
-- 
2.51.0

