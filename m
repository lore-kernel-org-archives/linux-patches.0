Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BC42D739D;
	Tue, 17 Mar 2026 17:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768413; cv=none; b=mFOtXoHoEF6vZqfKOMi5DJzjfyVPTbQMnYW5GLRLXoJYyacvvorlga0WyA6Fm34maXc4wkI84V1U+Vqo71GvD6lyA+C2GXe/zhSRRON4nOD75eYFx4wEGNoangfqe2xbL04qtoHn/ZYfKKsGSheNiySBLs4eEBokMt5sgz6BNN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768413; c=relaxed/simple;
	bh=+ClwrZIhukUJMFXUUCrFkAuKoqQ0HcFRBdEPVSTAHDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6nH1hvGyCN4OR+Rhi+2AUrxDHqGdofdcFwxmk9GUlFNknsMPfJ1U4kLV6dB0jPAPtqaLVogD1sqVwubYptrr44f82pn3e4A1HsC4wrngP7aH9AXvhbbPImjxS45+RT+//j0HD+OJB/2Id1+2xCR0vsVR/9E7qp1L3FyGpvZOTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOREtb2S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOREtb2S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB47BC4CEF7;
	Tue, 17 Mar 2026 17:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768413;
	bh=+ClwrZIhukUJMFXUUCrFkAuKoqQ0HcFRBdEPVSTAHDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bOREtb2SaZEFxFgCVl6zQdGi5Sru4nFCz6wSoRU4wiZJZtqlTlD9bhqpYZ76biCg8
	 uw7auMv9fE350g7LuvFhYQbzd9JO+R2h3WTkybgaMBgQUuamniXgJmUgbGPcR2z9ZW
	 H12Pweva85bEl889DldkGAy8gsT5DrEFbv8AYbXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Linus Walleij <linusw@kernel.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 303/333] iio: light: bh1780: fix PM runtime leak on error path
Date: Tue, 17 Mar 2026 17:35:32 +0100
Message-ID: <20260317163010.627071267@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit dd72e6c3cdea05cad24e99710939086f7a113fb5 upstream.

Move pm_runtime_put_autosuspend() before the error check to ensure
the PM runtime reference count is always decremented after
pm_runtime_get_sync(), regardless of whether the read operation
succeeds or fails.

Fixes: 1f0477f18306 ("iio: light: new driver for the ROHM BH1780")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/bh1780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/bh1780.c
+++ b/drivers/iio/light/bh1780.c
@@ -109,9 +109,9 @@ static int bh1780_read_raw(struct iio_de
 		case IIO_LIGHT:
 			pm_runtime_get_sync(&bh1780->client->dev);
 			value = bh1780_read_word(bh1780, BH1780_REG_DLOW);
+			pm_runtime_put_autosuspend(&bh1780->client->dev);
 			if (value < 0)
 				return value;
-			pm_runtime_put_autosuspend(&bh1780->client->dev);
 			*val = value;
 
 			return IIO_VAL_INT;


