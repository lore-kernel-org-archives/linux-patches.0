Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEC835BDDF;
	Wed,  3 Dec 2025 16:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780104; cv=none; b=SHpWf/zGJu/hNaz1y1QJT+D5SHYwBoOCCf++u1zsaYQuo25rYvXu2IbS/hKbPfw+IyDvMnYOwqN2Ej7NjuEjaQAQlGTN2t8+Xgoo87r2Vv/H3EBJs+HqHVlKZ2J1CPXdfgAtYPj3hmx0dQcab7bfh/WB79JtbzkkHNQtp2wEMlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780104; c=relaxed/simple;
	bh=/xpNFzVZZ3VErcLlki2C4EMDqbWC2sZTZX19Z5QXzjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soGMbc3rzNPyVmsQ40jgHtbXwaDnsRQ277u17bhEtURvwJcgMUHl6pk66dPwsLmgj4LLhjZvwMxnR8B2KDq54J5Q020NSLDvOAtWdSZDG6wgnSz1CSOGkcPsZDtwsJkMK+FnCPm/O+LD2uWvvtS2UbNnhG0eajgowix//nzu/sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFmemA7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFmemA7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6674DC4CEF5;
	Wed,  3 Dec 2025 16:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780103;
	bh=/xpNFzVZZ3VErcLlki2C4EMDqbWC2sZTZX19Z5QXzjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFmemA7Zvp1GpFuOclRap+44GYXNIurkYZbk6r19IqLLAAD1T7J+3Z3y97pS5YybY
	 PueCMJeDciF1mR7sJd818fQPrVBAqiACqTtoyL/vVxccN47n2yfJGjPxprjPypNv+D
	 LLTsYdjqSVXFXTzFC7ArvJNpylJsH+QawNZmnWJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 455/568] net: dsa: hellcreek: fix missing error handling in LED registration
Date: Wed,  3 Dec 2025 16:27:37 +0100
Message-ID: <20251203152457.368897188@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>

[ Upstream commit e6751b0b19a6baab219a62e1e302b8aa6b5a55b2 ]

The LED setup routine registered both led_sync_good
and led_is_gm devices without checking the return
values of led_classdev_register(). If either registration
failed, the function continued silently, leaving the
driver in a partially-initialized state and leaking
a registered LED classdev.

Add proper error handling

Fixes: 7d9ee2e8ff15 ("net: dsa: hellcreek: Add PTP status LEDs")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
Link: https://patch.msgid.link/20251113135745.92375-1-Pavel.Zhigulin@kaspersky.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/hirschmann/hellcreek_ptp.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
index b28baab6d56a1..763666480a8a8 100644
--- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
+++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
@@ -367,8 +367,18 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
 		hellcreek_set_brightness(hellcreek, STATUS_OUT_IS_GM, 1);
 
 	/* Register both leds */
-	led_classdev_register(hellcreek->dev, &hellcreek->led_sync_good);
-	led_classdev_register(hellcreek->dev, &hellcreek->led_is_gm);
+	ret = led_classdev_register(hellcreek->dev, &hellcreek->led_sync_good);
+	if (ret) {
+		dev_err(hellcreek->dev, "Failed to register sync_good LED\n");
+		goto out;
+	}
+
+	ret = led_classdev_register(hellcreek->dev, &hellcreek->led_is_gm);
+	if (ret) {
+		dev_err(hellcreek->dev, "Failed to register is_gm LED\n");
+		led_classdev_unregister(&hellcreek->led_sync_good);
+		goto out;
+	}
 
 	ret = 0;
 
-- 
2.51.0



