Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5D34B1A6;
	Tue, 21 Jul 2026 22:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673597; cv=none; b=Izwph1qQg4QGO0ucwfPMSmwBAc87PNdA9RoTOuaF2Daq0ILuKaGDX93QnFkULxN7aWkBiwlRd7IB4440kogPAMYLHIROw20orIkOinwQjFoCmdbDwQh9oUtjItjRpypFR1labeqguxEqy3qFAk8+ymZ2muAN+hcAWS4t5xGIPVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673597; c=relaxed/simple;
	bh=JVwbXNgI3COjURjPAGa8WFGf1hAZdO1zqeeheZGyeUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PXS3VQn0unjY0fFZLnWY5CwXxfcYxVUo78U+KyPncIoskH7CV3td025yLoV8tMx4aGm73BuU91Jqe+ogv018jMKqQJZcL6w3sHBWorHwEkc06vNn/qfl1nrWxmbRq32QgLpqygSce+FYgFcL0RNP/+lQ9tZGe4Ub37tttZi8oUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEZUW0U/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEZUW0U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728C11F000E9;
	Tue, 21 Jul 2026 22:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673595;
	bh=tzCxTesQp+WECwXppTPpkUPuEKiB82alOmzNGHMm1I0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEZUW0U/bru0//K9Re5Kv1GpaHPsGgf1fzxPC9jCZAnZM5vYh94+0v6Uw0JyCqFDA
	 0ym6e5hFOBNGKOJid/wlK9w2ZeSPySLeyCzeztvaUZL0XBhA5hTn6RNv7DIkttWPP4
	 MUX1JpdM6+etITJTDjf2TjCBlISuLIi3L/TSGlos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/699] pinctrl: sunxi: fix regulator leak in sunxi_pmx_request() error path
Date: Tue, 21 Jul 2026 17:18:57 +0200
Message-ID: <20260721152359.714806868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 334f7bcbdc79dc8e5b938ac3372453a5368221cf ]

In the error path of sunxi_pmx_request(), the code calls
regulator_put(s_reg->regulator) to release the regulator. However,
s_reg->regulator is only assigned after a successful regulator_enable().
This causes a memory leak: the regulator obtained via regulator_get()
is never properly released when regulator_enable() fails.

Fixes: dc1445584177 ("pinctrl: sunxi: Fix and simplify pin bank regulator handling")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunxi/pinctrl-sunxi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/sunxi/pinctrl-sunxi.c b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
index 0a50f37c63f403..2c8113182080d5 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sunxi.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sunxi.c
@@ -813,7 +813,7 @@ static int sunxi_pmx_request(struct pinctrl_dev *pctldev, unsigned offset)
 	return 0;
 
 out:
-	regulator_put(s_reg->regulator);
+	regulator_put(reg);
 
 	return ret;
 }
-- 
2.53.0



