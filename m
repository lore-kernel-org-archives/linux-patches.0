Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F431E0B73;
	Wed,  6 Nov 2024 12:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897242; cv=none; b=m0GcaMzmeHjVGcxTxo2tV2SRMA67cMvmbqZSVahOZyAwZfvGtsfIGJ8urNXyJfS9+PDvEpR/GwstHS/6H4511jJos4MbqQbQ+Pwj+TbBH8YRgyNXJrp92ksIgFqcQhfxKPAIUj47ug8LFsqirmlHGzU2vfSExyNomxWUD026NVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897242; c=relaxed/simple;
	bh=Nkt+pE7E6Tw+6Uul3Pzu3mjSxGoMZrTLfUYwsmiUHv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bxN8mG3uvaxmArhGYXJ9WrRgDS2dvR/hNvjZOYHh/WuZMdxYqp8IgPwVraa0YFDYEXQRt4v67FaWo5V/v50ukAFDZMCvTAVZe9kN7txzlSiKJYH7Www9UepHGgWx9uDRpWyFoH/OmiRIMUrGmpjwXBO6ilcaspVouXed/mixflg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfOrcd00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfOrcd00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63231C4CECD;
	Wed,  6 Nov 2024 12:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897241;
	bh=Nkt+pE7E6Tw+6Uul3Pzu3mjSxGoMZrTLfUYwsmiUHv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfOrcd000FDIXevF7lLNlcI8hNKtMnznyZuBpONoTiu3xjcv1nmB8mFhLHBhMwNWe
	 d6O1rHVpTTaVdY02HyZbEu9Kzx40rqjM/heGVsMAs7CFVbCy/zg9H0bJKn3FIj+pMV
	 zBS8ROHEtaIHXJlV7KV+d0KpAKpG7cdcfxp2WOSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 077/126] iio: adc: ad7124: fix division by zero in ad7124_set_channel_odr()
Date: Wed,  6 Nov 2024 13:04:38 +0100
Message-ID: <20241106120308.165580134@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

commit efa353ae1b0541981bc96dbf2e586387d0392baa upstream.

In the ad7124_write_raw() function, parameter val can potentially
be zero. This may lead to a division by zero when DIV_ROUND_CLOSEST()
is called within ad7124_set_channel_odr(). The ad7124_write_raw()
function is invoked through the sequence: iio_write_channel_raw() ->
iio_write_channel_attribute() -> iio_channel_write(), with no checks
in place to ensure val is non-zero.

Cc: stable@vger.kernel.org
Fixes: 7b8d045e497a ("iio: adc: ad7124: allow more than 8 channels")
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20241022134330.574601-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -642,7 +642,7 @@ static int ad7124_write_raw(struct iio_d
 
 	switch (info) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		if (val2 != 0) {
+		if (val2 != 0 || val == 0) {
 			ret = -EINVAL;
 			break;
 		}


