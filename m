Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C735646;
	Wed,  6 Nov 2024 13:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899251; cv=none; b=lHtyRjzByN0QF1Wwcooke4hh8xxmblHXx4gpRuakCgXcTHNwdjVFrHFmMbDsYP4vvKwimxPWnFdeyc7UcIjWpdciyn3CRs3xJNWDuYtasvEFAXexSS6yGuuSYLY+nz9xrmgroEQXm53sHWcvM7r8ZTHC6MZ8JPEsW8OjEoS/JnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899251; c=relaxed/simple;
	bh=vGOKkIw1fjr0tCZ0TjRg012AER4MpsFsfTaiKXpj0V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6QReLROgxliTcbkGcaJWHd6ai1FJdWTyA0Uy+WIg1M+DEPhjHNLkTi/iO+ICO9ZppupA8vS8tNwzp2Wo149l1TYKhSJxSMqD2hStAo/fsXU9ZvjmbfH0vff6d4zHYZ6iAcottP18wxVAVks+xFLgZxU5SLFLvNq0CyDqnf4Rg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pKiXr9DY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pKiXr9DY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B677BC4CECD;
	Wed,  6 Nov 2024 13:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899251;
	bh=vGOKkIw1fjr0tCZ0TjRg012AER4MpsFsfTaiKXpj0V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKiXr9DYEvLNhYFcCAhk3nCLVhZbVTE9fm9VIEdaG9JdqSvWbXELaUKr54DOgdeDd
	 63vlH6ASDWcXXY3vIFBH/gLHomQJBojnwz73GIENIxUPaeIYH1D/rbGUx16n2aLBdQ
	 snpJQSqeVkr66onJOPnU6E7EKF3QqQ6LYEaZyutA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 48/73] iio: adc: ad7124: fix division by zero in ad7124_set_channel_odr()
Date: Wed,  6 Nov 2024 13:05:52 +0100
Message-ID: <20241106120301.398926014@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -596,7 +596,7 @@ static int ad7124_write_raw(struct iio_d
 
 	switch (info) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
-		if (val2 != 0) {
+		if (val2 != 0 || val == 0) {
 			ret = -EINVAL;
 			break;
 		}


