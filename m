Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B20563FB9;
	Wed,  9 Sep 2026 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962376; cv=none; b=KoY4LseRUzhZpCl1a1SP6fkrAp5WltXP0O7DA9RKUyUF77Ikuvou+W7zHeqPR8E7g7050kNeyHVXcyUwNMxZFxEeYH5Ygza5LL8xWhemnDHcpzFCTqshxvyfevyFunuH/9+LTbL9KIzCPI+lP4qZ4iWBMix+USo/vC2t80jmxAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962376; c=relaxed/simple;
	bh=EYzIz12HRpw44Dzh5oTMwGwYuJMunHqVOPLEFcEo3NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WU6+3TCiohWd6zLYHtRVp8WB57GNamf8cL31fgbmg26DEl4zeb3r0aUpnG451mCygly3cW1xBsLRuSZ49VHS6m7feG49NAFfG41hPUqYCgPCNkGrPpbvzNRZG+J4fSWPVrWrH3eAgKeiBuDDwhFFtmfza4LnYYO6vXw5bYEwx/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mhQOQgK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mhQOQgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0BB1F00A3A;
	Wed,  9 Sep 2026 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962375;
	bh=KsLFlLgfmhji9/7MSNUSY/0FAkjVRSIniTm2ZG2lkAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mhQOQgKSm01oZB+v53TAqL2GFD14Ug2ELvNx/ZFa2Tzf9Bh+6pMjwspdd5CjSZ7J
	 b1Q5pwgQoKOXSxqpI0M6L/ZuoJ1pKXul18QQ/a1E7jdsJxl4dvbrAMBFnqhRxvsshi
	 nbHgDOrTVhOviwFX2Yh2gTo35fgs7GNHu+6Ypm4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Babanpreet Singh <bbnpreetsingh@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 270/556] iio: dac: ad3552r-hs: fix scnprintf() buffer bound in data source show
Date: Wed,  9 Sep 2026 15:39:10 +0200
Message-ID: <20260909134240.096428555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Babanpreet Singh <bbnpreetsingh@gmail.com>

commit f2c5c76306fadb834dd5ea76cab0b7cd447e6035 upstream.

ad3552r_hs_show_data_source_avail() formats the available data source
names into a 128-byte stack buffer, but bounds each scnprintf() with
PAGE_SIZE instead of the buffer size, so the bound does not protect
the destination at all.

This cannot overflow today - dbgfs_attr_source[] has two entries,
"normal" and "ramp-16bit", 18 bytes formatted - but the bound stops
protecting the stack the day the table grows. Use sizeof(buf) so the
bound matches the destination.

Found by smatch:

  drivers/iio/dac/ad3552r-hs.c:593 ad3552r_hs_show_data_source_avail()
  error: scnprintf() 'buf[len]' too small (128 vs 4096)

Fixes: b1c5d68ea66e ("iio: dac: ad3552r-hs: add support for internal ramp")
Assisted-by: Claude:claude-sonnet-5
Signed-off-by: Babanpreet Singh <bbnpreetsingh@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3552r-hs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad3552r-hs.c
+++ b/drivers/iio/dac/ad3552r-hs.c
@@ -590,7 +590,7 @@ static ssize_t ad3552r_hs_show_data_sour
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dbgfs_attr_source); i++) {
-		len += scnprintf(buf + len, PAGE_SIZE - len, "%s ",
+		len += scnprintf(buf + len, sizeof(buf) - len, "%s ",
 				 dbgfs_attr_source[i]);
 	}
 	buf[len - 1] = '\n';


