Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DDA27732;
	Thu, 16 Jul 2026 14:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211709; cv=none; b=j8maUA1EeaaUdMn1AJN4ftHz/yapCSYS5doLbrjdIQMCeUBybNf70VbgmJXA/harqalgsASyh12Zf8Rwp3aGGt3BhhqCBCcCHbpexkMQJ/EJAkKvd2wPHsOE+oSIu9VOLPEIx9F60tY+Ibtd0M1SIucJCnVZbTlSrm96YfAV4wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211709; c=relaxed/simple;
	bh=CVFWB9iH/rK5W6KUBGeFPx5VlTEMMu2YpbghLas9odU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMxtaObO+F/rtT6RbljLgj4J9owkhOylRodX/Gm3E62QD7YPQccJFi1khXDzp1lgvpSRubiKK8Ivq8SZaxq9VaJVkiIGZ+xMuSlo+2IkoGitMyZPPIqbp7pJsCimiTWtgDZGH4yb0bXYP0aB97KfzuJZVb5k2igmFXiVgN9LnTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dleCI5pY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dleCI5pY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4FC1F000E9;
	Thu, 16 Jul 2026 14:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211708;
	bh=6+ulSdj9k5BQm1RZ10sRg9wIggoKB4hwMWMSkid/CnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dleCI5pYHKuw6hFeWcQSoxYRAu8qVI3xmwhXVWE6nxUeNRzZ9UUI8H2KkxSCuhxiE
	 aR+Wyw6zRQAyjpI2qS0BvZ20eU723MD1muKBRUtdLb3cwu5kOX9fvZzziKvrZU7wJ5
	 e6a4o3HU2jVU59KyeubAsYVKKHU5sQzjsk7tlsFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 048/349] iio: adc: ti-ads1119: fix PM reference leak in buffer preenable
Date: Thu, 16 Jul 2026 15:29:42 +0200
Message-ID: <20260716133034.398325858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit adf4bc07f814da8329278d32600147f5a150938c upstream.

ads1119_triggered_buffer_preenable() resumes the device with
pm_runtime_resume_and_get() before starting a conversion.

If i2c_smbus_write_byte() fails, the function returns the error directly
and leaves the runtime PM usage counter elevated. The matching
postdisable callback is not called when preenable fails, so the reference
is leaked and the device may remain runtime-active indefinitely.

Store the I2C transfer result in ret and drop the runtime PM reference on
failure before returning the error.

Fixes: a9306887eba41 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -455,7 +455,11 @@ static int ads1119_triggered_buffer_pree
 	if (ret)
 		return ret;
 
-	return i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
+	ret = i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
+	if (ret)
+		pm_runtime_put_autosuspend(dev);
+
+	return ret;
 }
 
 static int ads1119_triggered_buffer_postdisable(struct iio_dev *indio_dev)


