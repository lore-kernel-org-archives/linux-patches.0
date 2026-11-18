Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025368;
	b=cSKc1KO93lSFTyfTwxnq1ec0zb+KZ5IKpy4D8xy28ysiTRoItUDrNcQLTTgGU2lMQs1o
	 sWOfr9i4gVlfcCxvjnJLzCQJ4257kB/mTzu370MoXRxmobj3CkT5w8CR3n9bWDTfvA8VM
	 AmcoV+oC53hzkpl5W1oSw+jdse1Twp1Cb6mU0kYWQ2FQawwQqfcqVuMHXm3SxWZmpwadW
	 7y6imsEchtWVws97Ve2xRvaXT49oCtoOhMPCyUFQrH5mC3g42dD7F4bLPSnOU4VQYapsT
	 FyBMZFik/0KkKO5xi4ba0ew6qN/Ms1TA3pawRWfEndMq24c3zA/y19HJ/LALQPxxDlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bUv/ZpfdVpWyRACuvrxo2VTKvfXZeHH682Gn7TRNlho=;
	b=caORzk59ipC1Uwi6jgWZbvGd/awYVGJ1unzTP4dK/o8HE6tVOSaPNttwzlCkids2fPVE
	 /n0etkaxsPunIwqd8R3aIHDyhKGxcYshoyfc7IEtP7LZqdDvPlo29mhTXWODiNzBThko4
	 9xCPwXvq1qPC0un11hK4VmjDnH0ptvcykLSm6aPcHX/iFnoSVMHPtluB9892/9hJ7Q84D
	 O5Sm0aLh/gsVGwUWrNqCizMnP0/00W65EHeSUtcwgeLuYZwtpHoUsTy0OeGEw0WYEDz3R
	 EkAQiw2XyfsGdwwjSAAbLU5H0JWEaF3IoHkGn9gC7dUBRuRwtu05Pxz93VbBLcO4xgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pF/nNPtg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99785606A320;
	Wed, 18 Nov 2026 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pF/nNPtg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC5201F000C5;
	Wed, 18 Nov 2026 18:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025368;
	bh=bUv/ZpfdVpWyRACuvrxo2VTKvfXZeHH682Gn7TRNlho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pF/nNPtgRrqdzRH/w6t933SKGoCpABhqotHDjf6rFWhCmC23/5cOEbttlRnD5w8VY
	 CZwAn4w/PDQEyQquxfPjd61fKwpV/SfncJwSVaUTM6u0nGph2EYFqrZT4e57HFeGop
	 XUtCssHcoEp3rVfk+ZCSvVZUJPr4x7xeEWRI0nMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1054/2151] power: supply: ab8500_charger: Fix AC charger re-enable
Date: Wed, 18 Nov 2026 15:46:29 +0100
Message-ID: <20261118150200.706330772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1813fbdfa1c1f..db640648c9f04 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -1778,7 +1778,7 @@ static int ab8500_charger_usb_check_enable(struct ux500_charger *charger,
 }
 
 /**
- * ab8500_charger_ac_check_enable() - enable usb charging
+ * ab8500_charger_ac_check_enable() - enable AC charging
  * @charger:	pointer to the ux500_charger structure
  * @vset_uv:	charging voltage in microvolt
  * @iset_ua:	charger output current in micrompere
@@ -1817,7 +1817,7 @@ static int ab8500_charger_ac_check_enable(struct ux500_charger *charger,
 			return ret;
 		}
 
-		ret = ab8500_charger_ac_en(&di->usb_chg, true, vset_uv, iset_ua);
+		ret = ab8500_charger_ac_en(&di->ac_chg, true, vset_uv, iset_ua);
 		if (ret < 0) {
 			dev_err(di->dev, "failed to enable AC charger %d\n",
 				__LINE__);
-- 
2.53.0



