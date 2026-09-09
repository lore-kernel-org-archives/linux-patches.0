Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F9D58FD37;
	Wed,  9 Sep 2026 14:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963977; cv=none; b=nyat32UpSAOYHNMyo1fGWzi0MG3BNFyDcteEvp2OXs5W1VM6cuV1/L9feGy5D1QgcES7iLFk8FUMcNZdSAbelINWTrP6lnEvl3pJtYjYIct3+OHUVQAaWI7A+bppARXSp4jYstxHZU8DYOakEBVNtgGRlEivHfGkxC77b35p4bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963977; c=relaxed/simple;
	bh=vxRpuvpQcOx+vTi9biYeyyhbF+WrL6QVZCM0wsCqwtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZ1tgpP2osIIrI5Hreje5CpyTYp0E3Ozf0/jhEJdWy7Tc+iqrjyl7R6XXoizwtIvVedzM7CaurYA6DaeFAzRM/bfHmvsVRo7qzOqHOgm7OrsEtqwSXP4zTfGcJI69D+4S8tMSML7YTh6HmG/cWNvVhyZsciyvYiJz2+Aig1k97M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiQGVWdR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiQGVWdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8577F1F00A3A;
	Wed,  9 Sep 2026 14:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963976;
	bh=0LINfbDWGWaQkpr1EznbidFcBFMHACtxIOSEaDTTrzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RiQGVWdReMbOjktMhLEq65el72nvzI1Rys8FKTF/TCkoUqTDQ5KXcCbjrz+FMojtr
	 3ZEhfUaKBm73GNXytah9bl9budEM9e5f77sdIDx6DSC257FJKI6IZizCGIklyFtLjv
	 mmKUhO6GS7WCRQ9w6y1wbPk2iPlmTr1lkmM3wirc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikhil Gautam <nikhilgtr@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 227/583] iio: light: opt4001: Reject integration times with a non-zero seconds part
Date: Wed,  9 Sep 2026 15:38:32 +0200
Message-ID: <20260909134246.024978167@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


