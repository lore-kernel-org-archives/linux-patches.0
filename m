Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEC746EF88;
	Tue, 21 Jul 2026 20:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664998; cv=none; b=uqs6YEFfvHIkJk9ylY7w3St6vmAoj4MhQrBRXLftA0v9W/6/Bz0q7DfRgwHx7KAKwg/wnmrjD51GRiQu0Bad58nHsiUZWdhhSei7AXdfuCCfv3/DzlJ0lUgv6Jk1nb1/6doMwKuuTZfIkY0ENOwPo5K5RusVyyPkh00WVzycxIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664998; c=relaxed/simple;
	bh=KCrA+bJdv1VTF6DwXXXHpD/O0D2ezCwLFZ76FVwcjdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BIK+FQJMc4Q028GaGrvGmhk6qmSYJ+dw/QmO7t8HfXBz27oCf2ERr3cLZZ74a2XHG8fV/pU2YqMdZLydHRAikzOt79KQOOM6CTbh/xO187QOFwoX+w67r15PHljbEnlwJVSeB9alRoNPEkc2T7FPtSgw4k/iwmxClS2oute7yf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/5xnHTh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/5xnHTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26EB1F000E9;
	Tue, 21 Jul 2026 20:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664997;
	bh=DZS3DLqh+e8VkIRNhtvj8qJdY5b+kwrdvvpVWNCLsb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/5xnHThb2LPTrbw8gqRxTvzw4AaY1nf9honI1kZuQngvh8/xKuqYQsH2BkhdS3eq
	 6n00fEnmI1Dtmcl6ixQ4Y4VYe19xh/tBB/v5BF4zo3aelqSSGJdk7NbQbCebNn+4Nm
	 4AV8A3ka43vemqZIr0bwXqG9OnfbQThMRgWMZn0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0095/1266] iio: light: al3010: fix incorrect scale for the highest gain range
Date: Tue, 21 Jul 2026 17:08:52 +0200
Message-ID: <20260721152443.930800360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit aa411adc6ce40ad1a55ebc965f255a4cfc0005f8 upstream.

al3010_scales[] encodes the highest gain range as {0, 1187200}.
For IIO_VAL_INT_PLUS_MICRO, the fractional part must be less than
1000000, so the scale 1.1872 should instead be represented as
{ 1, 187200 }.

Since write_raw() compares the value from userspace against this
table, writing the advertised 1.1872 scale never matches the malformed
entry and returns -EINVAL. As a result, the highest gain range cannot
be selected. Reading the scale in that state also reports the malformed
value.

Fixes: c36b5195ab70 ("iio: light: add Dyna-Image AL3010 driver")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/al3010.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/al3010.c
+++ b/drivers/iio/light/al3010.c
@@ -43,7 +43,7 @@ enum al3xxxx_range {
 };
 
 static const int al3010_scales[][2] = {
-	{0, 1187200}, {0, 296800}, {0, 74200}, {0, 18600}
+	{ 1, 187200 }, { 0, 296800 }, { 0, 74200 }, { 0, 18600 },
 };
 
 struct al3010_data {


