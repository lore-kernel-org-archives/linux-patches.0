Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C542BAF6;
	Sat,  3 Feb 2024 04:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933950; cv=none; b=HvDrIbdGe1Z8Od/DXB2wTFV32AP8eLmTWyVPw+iPnnGcrWBr5WGd4jIyUEHOEkYax98RELsRW51E/OE5B/7MIboJ2wxWrrc9XyvU78ek1tAaOJYElHpKf68c4Oeouc7cAdidOtS2U7Y4d8yZzxumUNdBi11XfiLrHXd/NdyVh38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933950; c=relaxed/simple;
	bh=4vyygbz+TauV5cgLzf4/HPuTeR83HfrLZip8UfRbvqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IQ3qDiFs8gcxujZPdw3gohnfWhODbTaYGXIWQeWfULM1uI8nlAyVfm95MbqN34OhkjYU1iRVWmVFJdHMmre81gVMiuPVnWeYr61DO6FOBSaLrJ6mDlW1YO8b9hX6v1FL1dFB7MaetemaK71Zd2X1BIcxY38KFfzIyIKxIt0t1qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omEujvEm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omEujvEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E764C433C7;
	Sat,  3 Feb 2024 04:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933950;
	bh=4vyygbz+TauV5cgLzf4/HPuTeR83HfrLZip8UfRbvqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omEujvEm7nkk83ubEMWcnyAMoL4WGhwuCiv7YH44KoK+XxtTVKw2+re4uaia9mkNc
	 7pC8KoYQEZUKzesWQCqVsnzRyB4EyxeShTDoOlssY6QdY10+edyxb9u3htuTWYP0UT
	 ZXg5SU7KNkZ8BFcvr8NJ+1pRgDh2ZDjdCrXw0E3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 317/353] net: dsa: qca8k: fix illegal usage of GPIO
Date: Fri,  2 Feb 2024 20:07:15 -0800
Message-ID: <20240203035413.865202327@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 5f47a290bd6e..6f2a7aee7e5a 100644
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



