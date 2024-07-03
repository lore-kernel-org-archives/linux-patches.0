Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3488F1741DD;
	Wed,  3 Jul 2024 10:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004136; cv=none; b=MLXw1stmQQlytQcIqVUyGwRH62nJ0lEzJeJqn3M6eH8PVuZ0bssFFFhPmNFLTf3rjJv+dkUEvjvFPtpG8EjpUF7c9JpYdu4dPUDfwEKv1tj9INwYwOvm6+P3yIZE6B2TSEhHRjSyhFti9zcYuhrEoe9c6xPEnaC1fQCj4edOGi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004136; c=relaxed/simple;
	bh=x2h4Pr+a+LjAkfRqgr7BCXsxanK5dinpBLbQMrhTBV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tl06VQMpZ72xfppzYVycrgG8gflxkAe12EKnPSQEyllgea2FXgRVm+e1OPxloeJf3pvNkXfYnuV6VzM3l3AZ10lnxuuQw6NC9mlYTdQsHZ9og+fFikp7i52OFjBOO6h75n6Q57sNOt/RC0GMBYO8dg5yhGqQBD2w7ytKoroMFkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nq/dsYJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nq/dsYJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B28C4AF0D;
	Wed,  3 Jul 2024 10:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004136;
	bh=x2h4Pr+a+LjAkfRqgr7BCXsxanK5dinpBLbQMrhTBV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nq/dsYJ+VKFnD/9HQ3T909rLSCfoPrVovAYAxJ4qdvbBRwVD7zPDN4r/eFoKCcTHr
	 Y8Z8NgP+3dX+y77LL0GKsfN+LSrShc3Q86QwehWuar9fWDcDUAzuojoBhWeNWEhf29
	 GQEAyNXJUJgjZ0prj81lVPmoeGDsYhlnG4e7IybY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Ferland <marc.ferland@sonatest.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/189] iio: dac: ad5592r: fix temperature channel scaling value
Date: Wed,  3 Jul 2024 12:39:54 +0200
Message-ID: <20240703102846.505655192@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Ferland <marc.ferland@sonatest.com>

[ Upstream commit 279428df888319bf68f2686934897301a250bb84 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5592r-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5592r-base.c b/drivers/iio/dac/ad5592r-base.c
index 5c242479bb811..75025be02dd29 100644
--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -414,7 +414,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 			s64 tmp = *val * (3767897513LL / 25LL);
 			*val = div_s64_rem(tmp, 1000000000LL, val2);
 
-			return IIO_VAL_INT_PLUS_MICRO;
+			return IIO_VAL_INT_PLUS_NANO;
 		}
 
 		mutex_lock(&st->lock);
-- 
2.43.0



