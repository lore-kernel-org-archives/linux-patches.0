Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A9B3B19DE;
	Fri,  9 Oct 2026 14:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556881; cv=none; b=reM3wQ3e/Jx+AK6SysJqLE/+rZgTniEr9IAdYHDvZIBLPxNjNBbNagmuFBN3ZTF97xIhEKyZtP0oXoh+Zc3yX131vVSJStt9atSxa5mWBav+x4gPsSHXa9YsOFeFlSNrh1LCQP63ir8RNeWtCMS96oXtGt+fhvbiAGuCU4+KeBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556881; c=relaxed/simple;
	bh=iEPjXf5kP92JuByo+HpK67OfM4Xaz3DbNW6XT1bsNAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g29K51ghkv3jqP6kysP0HI2ixCPzh/0EiZ9090J7wejTxOwl2z4VBKw3DARo7xrWHY7lUANDkT9vIBji9kYj/ddgZfNh67AkQAeKjnrPDRQ3VHpOhTnTv41xIWq0hs1jB5h/+JLx1JBiSj7Na2ebB1cmddZw6fvCr5oM8p2Z5eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pjj1fa5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pjj1fa5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBC01F00898;
	Fri,  9 Oct 2026 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556879;
	bh=qtLx5c9HTk9ZRF613hUrueMnN/4eETNxX978sTi22+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pjj1fa5CuaY96hmzn8V585on5PN7uRa8GyjZTI4lJa7p3r7JBZLcvV1DnvwerZszl
	 oF4+trAt0DzC5jcP3Tjk+YRCgewlJwQgkr1JdZ0lOb5nVJctZ7xd1jSy+v6gFPFvlG
	 iLqHElO/4Myt3CVDmVIQMLWyTJhPZfI2rY/6O2WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 308/403] iio: adc: max1363: sign-extend bipolar differential channel reads
Date: Fri,  9 Oct 2026 16:11:09 +0200
Message-ID: <20261009140959.420048489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit 91908c0a78baddc8572aa3ab69e62ee2eb496ba4 upstream.

MAX1363 differential channels are bipolar, but max1363_read_single_chan()
masks the raw value to the ADC resolution without sign-extending it.
Negative differential readings are therefore reported to userspace as
large positive values (e.g. -1 as 4095 on a 12-bit part).

Sign-extend the masked value from the resolution bit for differential
channels. Single-ended channels are unipolar and are left unchanged.

Fixes: d1325cf45077 ("Staging: IIO: max1363 ADC driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/max1363.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -407,6 +407,14 @@ static int max1363_read_single_chan(stru
 
 		data = rxbuf[0];
 	}
+
+	/*
+	 * Differential channels are bipolar and the device returns the sample
+	 * in two's complement, so sign-extend it from the resolution bit.
+	 */
+	if (chan->differential)
+		data = sign_extend32(data, st->chip_info->bits - 1);
+
 	*val = data;
 
 	return 0;


