Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462B6140E38;
	Tue, 17 Dec 2024 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456366; cv=none; b=RVSemLSdGapHf0IW+cWTk0is3pMsuYZHHQLBN/7aRRbtdOi5BqoZflUIYTLFXNWIAHWLLy6XsJVXPsFX5TmExzK0pjQoO9YwzhsAbnh5L16vHRUje7c72eJA/NKtHMoniNm+PZf5glK0xmNHW6E/EBdtgNCtr0zOKR17HtQjygg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456366; c=relaxed/simple;
	bh=SO280cgDUVKpTtnToB2BBs1cS8IqmOXGB1Mm1tfjPlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXMu1e1mcqmOUgA/M+DLkGwjcQV0pcvmYn5JyIAvsqSh0UTDvzxriwTR4gAlT6aMol0CBnxU5kWguT/G2zX4ifYKkmOrOrUT2rez/AFhRzQw2Pfd8W2rdETFT2p2BJhwJYXeHejl+HpxsfDQUIFxbLS+Oh+ht2Mc0wptk9Ni+kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXnmhPwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXnmhPwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF029C4CED3;
	Tue, 17 Dec 2024 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456366;
	bh=SO280cgDUVKpTtnToB2BBs1cS8IqmOXGB1Mm1tfjPlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXnmhPwAYZxpucgmm4v3PuvsFqFzoc8fQBuaIKtMjZ8/Scr2uF7ashGi0KB5vIOa7
	 RE2Hs2FGSAXHo8824nLNaVy0hzumgzdMmJHgFjnidC9m8KSK/zcuhyNqLXP1+ocr0c
	 K/poYZLXQstBYveIY+Ykpqf7lW65QKUDfhSGl638=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 6.12 036/172] gpio: graniterapids: Determine if GPIO pad can be used by driver
Date: Tue, 17 Dec 2024 18:06:32 +0100
Message-ID: <20241217170547.759794663@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

commit 0588504d28dedde6789aec17a6ece6fa8e477725 upstream.

Add check of HOSTSW_MODE bit to determine if GPIO pad can be used by the
driver.

Cc: stable@vger.kernel.org
Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Andy Shevchenko <andy@kernel.org>
Link: https://lore.kernel.org/r/20241204070415.1034449-6-mika.westerberg@linux.intel.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-graniterapids.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpio/gpio-graniterapids.c
+++ b/drivers/gpio/gpio-graniterapids.c
@@ -37,6 +37,7 @@
 #define GNR_GPI_STATUS_OFFSET	0x14
 #define GNR_GPI_ENABLE_OFFSET	0x24
 
+#define GNR_CFG_DW_HOSTSW_MODE	BIT(27)
 #define GNR_CFG_DW_RX_MASK	GENMASK(23, 22)
 #define GNR_CFG_DW_RX_DISABLE	FIELD_PREP(GNR_CFG_DW_RX_MASK, 2)
 #define GNR_CFG_DW_RX_EDGE	FIELD_PREP(GNR_CFG_DW_RX_MASK, 1)
@@ -90,6 +91,20 @@ static int gnr_gpio_configure_line(struc
 	return 0;
 }
 
+static int gnr_gpio_request(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct gnr_gpio *priv = gpiochip_get_data(gc);
+	u32 dw;
+
+	dw = readl(gnr_gpio_get_padcfg_addr(priv, gpio));
+	if (!(dw & GNR_CFG_DW_HOSTSW_MODE)) {
+		dev_warn(gc->parent, "GPIO %u is not owned by host", gpio);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
 static int gnr_gpio_get(struct gpio_chip *gc, unsigned int gpio)
 {
 	const struct gnr_gpio *priv = gpiochip_get_data(gc);
@@ -141,6 +156,7 @@ static int gnr_gpio_direction_output(str
 
 static const struct gpio_chip gnr_gpio_chip = {
 	.owner		  = THIS_MODULE,
+	.request	  = gnr_gpio_request,
 	.get		  = gnr_gpio_get,
 	.set		  = gnr_gpio_set,
 	.get_direction    = gnr_gpio_get_direction,


