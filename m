Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE03A22331F;
	Thu, 12 Dec 2024 17:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024578; cv=none; b=J0Ap9j3sULaOAlvhrP/Gc95fgbjlzOsaVdAHaXo0wA0o3x8StRVpppVTJe0RNIs19tg+mgGjR1C1+JjvKFdoSzuHVt/KYLja6olJ496IYx+MmaziZSfLww9nQ3iFE6MAC3MIusnwnbHXYE4AAwX75zym27e4jLOHGARpaH6GGgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024578; c=relaxed/simple;
	bh=IjEGRm8osZZIAGMJV8pPSwVRgeA16Nowlg6IHRcRp5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ps9dabshupv9wMA2h/NUSzlLTiavNvm2PMSJFNp2nYYu797XmavOb3VQdG2iRMcpGTIUzHJm4KB2zrNNyPRnnc8/v7ZTzhc1PTleIcNPWBW05pt9l/b5Qzx9frzXDHhh8h8nyfyjsEu5QYumvJWPuLKM6eqMe6vJjl89ZCgosZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jllpn5zR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jllpn5zR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF59C4CED4;
	Thu, 12 Dec 2024 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024577;
	bh=IjEGRm8osZZIAGMJV8pPSwVRgeA16Nowlg6IHRcRp5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jllpn5zR7XnwvdUBbMUzVXB50PJtRV3xMzidiZ/n9edReg8Wl8z9VVaPO8EX+6Lbk
	 iz+6+CGIp+G2ZOoy1rj50HK9tu/VzhryPA0apfZaMGSwiQ73EqvRKnUIyxbVGkr0K2
	 18xc8LBibcETWjyW4eGrYC8Ya2xOyGNfg4uuqPgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 315/459] ad7780: fix division by zero in ad7780_write_raw()
Date: Thu, 12 Dec 2024 16:00:53 +0100
Message-ID: <20241212144306.091086497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

commit c174b53e95adf2eece2afc56cd9798374919f99a upstream.

In the ad7780_write_raw() , val2 can be zero, which might lead to a
division by zero error in DIV_ROUND_CLOSEST(). The ad7780_write_raw()
is based on iio_info's write_raw. While val is explicitly declared that
can be zero (in read mode), val2 is not specified to be non-zero.

Fixes: 9085daa4abcc ("staging: iio: ad7780: add gain & filter gpio support")
Cc: stable@vger.kernel.org
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241028142027.1032332-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -152,7 +152,7 @@ static int ad7780_write_raw(struct iio_d
 
 	switch (m) {
 	case IIO_CHAN_INFO_SCALE:
-		if (val != 0)
+		if (val != 0 || val2 == 0)
 			return -EINVAL;
 
 		vref = st->int_vref_mv * 1000000LL;


