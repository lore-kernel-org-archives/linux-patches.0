Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1965381B03;
	Mon, 23 Mar 2026 14:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275777; cv=none; b=PQmGuSoS4CKYsfMO1twKiYMC2fkWlOJf+XHjUiwpwlg3fEH2XpZ8QITKDykAY0Qiehk1KBEPkvwqoxII0ZPVq6JxTNMKc4fODjLDaKzLjE6owbs+hyV5pctNur0ueyXss2mLcBk/sZEBuX1NkSZTFqDBTe4ByOtRAh0z3ORctHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275777; c=relaxed/simple;
	bh=Ew/UFhsbuSvz2U/688yp6dLldIOxC5I80HQD5+FTrhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QixNBE1YAVoH2HUllSqzA+HRHA+m9nbeetrW1cJ1hMWQWCqj/akyssFw7N1IWABoXxuq7jloTpfykLZAjcjwx/O4xRa11kZLnnF+wmS/DAw9maruxviqWwAmh9qMaucGVA2D7wr5i/t5jef8S1NTD/TUsGsDYNdjx0omHDQn9WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kf1fvlSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kf1fvlSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C09C2BC9E;
	Mon, 23 Mar 2026 14:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275777;
	bh=Ew/UFhsbuSvz2U/688yp6dLldIOxC5I80HQD5+FTrhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf1fvlSQ+oaJPT2sOW8c5XHjkWoljJzoYovv3tw3V2r5ZmEebrueA8kscNdfjzIG7
	 EObaRifOrqraTSUsSSdVUq55LXHdBXfQYoZgOxKpf6dt+sBJ3vIeAVPmhSo4TqVNi7
	 iD5DncEyEtIXXNE3vJLURMQq9APEy4y1yEFsB6z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasin Lee <yasin.lee.x@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 214/460] iio: proximity: hx9023s: Protect against division by zero in set_samp_freq
Date: Mon, 23 Mar 2026 14:43:30 +0100
Message-ID: <20260323134531.770995950@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Yasin Lee <yasin.lee.x@gmail.com>

commit a318cfc0853706f1d6ce682dba660bc455d674ef upstream.

Avoid division by zero when sampling frequency is unspecified.

Fixes: 60df548277b7 ("iio: proximity: Add driver support for TYHX's HX9023S capacitive proximity sensor")
Signed-off-by: Yasin Lee <yasin.lee.x@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/hx9023s.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/proximity/hx9023s.c
+++ b/drivers/iio/proximity/hx9023s.c
@@ -708,6 +708,9 @@ static int hx9023s_set_samp_freq(struct
 	struct device *dev = regmap_get_device(data->regmap);
 	unsigned int i, period_ms;
 
+	if (!val && !val2)
+		return -EINVAL;
+
 	period_ms = div_u64(NANO, (val * MEGA + val2));
 
 	for (i = 0; i < ARRAY_SIZE(hx9023s_samp_freq_table); i++) {


