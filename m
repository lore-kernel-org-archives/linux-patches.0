Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC3E8635D;
	Tue, 26 Aug 2025 13:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213365; cv=none; b=o8cQlf/lUm9nRKFmxS8Ixw4iPhq4gA+mZ6rc3vmH82y1Qr5Gn7Mv5yGlfPkvs9Qi6ZLDFoNgHHsBs774bVVBX6q3LDy/zDjfAgVfsI/sZA6Isgzwf5HOZ45z7YRQtyJgG3kq8vWcvbsRdNObBhbItHEnJsIlylocvqZmrVT/Hsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213365; c=relaxed/simple;
	bh=m6U5lMo/iwurZhWltcAaWwithBWq18pMOvFkke/NgbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu3Jp+wAy0LbqVTOxetDz1YWizxOG0mSroSKFm+1tUHa2JmcNgR0aq5m/L+U/y+/ubSLQz+Ns2Tirc/GK4B1JkVU1C2Loy46/68wan70JzQRmuHS6Kt86C2WjUWtBORNqyxfWZahoRrqOwSIxQZRQPCQz/uvX5Texc2VQb4B01c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kavOqKhN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kavOqKhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFD0C4CEF4;
	Tue, 26 Aug 2025 13:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213364;
	bh=m6U5lMo/iwurZhWltcAaWwithBWq18pMOvFkke/NgbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kavOqKhNe6RlvWjgwDcSY/q7C4mkixCDTJqbWL26WSCeeVETTxUjylSp2VLk5WC3j
	 BM+fDK9+jBkOIRB2XnDV3rhTlQDQ+fFLFe4ktciTp12NNNSvi5tTN3CduBORr61Qt5
	 vZgYRUWeaFpWbiY4tiZhsAAIZdsju9x7VnIKg3dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Tyler Hicks <code@tyhicks.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 293/587] rtc: ds1307: remove clear of oscillator stop flag (OSF) in probe
Date: Tue, 26 Aug 2025 13:07:22 +0200
Message-ID: <20250826111000.380578559@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Meagan Lloyd <meaganlloyd@linux.microsoft.com>

[ Upstream commit 48458654659c9c2e149c211d86637f1592470da5 ]

In using CONFIG_RTC_HCTOSYS, rtc_hctosys() will sync the RTC time to the
kernel time as long as rtc_read_time() succeeds. In some power loss
situations, our supercapacitor-backed DS1342 RTC comes up with either an
unpredictable future time or the default 01/01/00 from the datasheet.
The oscillator stop flag (OSF) is set in these scenarios due to the
power loss and can be used to determine the validity of the RTC data.

Some chip types in the ds1307 driver already have OSF handling to
determine whether .read_time provides valid RTC data or returns -EINVAL.

This change removes the clear of the OSF in .probe as the OSF needs to
be preserved to expand the OSF handling to the ds1341 chip type (note
that DS1341 and DS1342 share a datasheet).

Signed-off-by: Meagan Lloyd <meaganlloyd@linux.microsoft.com>
Reviewed-by: Tyler Hicks <code@tyhicks.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/1749665656-30108-2-git-send-email-meaganlloyd@linux.microsoft.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index ae115c3fcf19..74aad2b12460 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1819,10 +1819,8 @@ static int ds1307_probe(struct i2c_client *client)
 		regmap_write(ds1307->regmap, DS1337_REG_CONTROL,
 			     regs[0]);
 
-		/* oscillator fault?  clear flag, and warn */
+		/* oscillator fault? warn */
 		if (regs[1] & DS1337_BIT_OSF) {
-			regmap_write(ds1307->regmap, DS1337_REG_STATUS,
-				     regs[1] & ~DS1337_BIT_OSF);
 			dev_warn(ds1307->dev, "SET TIME!\n");
 		}
 		break;
-- 
2.39.5



