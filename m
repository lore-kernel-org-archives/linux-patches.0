Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DC8248BA0;
	Wed, 15 Jan 2025 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937750; cv=none; b=eDlUA/MtlyqpEoMwUXCOxBQok4bp3Yh5y09rBUUDmfVzV8mUKZxIz38FQr0ErOb6uR3yWs+BozdPW8hO0R5bMOsM4vEW3Obpb7xrkqmrS4pETGlEHELAMxd5PA9pCq55rNX9zksFNJ1PHp4z1OVaa+4J4OaO91AIMhdDYiTeaWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937750; c=relaxed/simple;
	bh=oFWj45c437OU1D2g5jOMeCLc0keQzvDNh0UVqXALW+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQ6g+KE1oLVoqMeuFU8u1TxqAPYjHNYTNjnTg0Ur9WgKqVlPy/fOZKS91yMry8Q+9ff5xYqhcfwnCRMG0i2VIRG3rzBTSkavU+L7VccNJpX17qEQhZmie0FMtQRMWkKFVAUUmXpXsZ9P28ct+31sh0u609231vE97v0OULftgAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxPcRId/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxPcRId/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DB5C4CEE4;
	Wed, 15 Jan 2025 10:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937749;
	bh=oFWj45c437OU1D2g5jOMeCLc0keQzvDNh0UVqXALW+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PxPcRId/F2zm7WmcNsWMGScYcmDJJbi7ipkFe7zHhXGTSNrtk/5XBS3elfh0+lrGG
	 clOslvt1PezX5mQc7o4WZh2PPF92pmlmqZnLPLEHPRju08p1vDrbALaIqDFfAI94bg
	 OgwHtRGpmogSSsMjSL6sDR9nmNvuq5GMbQ2xJH6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 71/92] iio: light: vcnl4035: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:29 +0100
Message-ID: <20250115103550.388839564@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 47b43e53c0a0edf5578d5d12f5fc71c019649279 upstream.

The 'buffer' local array is used to push data to userspace from a
triggered buffer, but it does not set an initial value for the single
data element, which is an u16 aligned to 8 bytes. That leaves at least
4 bytes uninitialized even after writing an integer value with
regmap_read().

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: ec90b52c07c0 ("iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_timestamp()")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-6-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -105,7 +105,7 @@ static irqreturn_t vcnl4035_trigger_cons
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct vcnl4035_data *data = iio_priv(indio_dev);
 	/* Ensure naturally aligned timestamp */
-	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8);
+	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8) = { };
 	int ret;
 
 	ret = regmap_read(data->regmap, VCNL4035_ALS_DATA, (int *)buffer);


