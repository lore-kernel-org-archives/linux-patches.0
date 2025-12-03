Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B13376BE4;
	Wed,  3 Dec 2025 16:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781069; cv=none; b=T0+hvLnJqRVjnWCdk8rKK4fE6MjfAceQDL3xKSzS7LYJO3+RIM28DVCc0SOyC+PuU/3MOAxGEE+ftXJixWqo/pr6EHZ/WVqJ4u3lB3fd00I1j3bl0bNEhJhevZ24t+wmyXzvGwNWmb1rGsnQbTBqGgz2gJ4drJSOFUpOjDtIa88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781069; c=relaxed/simple;
	bh=EoGQL/YVRlV9NpQGmAJulvkeDseChIOy/tZk5liyCow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I5ICGvCS1qRPqDiwfr7vms+I+9o8CjZQxKsyb12OdFG/KZbK+EY5M/sSeUbW4Jlw01pJcM8xFPM+ZCeYbuYyuXSlxFRcZ6lviyxS9EC3g7aS64gpS+oo2Aio+nPVQ4YPXkUOA9LfmpbwmCzs9jp8qW6JBCsJcxTGYirqn9u9n70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rf27lQfo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rf27lQfo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2998C4CEF5;
	Wed,  3 Dec 2025 16:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781069;
	bh=EoGQL/YVRlV9NpQGmAJulvkeDseChIOy/tZk5liyCow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rf27lQfo5sNPFP3znOkXouF+Go7IjYqjznvU3LXzS8BP4e6o7N/Xzb0sp1ZF84648
	 NsSsDqto7C49jk9/D7pBqdfWo3n3+s94BI+OGOJSKo0Wj38eqBt9FFN/3doktPsWUk
	 q5XfvH/8UApwTbBrNk6NR0OwZ1iq3OdzdX9EJBgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 39/93] iio: adc: ad7280a: fix ad7280_store_balance_timer()
Date: Wed,  3 Dec 2025 16:29:32 +0100
Message-ID: <20251203152337.963750950@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit bd886cdcbf9e746f61c74035a3acd42e9108e115 upstream.

Use correct argument to iio_str_to_fixpoint() to parse 3 decimal places.

iio_str_to_fixpoint() has a bit of an unintuitive API where the
fract_mult parameter is the multiplier of the first decimal place as if
it was already an integer.  So to get 3 decimal places, fract_mult must
be 100 rather than 1000.

Fixes: 96ccdbc07a74 ("staging:iio:adc:ad7280a: Standardize extended ABI naming")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7280a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7280a.c
+++ b/drivers/iio/adc/ad7280a.c
@@ -540,7 +540,7 @@ static ssize_t ad7280_store_balance_time
 	int val, val2;
 	int ret;
 
-	ret = iio_str_to_fixpoint(buf, 1000, &val, &val2);
+	ret = iio_str_to_fixpoint(buf, 100, &val, &val2);
 	if (ret)
 		return ret;
 


