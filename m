Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A86E4BC002;
	Sat, 28 Feb 2026 17:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301354; cv=none; b=GzhVQI54zj8dNdD3YukcBwlwOBohzALMPhzUjoHfedmdm+bT6/ECjbf6LSD7MjE5mlZcnY7N+SpXmvO5WTM9JqoSzJWvZZX03U7W91v7k8bF2uYd1tqF3h3pFrta99I5pA8yOY3DnhZ9Oi4pptGoHGdIyjc+z3zGFBukQoIigpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301354; c=relaxed/simple;
	bh=xXJsk3Lae2xstEARdnH60ETU+GXhtsUK4YIx6sThe1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUbo48awrOyeKVBhYWj0Z9t0m1HtIDQtC/7RG7orziC+btpr016bFRtG8QvndUiooBQakKriUcmd0VFF97/+k5uSX9KSFm3bU09SWGt7aIym2o1C6m3SsldfRMUJEXNLqHaSu1yNWgWk5eLSPWRUJN4heJUtxhO8T4zy5YTfx2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ESZsCIdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ESZsCIdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C259DC19425;
	Sat, 28 Feb 2026 17:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301354;
	bh=xXJsk3Lae2xstEARdnH60ETU+GXhtsUK4YIx6sThe1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESZsCIdFS/7rmsffacxKfLTzebpBKV+PQAKaXhNsjwEpiXQ2BOA3TN5yMX/h7HQpz
	 LHwqjlcTwueF+xjlBsXiqpsh7FZVSQx1VrVH6zFmrUux2KAOyvlIAko9TKGhmiaBXE
	 D71YgPZYw6MaF9lJx1Bhvxs3XrhogbpGLS3qa3y9K6Q0N+GZ51DY4oq92VFFFOeeNu
	 JNsoELP9TVF/RfPfKiNoCpBro3f1p7Hs5d1SwD8Fpee2p6wtpYVBkSOYVuhJ15UhJj
	 vWE7Q7YY7l4xeu9XElVzXD6VttbMSVmqCyWytRfx1cGbA6mIWnZaHT36fdEwCU5AhD
	 7soRmS5Cu22Hw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Johan Hovold <johan@kernel.org>,
	stable@vger.kernel.org,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 542/752] soc: ti: k3-socinfo: Fix regmap leak on probe failure
Date: Sat, 28 Feb 2026 12:44:13 -0500
Message-ID: <20260228174750.1542406-542-sashal@kernel.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit c933138d45176780fabbbe7da263e04d5b3e525d ]

The mmio regmap allocated during probe is never freed.

Switch to using the device managed allocator so that the regmap is
released on probe failures (e.g. probe deferral) and on driver unbind.

Fixes: a5caf03188e4 ("soc: ti: k3-socinfo: Do not use syscon helper to build regmap")
Cc: stable@vger.kernel.org	# 6.15
Cc: Andrew Davis <afd@ti.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://patch.msgid.link/20251127134942.2121-1-johan@kernel.org
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/k3-socinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/ti/k3-socinfo.c b/drivers/soc/ti/k3-socinfo.c
index 50c170a995f90..42275cb5ba1c8 100644
--- a/drivers/soc/ti/k3-socinfo.c
+++ b/drivers/soc/ti/k3-socinfo.c
@@ -141,7 +141,7 @@ static int k3_chipinfo_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
-	regmap = regmap_init_mmio(dev, base, &k3_chipinfo_regmap_cfg);
+	regmap = devm_regmap_init_mmio(dev, base, &k3_chipinfo_regmap_cfg);
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
-- 
2.51.0

