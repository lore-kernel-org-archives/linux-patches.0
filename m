Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436C613DDC0;
	Wed, 19 Jun 2024 13:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803962; cv=none; b=qpsAvYAWG4gqRO+ouHxcEJX2VB5UI0RpD1DQNTYfK2Qg0Uy0fLHSGY8DqzfVciccO5WjNGnMZP7GO3IKpVyHMCYWsq9NPKx/XnT0Cf3AJNmzXq2z3C6XslVJlYegluHvMk16ApaNJGPSTCz9NytSV+Z9RWyz8jLmq36Q7LC+jzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803962; c=relaxed/simple;
	bh=9dIxBXm79B66d6HhPC2f8n1uauhMeRRgZiGcC7Itgxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb6XckMSO6Jv+yIeAXzet5KgPc2TgDTOwwGtlDbqtyiuGdYhWFKfkbguokDGHhcIsohhGtlGYQLxYDgZd0lmRj+AyMc2kSIHf/44G7qcV9BysUBONhqPkId1F5G/UA0qAmYzg/QTu+TvjxpCcaV/ktHEcKNHiun5mxtSbSxsdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QlAqMIiS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QlAqMIiS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB45EC32786;
	Wed, 19 Jun 2024 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803962;
	bh=9dIxBXm79B66d6HhPC2f8n1uauhMeRRgZiGcC7Itgxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QlAqMIiS2us8kRrmwZ0jjIZTsDX0iIQrpqBxVNYNfKyEjRazUpSQ5GgLrwGS2Mz8R
	 060WqfMFONF22vOSfruZzYGfOW5/HTORff/oa0XHhNf8cP6d7mSA5sWUrH0e6AEk/9
	 ggphyWb9i96Mq48xRe9k49rnN3X9HNfocyG37E6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Ferland <marc.ferland@sonatest.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 162/217] iio: dac: ad5592r: fix temperature channel scaling value
Date: Wed, 19 Jun 2024 14:56:45 +0200
Message-ID: <20240619125602.942735031@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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
@@ -410,7 +410,7 @@ static int ad5592r_read_raw(struct iio_d
 			s64 tmp = *val * (3767897513LL / 25LL);
 			*val = div_s64_rem(tmp, 1000000000LL, val2);
 
-			return IIO_VAL_INT_PLUS_MICRO;
+			return IIO_VAL_INT_PLUS_NANO;
 		}
 
 		mutex_lock(&st->lock);


