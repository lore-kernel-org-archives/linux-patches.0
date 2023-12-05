Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9975879E3;
	Tue,  5 Dec 2023 03:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPgiqala"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE27FC433C8;
	Tue,  5 Dec 2023 03:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746576;
	bh=RW8DQrwd4h01ZvVqVmR8uCtj846/lQzpvGuymrfO00Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPgiqalav1+TurztHP5M2vb0QRqGsO6dm9Mba0kNOSRNFIrqkPoMXahC8fceqKFAb
	 RZ2VbC9CwGFxCCu/v7S788iQydMDRIE6TmelAtRrrtgfuoGU2wnFfnL+zezm7eJymH
	 HDAPKBd55zZg0IagJRjrd0N92bJa2qBjyDXlc7fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 076/134] pinctrl: stm32: fix array read out of bound
Date: Tue,  5 Dec 2023 12:15:48 +0900
Message-ID: <20231205031540.307173525@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit edd48fd9d45370d6c8ba0dd834fcc51ff688cc87 ]

The existing code does not verify if the "tentative" index exceeds
the size of the array, causing out of bound read.
Issue identified with kasan.

Check the index before using it.

Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Fixes: 32c170ff15b0 ("pinctrl: stm32: set default gpio line names using pin names")
Link: https://lore.kernel.org/r/20231107110520.4449-1-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index 419eca49ccecb..346a31f31bba8 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1283,9 +1283,11 @@ static struct stm32_desc_pin *stm32_pctrl_get_desc_pin_from_gpio(struct stm32_pi
 	int i;
 
 	/* With few exceptions (e.g. bank 'Z'), pin number matches with pin index in array */
-	pin_desc = pctl->pins + stm32_pin_nb;
-	if (pin_desc->pin.number == stm32_pin_nb)
-		return pin_desc;
+	if (stm32_pin_nb < pctl->npins) {
+		pin_desc = pctl->pins + stm32_pin_nb;
+		if (pin_desc->pin.number == stm32_pin_nb)
+			return pin_desc;
+	}
 
 	/* Otherwise, loop all array to find the pin with the right number */
 	for (i = 0; i < pctl->npins; i++) {
-- 
2.42.0



