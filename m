Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5982212564;
	Sun,  7 Jun 2026 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828774; cv=none; b=M9Lnza9qScul2fvdubdrvXHDbkPdaz0ucB6JFO7jLOORKbUcX8Uv5gDLmI5383dSYcLQ6+TAKMtWYYalk7TV/DVArn6HQ45Q3KahH0VYZlUls3gOqJfRv4Uq/OxG5YH1SRk8ddSt6fG+IU7GmtFqZz46MrYfWZa/v6UGK6TbAY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828774; c=relaxed/simple;
	bh=Jked75wG9pn4436BnQahFzrpv/5o4edo012dg1nyO5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtuKthZddMZQTYvo9xIXnN8i+LKaFe7J82rWLi1z9OR5aH2iph3hfpPh1kVx+ME9RHcrDY58OgUnJRnAPTSgHx3YjCbedPROeKmbB9WFxb2CJpkjIA4cFRKMHocvaFIaItUC3FG/Yg1AujD0Wu2KEd9l3hLQmUWGbud5qP7sT3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cF6yQkwb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cF6yQkwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169CE1F00893;
	Sun,  7 Jun 2026 10:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828773;
	bh=4rCmsriME6wbvwxDsqu+lkySB2+xB8KIN/Fxz282LgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cF6yQkwb2VkcmIKxTSHj4M511LDebWyAJw3jJ0KV9CROnFKnX79hgVXKpx5jXHKPw
	 xbCV6mBcSwdi4Wq/7fJgV4Ittf6nSSAjj0xpnOlnyClaOcCGAYs4zwvF/q+GQ2ZwJk
	 I04jyvV30bjygESEBdidxDFmC7+a/boTPj/85BEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 167/307] iio: adc: mt6359: fix unchecked return value in mt6358_read_imp
Date: Sun,  7 Jun 2026 11:59:24 +0200
Message-ID: <20260607095733.857889239@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -347,6 +347,7 @@ static int mt6358_read_imp(struct mt6359
 		return ret;
 
 	/* Read the params before stopping */
+	val_v = 0;
 	regmap_read(regmap, reg_adc0 + (cinfo->imp_adc_num << 1), &val_v);
 
 	mt6358_stop_imp_conv(adc_dev);


