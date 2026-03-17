Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF51B33290F;
	Tue, 17 Mar 2026 17:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768430; cv=none; b=IgjiTM+tRmwHWRMT+KMBAer59GBMHnXDAC/ZxF2tUoNlGa3masaPv/GCrMHnwKhBZgoGg0bKjrAuu10ztuAnA94aWX3K6CRGDiuYJp0C7jS8NSk+OUMLXT2E5F0IC2Q4cGZGCeLv/JUmNYsEDP1lN6Ha0ebXYgUgNnqrSQuAbuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768430; c=relaxed/simple;
	bh=hTOhbsTLPHYXIBzq2Fb2Ktt+B5wmMDEI6DGqSbJpk30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/d6CRly+4NEl76pQur9w93o2MAu2MTOEiLvmqcA80HoJqcHhD+iNpcWAf+Qcyv2CDlHVGtN4q3iy3zmrUoAcv++0+jGK9BSIDU+/ERS/N2vbYHjRgU/YyG9+4m5HMhn49lMuvfQRXzhJ6ydBMePo3ikhNf98wC/Ud+KpbUEUKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeGEB1+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeGEB1+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDF4C4CEF7;
	Tue, 17 Mar 2026 17:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768430;
	bh=hTOhbsTLPHYXIBzq2Fb2Ktt+B5wmMDEI6DGqSbJpk30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeGEB1+FMoW2lS/iGQ5BqBx0xYUlZZy1Vt/TNe7xMbrv34rH85fMTTP/3Zb0CPPrB
	 AIrQg1ZJcn7hVkKzByi1URVNKjNPcaSKv0/OL7x28tT0scU0zl5Lh/Qbsr8O1GmSZY
	 dDiNiW/lbKlVDvqkH2bAW+SA1wBu6lAvDNY5vHBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasin Lee <yasin.lee.x@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 307/333] iio: proximity: hx9023s: Protect against division by zero in set_samp_freq
Date: Tue, 17 Mar 2026 17:35:36 +0100
Message-ID: <20260317163010.773038200@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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
@@ -719,6 +719,9 @@ static int hx9023s_set_samp_freq(struct
 	struct device *dev = regmap_get_device(data->regmap);
 	unsigned int i, period_ms;
 
+	if (!val && !val2)
+		return -EINVAL;
+
 	period_ms = div_u64(NANO, (val * MEGA + val2));
 
 	for (i = 0; i < ARRAY_SIZE(hx9023s_samp_freq_table); i++) {


