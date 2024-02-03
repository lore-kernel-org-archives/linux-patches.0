Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DA7199A7;
	Sat,  3 Feb 2024 04:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933690; cv=none; b=T57h0l9RdkxhrctBGNFEDVCOPfJZewEqX10LhShfUjPerKM3mg4FaO+2nUXmjjmC+wJ3Eq6wBS2mWJzquSbLCEdRZ69lClqAsxgP7nIWwt8vymm+j0DFYAWUa6UV7ZU++bKZ+5kCF6PH12+fEolAJpiFZeShc0xRSLzIxMkfHh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933690; c=relaxed/simple;
	bh=lYN0XAocGHNLPNo4UHSzdrtyVstwnQzfJUOWLbjR1R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FvFsbGExtf9sgfJ758CE2KH/l81GlCwtT8Rn3IRIWmVW5+H20rAnvBRNKFpQzJBkopINN2UibTp9UvcB02Yi/kHxpl52wZhGef1fcnxQP0LipgHICMJjeFtrPQqWZM1P8BIEJj8m+gitEKHwGA693YZTnbIxz7Jqbdv82ykcPVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZyMTpvjT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZyMTpvjT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D441C433F1;
	Sat,  3 Feb 2024 04:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933690;
	bh=lYN0XAocGHNLPNo4UHSzdrtyVstwnQzfJUOWLbjR1R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZyMTpvjTNGbn3+CsV137vcQj3hCctIVYf9C3IhQi26kMFUoyEQo4zDHLgl+si/19m
	 IIFkYkuCosLdL1ghjd40JR0LjQ4Ysi9COJOjFd2GhpCWtyvQyJcrlTjzrrwOs/Oe+t
	 7zFlCfbXknZwk8bfWeLTxaJNQYRAvb63j4d8pv5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/322] net: dsa: qca8k: fix illegal usage of GPIO
Date: Fri,  2 Feb 2024 20:06:23 -0800
Message-ID: <20240203035408.322894820@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Vokáč <michal.vokac@ysoft.com>

[ Upstream commit c44fc98f0a8ffd94fa0bd291928e7e312ffc7ca4 ]

When working with GPIO, its direction must be set either when the GPIO is
requested by gpiod_get*() or later on by one of the gpiod_direction_*()
functions. Neither of this is done here which results in undefined
behavior on some systems.

As the reset GPIO is used right after it is requested here, it makes sense
to configure it as GPIOD_OUT_HIGH right away. With that, the following
gpiod_set_value_cansleep(1) becomes redundant and can be safely
removed.

Fixes: a653f2f538f9 ("net: dsa: qca8k: introduce reset via gpio feature")
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/1706266175-3408-1-git-send-email-michal.vokac@ysoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 368d53d3b1d6..17c28fe2d743 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -2049,12 +2049,11 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 	priv->info = of_device_get_match_data(priv->dev);
 
 	priv->reset_gpio = devm_gpiod_get_optional(priv->dev, "reset",
-						   GPIOD_ASIS);
+						   GPIOD_OUT_HIGH);
 	if (IS_ERR(priv->reset_gpio))
 		return PTR_ERR(priv->reset_gpio);
 
 	if (priv->reset_gpio) {
-		gpiod_set_value_cansleep(priv->reset_gpio, 1);
 		/* The active low duration must be greater than 10 ms
 		 * and checkpatch.pl wants 20 ms.
 		 */
-- 
2.43.0



