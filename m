Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3DD168D1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C098C433D2;
	Mon, 22 May 2023 19:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783535;
	bh=WbKKrOErbGCxNTkNneJQeRYwNh61o3mgPpa/oG7w0pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nbdwl6L5vEhMcef13GXXURsNKe/Y8AfJ7I5gcGoVEY4nkWnOgUiT/IB4ORo7DK5Xt
	 pQo4hBXUqpilzCs0XV3v5J4OdHpu33X9xnZwm1/te7iWMcPbZIFnPvxmVmydLwmpIA
	 fsrOJ7Lnd8A3E6I2IY0REdsJEVZb1m81Apaguv1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Hector Martin <marcan@marcan.st>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/292] wifi: brcmfmac: cfg80211: Pass the PMK in binary instead of hex
Date: Mon, 22 May 2023 20:07:13 +0100
Message-Id: <20230522190407.869460135@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 89b89e52153fda2733562776c7c9d9d3ebf8dd6d ]

Apparently the hex passphrase mechanism does not work on newer
chips/firmware (e.g. BCM4387). It seems there was a simple way of
passing it in binary all along, so use that and avoid the hexification.

OpenBSD has been doing it like this from the beginning, so this should
work on all chips.

Also clear the structure before setting the PMK. This was leaking
uninitialized stack contents to the device.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230214092423.15175-6-marcan@marcan.st
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 2cc913acfc2d7..ad5a8d61d9385 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -1351,13 +1351,14 @@ static int brcmf_set_pmk(struct brcmf_if *ifp, const u8 *pmk_data, u16 pmk_len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_wsec_pmk_le pmk;
-	int i, err;
+	int err;
+
+	memset(&pmk, 0, sizeof(pmk));
 
-	/* convert to firmware key format */
-	pmk.key_len = cpu_to_le16(pmk_len << 1);
-	pmk.flags = cpu_to_le16(BRCMF_WSEC_PASSPHRASE);
-	for (i = 0; i < pmk_len; i++)
-		snprintf(&pmk.key[2 * i], 3, "%02x", pmk_data[i]);
+	/* pass pmk directly */
+	pmk.key_len = cpu_to_le16(pmk_len);
+	pmk.flags = cpu_to_le16(0);
+	memcpy(pmk.key, pmk_data, pmk_len);
 
 	/* store psk in firmware */
 	err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SET_WSEC_PMK,
-- 
2.39.2



