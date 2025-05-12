Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CD878F52;
	Mon, 12 May 2025 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071120; cv=none; b=rZVYwAepo37vMXB3HNJ6+/OIGhLmjbefaFM47hLpH3Lr7afD1hk0hpWNPRa3jo1+1SsQE5kamzp+nPEOw0IIGscE8XIi20MdrxgErddfFOzxoCckDWtV47RdifaX51AL9eFWoOAFwgDzgZGMCxzfCuSULLCXWdZsGfXa63bIPkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071120; c=relaxed/simple;
	bh=NBVR+Q/OXccXyWmyliEjYlU1eAK3yxI+ybiFl/mVfwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BXeEb9aRO3gtgwz/w9UxgMk3znrSjj/RtTi6TKdtcE9tVKgU9uZeivOXcQai9zFl0lKwIxZOcgu7SFr8NmIifSnmrk7HMr0xvw3DEdTgcIcqNUBvdKzfZppfda+BGYNSJjWwoG03kkZl6UiAmL1RsTMMa6ekMD3ueAesrtL1k/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEZo5VVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEZo5VVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86238C4CEF0;
	Mon, 12 May 2025 17:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071119;
	bh=NBVR+Q/OXccXyWmyliEjYlU1eAK3yxI+ybiFl/mVfwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEZo5VVjDr69N7lBRuxydNPrE3Rk0lL7tYCqF4KjbEHZjyOZkEABTdWWFMg7vP2Mg
	 Zx1mFW2rIvQhuts2bnWU/0+16fJ1LIuW37gKPwYYuRlUohdgf50FJ/FwUQuq7Ciy1D
	 BX68PKSd7J01a8zBRK0H9zz1ulVVaeCHvOUyVpZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andy@kernel.org>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/54] iio: adc: dln2: Use aligned_s64 for timestamp
Date: Mon, 12 May 2025 19:29:58 +0200
Message-ID: <20250512172017.496555973@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
References: <20250512172015.643809034@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 5097eaae98e53f9ab9d35801c70da819b92ca907 ]

Here the lack of marking allows the overall structure to not be
sufficiently aligned resulting in misplacement of the timestamp
in iio_push_to_buffers_with_timestamp(). Use aligned_s64 to
force the alignment on all architectures.

Fixes: 7c0299e879dd ("iio: adc: Add support for DLN2 ADC")
Reported-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250413103443.2420727-4-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/dln2-adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/dln2-adc.c b/drivers/iio/adc/dln2-adc.c
index 97d162a3cba4e..49a2588e7431e 100644
--- a/drivers/iio/adc/dln2-adc.c
+++ b/drivers/iio/adc/dln2-adc.c
@@ -483,7 +483,7 @@ static irqreturn_t dln2_adc_trigger_h(int irq, void *p)
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct {
 		__le16 values[DLN2_ADC_MAX_CHANNELS];
-		int64_t timestamp_space;
+		aligned_s64 timestamp_space;
 	} data;
 	struct dln2_adc_get_all_vals dev_data;
 	struct dln2_adc *dln2 = iio_priv(indio_dev);
-- 
2.39.5



