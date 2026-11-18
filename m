Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049036;
	b=G0bDFYxRfAqaatRFo3OJVqBwkwV+/vbwUijjDDUXg8RsdlZN6rltQHVyglJyzBIMHf9p
	 gUTSdQV0FUPSU8uAD4P+fJCWq88d9Uy5ZyKv8idP7dOn81c9tQO0r7dtWL88JGHWigOm6
	 pWnwCo/m1fjHqUhC2tzo884wi5hk0a84b8r5VhF7IwAb7ecyw35FkHuyRm+upUFchEXcA
	 WJnkS5B1Y/M/4mq677Yw2DIlJAtnij27RzpeQmOEwkmyMrv9DKiwqYVYg0heWns6unZxY
	 DP2PRKa9A1cUXCzT+XcxmSxg22VAO+qs2PhPGgcs+hb1V0GDGmHyGdkXet6I+wzjXCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wh2gEiqQG73/161gI9JT3YKLQOpCUpant4bSoM7OE3M=;
	b=GmX29KHkzefgBW7X5tdfwGxAct7oR4dmKmzlhMnetnvdV3hxBqOaz1RqQ7QaBqKwY2/W
	 +DLAUA5dZwL93aHWSL8k+hbCIlPk4WdJu4inEaLuh40mgnyTrqTpEKnLxSaH4gCbhZy35
	 +h94WFguA2025Z3oHEEJy7YTLkk/62tsNxD+BmwZLneCK5pLQ3PpBXW/6pPfJq5pxDppV
	 Cn8qTUSer6Qcg8geeblZGXd8vnZumlTqXkTUOsQH1f98Vp82/Cynyu9AT77hfvxXv+mdB
	 tcxOZS1CHOsvBZ06BY3Z7nEb7Pdj/TsFVE7oFINCrlGEfjcdkoasuDXcE1PdKm/+xHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q61bxmfq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA84606A31C;
	Thu, 19 Nov 2026 00:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q61bxmfq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB5F1F000C4;
	Thu, 19 Nov 2026 00:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049036;
	bh=wh2gEiqQG73/161gI9JT3YKLQOpCUpant4bSoM7OE3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q61bxmfqPmAHoSJaM7ROBFnZZbixG6eastJhz+X4w9mcWNF1I6Ng/MHAHEG+PBOkT
	 6OgfddtQlKaHGZE04z7afOvtLEZ64jbCH2NdIO9tphCl5NDYVqCpWam+r2ghca7Hab
	 TtG5OFdT0O7FU7FhsYvYWUuJHyzyhAEjTYZOMlbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2208/2857] power: supply: ab8500_charger: Fix AC charger re-enable
Date: Wed, 18 Nov 2026 15:54:02 +0100
Message-ID: <20261118150320.922567031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b497c4c370faa..f964fe48fef16 100644
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



