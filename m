Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEA630C376;
	Mon, 13 Oct 2025 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368018; cv=none; b=WImfLxbZgAwbHJdgs19zn+uU4fNBWnHVeAYAWGMeMoVr6AtthZYHv2A9lxS+v0KFc8w3hyYRCvIGpVlzY7gkAua0zCPnQH78Yno8YJIUNJpAm7phocXRfpxgOnkFYvND0R8qODVS6VvDv38uEkjwgY2IzfNQeH3gH/QlHVwSAqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368018; c=relaxed/simple;
	bh=+7rkvsG0Ywma1xpaD2a2hQ160AnNgUhmz3tRGyanuEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9MxDV84VmVMeceamiYsf5klNcqcli5O4YAm0k+y5O2kQvej1hmpL5rW8ho8ENgvYxTuHIPzv8sofppmHWpcAeZHuoO22iuZDLojLqmRk7GdXh7un/sRaB7ayc6GA41sAKtvWr+HnhA5y9Jjz8KWHhHk0K/QO6Qbn7JL25f5gGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6XKLQoE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6XKLQoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D81C4CEE7;
	Mon, 13 Oct 2025 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368018;
	bh=+7rkvsG0Ywma1xpaD2a2hQ160AnNgUhmz3tRGyanuEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6XKLQoE9ygZrv/PFJYcMh/XZPA3TwoWJsOPtiOaZ4k8xG/DLHxdhhSJfZW57Uk3p
	 9yBt+zmaq9yHdCnc3tQMLuA+498d7r4Bz8hBf34YFGSwpaZLH9cMOmVhlGiW1CH61y
	 ERpSK08JSXLudEVah+CcKZYVzBxdAoP4GodLlvGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/262] pinctrl: renesas: rzg2l: Fix invalid unsigned return in rzg3s_oen_read()
Date: Mon, 13 Oct 2025 16:42:38 +0200
Message-ID: <20251013144326.713011256@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 8912b2862b9b74a0dc4e3ea1aacdec2f8abd7e1d ]

rzg3s_oen_read() returns a u32 value, but previously propagated a negative
error code from rzg3s_pin_to_oen_bit(), resulting in an unintended large
positive value due to unsigned conversion. This caused incorrect
output-enable reporting for certain pins.

Without this patch, pins P1_0-P1_4 and P7_0-P7_4 are incorrectly reported
as "output enabled" in the pinconf-pins debugfs file. With this fix, only
P1_0-P1_1 and P7_0-P7_1 are shown as "output enabled", which matches the
hardware manual.

Fix this by returning 0 when the OEN bit lookup fails, treating the pin
as output-disabled by default.

Fixes: a9024a323af2 ("pinctrl: renesas: rzg2l: Clean up and refactor OEN read/write functions")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250709160819.306875-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/renesas/pinctrl-rzg2l.c b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
index bde58f5a743cb..698ab8cc970a6 100644
--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -1074,7 +1074,7 @@ static u32 rzg3s_oen_read(struct rzg2l_pinctrl *pctrl, unsigned int _pin)
 
 	bit = rzg3s_pin_to_oen_bit(pctrl, _pin);
 	if (bit < 0)
-		return bit;
+		return 0;
 
 	return !(readb(pctrl->base + ETH_MODE) & BIT(bit));
 }
-- 
2.51.0



