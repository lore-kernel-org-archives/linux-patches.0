Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEBB1ACED7;
	Tue, 29 Apr 2025 18:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949663; cv=none; b=K28i5tKRY3U5dz8Ujf8LsaQwP1kGXvEGnm8eKOcfSpcwTGTOmkR8mzFq8Mq3hllkcCrnF8ZuyMmBfH8yR6Z9Zb//vGNWgIfweWBGijh1cd9jmNmVALfQ30tRxZE5S4icgMJ5lrKaMi1R7mW74VRmlOJ9QoylRu5xA3i37pewF+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949663; c=relaxed/simple;
	bh=lcodI+Y/bVqYL5AG/hPhgvmppY+mdQP3wk47tAGYKYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YRHb7681x4xFKjmDkpq+UDCUGPepywgZmGJA3BGN5dgPWh1X2Jal98SDhKm3e4JPS5FcGXHy0xXksaoa3ed1IQBTI6N5P5OVG7Ns7HjGueLtrqy6qSqkquP/TuEdSVMhZ7HxgzPHMsups+Pf3fDXVlMEQj723FOmHb4Eaiik8A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1jZnWMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1jZnWMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BA0C4CEE3;
	Tue, 29 Apr 2025 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949663;
	bh=lcodI+Y/bVqYL5AG/hPhgvmppY+mdQP3wk47tAGYKYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1jZnWMBFTvIrzyfWjiHjIHSZyM/xIXQgCz85ygAS1CSBINE+iXwEeewgSuIeMt1G
	 IBizCLLa5VPKHXDIqAF48noaG3NuF8oo3PcZP/4eCqbN8htonC+QxP9S4p/KHEexAb
	 CN9eRZY9Z0+q8v8k3cLi0MeLNgtPk9bNda+9veqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/167] iio: adc: ad7768-1: Move setting of val a bit later to avoid unnecessary return value check
Date: Tue, 29 Apr 2025 18:42:05 +0200
Message-ID: <20250429161052.450273540@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 0af1c801a15225304a6328258efbf2bee245c654 ]

The data used is all in local variables so there is no advantage
in setting *val = ret with the direct mode claim held.
Move it later to after error check.

Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250217141630.897334-13-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 8236644f5ecb ("iio: adc: ad7768-1: Fix conversion result sign")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7768-1.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iio/adc/ad7768-1.c b/drivers/iio/adc/ad7768-1.c
index 70a25949142c0..19d604f5701d6 100644
--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -370,12 +370,11 @@ static int ad7768_read_raw(struct iio_dev *indio_dev,
 			return ret;
 
 		ret = ad7768_scan_direct(indio_dev);
-		if (ret >= 0)
-			*val = ret;
 
 		iio_device_release_direct_mode(indio_dev);
 		if (ret < 0)
 			return ret;
+		*val = ret;
 
 		return IIO_VAL_INT;
 
-- 
2.39.5



