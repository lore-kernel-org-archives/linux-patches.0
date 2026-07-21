Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC3A35C68A;
	Tue, 21 Jul 2026 21:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668143; cv=none; b=bzWkvCsqVqKwuzS7KiDEJQw3eKCCicp7vUzal7q8RsuyIybt3vgIXxyzW4CbZ2d9qpBymn3j5FACOz3NmjJkGCLK+lf8HEvXChOd8gD7C1YthqiHH1k3LabWDSTYL6zVav1C8q/O9eEvL88USB6PEcg91PiD/V8j0rJBUhc3vh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668143; c=relaxed/simple;
	bh=reCUIoyf06owiDP2jNgT7++nfUkokndngQSG0c6iPQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ll2DhL1OWTTNpBEGCrCRr8g2LBxjU6cqj1WyeVTLXXA0s+0y+005ph7IeouDsNt1ebGoSEOvMzpT4oOy04Vkddg0zqmB4HGWl5+ag48Dl/vH2A1G9O0izdzvYwIL+Z8FW+9paN1+UuKG/WE1xDM0G9HVuHMtnzWHMB+ty2jFC7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2wM002n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2wM002n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A1E1F000E9;
	Tue, 21 Jul 2026 21:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668142;
	bh=q1CW0luHPmheUHVc7RyqMmSTk5WNbFJQczG4iggzwo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2wM002nGQM3ilxrShLwlerPPBd1YaCPELDR8158bMgjSZ06MbHSuzQaB6FVpANHG
	 Wn2wC/wQydcAvlXrup9CTMBgeL07D35yknS8vMSiqEdwlLZ10Ax0hE1nl2e2Y3i7yM
	 r6BKBuwNUIwHCvTdJdqZOTOb6cAaIfnfbBuWMHj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 0065/1067] iio: light: al3010: fix incorrect scale for the highest gain range
Date: Tue, 21 Jul 2026 17:11:06 +0200
Message-ID: <20260721152426.023632315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


