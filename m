Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40D732E6BD;
	Sun,  7 Jun 2026 10:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828472; cv=none; b=cKI5//VtszYUmfYRZsDYSy1QNAys0oZ5RoYLx5nLv8aEna217LyhKdxITRvzH84wBPrE3X5OeFB9H7ucgtteUfsIJEUjPZud22WaCrAZKqlpaRNgtLg5WNkwSIKY4gEHQ19/6du5IezrVlj8IB2ALsVmSupt482RxB5tPsN92+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828472; c=relaxed/simple;
	bh=0kvcD4T94HysqgVe5YKtTv2jqTXq0stxOloc88nDUMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9KUFiLYetTFzNadgMKrEOYGGUn4TY02HVXiQiq3wFWzTXGdvRsYMpa2xG65q88dVjHda3PTUElIDquuI9IMUK+/cljYXBhr39ABJBh8Ge1mvY/+yUsrJogrMxjTcMZeKXMq3XvHxWj1SfLGykRlyrsIXS7I1jUPNMRpn7BzReE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRo5gJMh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRo5gJMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF901F00893;
	Sun,  7 Jun 2026 10:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828468;
	bh=+Kf+iZU/nto8StDDjKDzx2qZEonqXBPoSbBfBAxUK6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRo5gJMhqCYVDJKCaDLanLRdIKJpiENYYM4GBxGXzy6TpvxS3Z5PXSUWoqEHEeOQn
	 ZXJBOqIxW9KLP6cK2AkFXDAFAUOmeJ0bbyQJQfpgJGx71aHwINgRFGQA9a2Rqs1BqT
	 Cisy/X9EZDpZstuzpY/XuXqu8Lj6pnzl29kQM8E4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 161/315] iio: adc: mt6359: fix unchecked return value in mt6358_read_imp
Date: Sun,  7 Jun 2026 11:59:08 +0200
Message-ID: <20260607095733.506113106@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit f9bbd943c34a9ad60e593a4b99ce2394e4e2381b upstream.

In mt6358_read_imp(), the variable val_v is passed to regmap_read()
but the return value is not checked. If the read fails, val_v remains
uninitialized and its random stack content is subsequently reported
as a measurement result.

Initialize val_v to zero to ensure a predictable value is reported
in case of bus failure and to prevent potential stack data leakage.
This also satisfies static analyzers that might otherwise flag the
variable as used uninitialized.

Fixes: 3587914bf61d ("iio: adc: Add support for MediaTek MT6357/8/9 Auxiliary ADC")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/mt6359-auxadc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/mt6359-auxadc.c
+++ b/drivers/iio/adc/mt6359-auxadc.c
@@ -497,6 +497,7 @@ static int mt6358_read_imp(struct mt6359
 		return ret;
 
 	/* Read the params before stopping */
+	val_v = 0;
 	regmap_read(regmap, reg_adc0 + (cinfo->imp_adc_num << 1), &val_v);
 
 	mt6358_stop_imp_conv(adc_dev);


