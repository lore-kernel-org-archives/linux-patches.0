Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040719;
	b=4hzaRPV4efqtkBxQop4+gzsT1f36GgiL/2jAJ/UN9vL2CvUQTJxm/h2dOHPVzhexEBL7
	 Sntq9ZtB1XeNkKTzffQkabBVfrTePl9/lkX1V6e+BB+TVpwAmHwqywauelZVrchUSSTb8
	 pZ29E22v8SUf3LVvkG89Xxg9++ZSu44NhIsdGObzoQrxyVQzWK30t50dafmkqmtxDx/1W
	 WANMCMoqJ3bLg9Gvy20+VbjzQ+QwTS7uzoeiiqp8EbYHw/B30iatR+3BNViaDdPNobrB/
	 zWTyuOkl6SlBOrT2ZdT8ZWQJQSvE9X+TyGQwsBlYHxt1uspxXoWXMZBeuzcJmXssKWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LmzeRc/WOTlOQQg1FpLdfENN3O4xdGyFSvFsYf61uyk=;
	b=2XXUGqg3BKrRB2aYfUZlBwOpTtlh5JVdWT52qMEwoIVnOD+32PH3jODbg+bKa7HrHiZ4
	 hPKg/+GrlgDPHlb8/O7Fjl71IFA9Qg2G0DbneMIcDjMoG7iOuXNrZ7wJNaZaTQ98ukBJT
	 3AsU2VpNTDDoS2Nz07K09gK5s0xv//0Mx7PKwq6IfLVgZslgyRpwXPRLG1w1IfQZa075S
	 Nog5FKkbbyASIHoJmrY+BJXx8PalANNPkLpF8qL8psO9J5zMNpob8jUMCDXo2KzP4UvKl
	 /zaluiR3aURcvj0iWUjEKJs3CKY/YN8Sv3Ib5Xryc89bDBHiun0Rx6UapCZmTpR3Qzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VkiRKWF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874BB606A320;
	Wed, 18 Nov 2026 22:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VkiRKWF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D769A1F000C4;
	Wed, 18 Nov 2026 22:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040719;
	bh=LmzeRc/WOTlOQQg1FpLdfENN3O4xdGyFSvFsYf61uyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkiRKWF3WvTFlHctCFtgt1AUBEo0SEYF+vxzySMNkrSqif4YJWLfvZrlCVWZiNevz
	 kiOgRzXXa4r5qmP+7RMrTjKmj9ua1ociGTh95A7JAjfLqJwGu5cya9xy0degZWrUFN
	 7jCwIKA5D/Sk+RvQnK1Ew35teyDBuh6ofd15zTvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2557/3318] power: supply: ab8500_charger: Fix AC charger re-enable
Date: Wed, 18 Nov 2026 15:52:59 +0100
Message-ID: <20261118150437.980316349@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 3e1d2517347f6bb72f74e63ec77d1634385fbf21 ]

The AC check-enable callback passes the embedded USB charger object to
ab8500_charger_ac_en(). That helper derives the parent with the AC
charger offset, so the wrong object yields an invalid ab8500_charger
pointer.

Pass the AC charger object when re-enabling AC charging.

Fixes: bc6e02871402 ("power: supply: ab8500: Standardize CV voltage")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-7-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 788908ab0836c..f2ce7a2eacb0b 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -1766,7 +1766,7 @@ static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
 }
 
 /**
- * ab8500_charger_ac_check_enable() - enable usb charging
+ * ab8500_charger_ac_check_enable() - enable AC charging
  * @charger:	pointer to the ux500_charger structure
  * @vset_uv:	charging voltage in microvolt
  * @iset_ua:	charger output current in micrompere
@@ -1805,7 +1805,7 @@ static int ab8500_charger_ac_check_enable(struct ux500_charger *charger,
 			return ret;
 		}
 
-		ret = ab8500_charger_ac_en(&di->usb_chg, true, vset_uv, iset_ua);
+		ret = ab8500_charger_ac_en(&di->ac_chg, true, vset_uv, iset_ua);
 		if (ret < 0) {
 			dev_err(di->dev, "failed to enable AC charger %d\n",
 				__LINE__);
-- 
2.53.0



