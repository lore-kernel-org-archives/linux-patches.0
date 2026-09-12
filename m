Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434C44718E5;
	Sat, 12 Sep 2026 11:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213586; cv=none; b=TFHZA0R6NtXf7zFPpbxvqHM0Q+lKbjs4LTC5trPQntJg6VUM9h1xpkjBUr2j1y45R12cwgmpIvMOwOIe4MY253SbOpKOf02LZM1C7fm+PPba2CQxd/04h/yXafOLRDGMeEKPaeM1wyye5IUGlA7yqPs+wEo+ik0Z95X5MlR0EbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213586; c=relaxed/simple;
	bh=786aFitUhFCEpqtTLk6aTNkvSzcv/cCT+ICnJIrW4bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoHxED5d4c/WwSKOEmEHd/t+baz15Q3jNkzQtlic2aG605sA00OeEhebguiYhMxL/p3/2xvGZqiExmpx9eqezT9p4+KLVvuuyX71vtaSU9cJzQyM+dmEO94PgA2DW5hVCcepms/uAyAdmpNfWVcpOjyT+pllp9FnPKQt71g7E8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHbl6p4L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHbl6p4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7031F000FF;
	Sat, 12 Sep 2026 11:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213585;
	bh=KNF4oDjuYR6US4RqBU8NdbaGyRCvJJL1V6aSBTgu8JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHbl6p4L0o1nkhe4TTZucOJyp1kD4QRWP1BodmEQ79BZIjo0dEG4Mp8oeoSdMKi/G
	 ZocugS6o/qylpWkJqHx06nRs9345ZlnsHFgr5Eg4q1Ep5NYSrVWKXdOY0GSOOAnaFh
	 oruN8AriJLaSnugaXFmDyCR2mU+4QOSSK1TvOX1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 0153/1376] iio: light: opt4001: Reject integration times with a non-zero seconds part
Date: Sat, 12 Sep 2026 08:42:59 +0200
Message-ID: <20260912065610.961423206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Nikhil Gautam <nikhilgtr@gmail.com>

commit d0f21621f8b2b46661ea066d20705dbf7253db87 upstream.

opt4001_write_raw() only looks at val2 when setting the integration
time, so a write such as 1.000600 is silently accepted as 600 us.
Return -EINVAL if val is non-zero.

Fixes: 9a9608418292 ("iio: light: Add support for TI OPT4001 light sensor")
Signed-off-by: Nikhil Gautam <nikhilgtr@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/opt4001.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/light/opt4001.c
+++ b/drivers/iio/light/opt4001.c
@@ -269,6 +269,9 @@ static int opt4001_write_raw(struct iio_
 
 	switch (mask) {
 	case IIO_CHAN_INFO_INT_TIME:
+		if (val)
+			return -EINVAL;
+
 		int_time = opt4001_als_time_to_index(val2);
 		if (int_time < 0)
 			return int_time;


