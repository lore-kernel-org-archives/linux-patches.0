Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2893F148315;
	Tue, 25 Jun 2024 09:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308277; cv=none; b=cICcZVtTfYOc4181PFELMCs6kqjM4TudiHF5Hixin6XNt7tO1/CFn8YgJnmb4ia5z/KD4oQBBBGX7ZcxuCIbQWOnSKaYV00yyIBOFM3T+cqEJPFxo1BTuDefPAfGwdp8VqLsHTa20DMH20l+GmFPyzzpD5+popPrpHmpAvyqHj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308277; c=relaxed/simple;
	bh=XnCkSJ5/hNJ7F0sUXekmvcSpYWUPfu0BQiewyLHs3vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXhSWF8aW0jxrVEf0GjDwoMnWwnhL0+d/cpOqIniP9TqUomgPCkc+ThcQrXAKHXyh9uaiRhzqt3dwY5FIEKNNbmH42KH4cmpmf4QRyOLaGapIzdQ5ycc0rL+qwHNB0Za4yvL1gdA2U7upon4kj+u8nBJZUpu1tdXS3MF9f/+upg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqXNXiwN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqXNXiwN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A03C32781;
	Tue, 25 Jun 2024 09:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308277;
	bh=XnCkSJ5/hNJ7F0sUXekmvcSpYWUPfu0BQiewyLHs3vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqXNXiwN4aHd7WCQOU6VfWYiky9B6708viGh+XfME+oSD1JYbKu5u2XSs+uZUMhB9
	 DAjn2SmY/Va6ozx79uPiuSwHgGfUxpGFL+4CDJvA03YRekrEhRTvKmmnfCNe/lt+fw
	 T5Hv4bq9vx/ccauGNeRJHU+IlJqBlWGfDg47YS0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 035/250] net: dsa: realtek: do not assert reset on remove
Date: Tue, 25 Jun 2024 11:29:53 +0200
Message-ID: <20240625085549.406206482@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit 4f580e9aced1816398c1c64f178302a22b8ea6e2 ]

The necessity of asserting the reset on removal was previously
questioned, as DSA's own cleanup methods should suffice to prevent
traffic leakage[1].

When a driver has subdrivers controlled by devres, they will be
unregistered after the main driver's .remove is executed. If it asserts
a reset, the subdrivers will be unable to communicate with the hardware
during their cleanup. For LEDs, this means that they will fail to turn
off, resulting in a timeout error.

[1] https://lore.kernel.org/r/20240123215606.26716-9-luizluca@gmail.com/

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/realtek/rtl83xx.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl83xx.c b/drivers/net/dsa/realtek/rtl83xx.c
index d2e876805393b..a9c1702431efb 100644
--- a/drivers/net/dsa/realtek/rtl83xx.c
+++ b/drivers/net/dsa/realtek/rtl83xx.c
@@ -290,16 +290,13 @@ EXPORT_SYMBOL_NS_GPL(rtl83xx_shutdown, REALTEK_DSA);
  * rtl83xx_remove() - Cleanup a realtek switch driver
  * @priv: realtek_priv pointer
  *
- * If a method is provided, this function asserts the hard reset of the switch
- * in order to avoid leaking traffic when the driver is gone.
+ * Placehold for common cleanup procedures.
  *
- * Context: Might sleep if priv->gdev->chip->can_sleep.
+ * Context: Any
  * Return: nothing
  */
 void rtl83xx_remove(struct realtek_priv *priv)
 {
-	/* leave the device reset asserted */
-	rtl83xx_reset_assert(priv);
 }
 EXPORT_SYMBOL_NS_GPL(rtl83xx_remove, REALTEK_DSA);
 
-- 
2.43.0



