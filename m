Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBF612FB31;
	Wed, 19 Jun 2024 13:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802382; cv=none; b=oXgqYLuR70m7dUeXEUtzGWYbuEuuDTLVlunO/wtsHByp9aB8QoDB0hej/nYDGbeQVYQqmPsubC+uyPO6GGM8V+G7K6KqyHa6WbFZf3dhN5Ih/6vYcVUoy4Dp3aUZyntFAniqtjPe4HQKTSuQNzrDl6z3WK9eR2VBCDS1MtH7+48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802382; c=relaxed/simple;
	bh=FQAX9eRe2m7wYJ6PMdywmM+1K8Mwlx8vtsunzvxByVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGUL9VQV2V+AzLJi3NjLk3cynbxUu0IT5+vr8C11DD5AJPZlmlw7JJ/6Ak4nrpiCdXalqF7qTPtM13WARiLjvjAMu2Rm/uBUkzl0VKve2eTwSHP9gWdevYMEwwM2gkZpMxcR3CqM8Ei+lhD1M4/ApJAuNER35/s33Y6DJspwRmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jrlg5R6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jrlg5R6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84FBC2BBFC;
	Wed, 19 Jun 2024 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802382;
	bh=FQAX9eRe2m7wYJ6PMdywmM+1K8Mwlx8vtsunzvxByVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jrlg5R6VN2YszykjOLKTesFJFyDDgJ9fNNjeYCpNyInQFpL50RH3hW5QF7Y7caOS6
	 tUVYHPF0QIjGPf2aQ33xZ/OGGWAgj3THX4zyW+zV9CW7PRdII6gaoeK/2/CLXPxwy8
	 7ZaTcpOaverXsN24LY8gxDFPl1JvVVikfjL+8Zds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Ferland <marc.ferland@sonatest.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 177/267] iio: dac: ad5592r: fix temperature channel scaling value
Date: Wed, 19 Jun 2024 14:55:28 +0200
Message-ID: <20240619125613.137442484@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Ferland <marc.ferland@sonatest.com>

commit 279428df888319bf68f2686934897301a250bb84 upstream.

The scale value for the temperature channel is (assuming Vref=2.5 and
the datasheet):

    376.7897513

When calculating both val and val2 for the temperature scale we
use (3767897513/25) and multiply it by Vref (here I assume 2500mV) to
obtain:

  2500 * (3767897513/25) ==> 376789751300

Finally we divide with remainder by 10^9 to get:

    val = 376
    val2 = 789751300

However, we return IIO_VAL_INT_PLUS_MICRO (should have been NANO) as
the scale type. So when converting the raw temperature value to the
'processed' temperature value we will get (assuming raw=810,
offset=-753):

    processed = (raw + offset) * scale_val
              = (810 + -753) * 376
	      = 21432

    processed += div((raw + offset) * scale_val2, 10^6)
              += div((810 + -753) * 789751300, 10^6)
	      += 45015
    ==> 66447
    ==> 66.4 Celcius

instead of the expected 21.5 Celsius.

Fix this issue by changing IIO_VAL_INT_PLUS_MICRO to
IIO_VAL_INT_PLUS_NANO.

Fixes: 56ca9db862bf ("iio: dac: Add support for the AD5592R/AD5593R ADCs/DACs")
Signed-off-by: Marc Ferland <marc.ferland@sonatest.com>
Link: https://lore.kernel.org/r/20240501150554.1871390-1-marc.ferland@sonatest.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5592r-base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -415,7 +415,7 @@ static int ad5592r_read_raw(struct iio_d
 			s64 tmp = *val * (3767897513LL / 25LL);
 			*val = div_s64_rem(tmp, 1000000000LL, val2);
 
-			return IIO_VAL_INT_PLUS_MICRO;
+			return IIO_VAL_INT_PLUS_NANO;
 		}
 
 		mutex_lock(&st->lock);


