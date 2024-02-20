Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13809151CEA;
	Tue, 20 Feb 2024 21:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464894; cv=none; b=NfXBpFdGRdh0OyCnQeceV9AHSIbx4yN9uNzNfU/rKw+i4Cl2K1utqV3QJYYjZXgYF69/zWPFouv8cHD83Z8QOlcTOpyY8gqA9TKtIFeJ3DV4wM6aAzma90uaYMj/xWi7XDFFk5UsJVNRWjJD9nuuueSJ/PHoCwvtNIVqiOlnI8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464894; c=relaxed/simple;
	bh=9efFdhyQoYQ8EO8yR3EGBO/sV6f26UoMEbF0i1B2/Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9o56NXJajHC5clx9cvujQaXbv90pJywGmQPe2DAaQQwvP0OzSVjt7JXgsIMAZeKWAd+Ftjf116Bhb/CZyJCx3BZCaD3p4XsW2197OWX18pQOZUFghRy1sZu6qfEezTXWNH7giKfSFUOdy9Q2Tjogcaj2ygpGsMJ7q6XjffJFqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUNhy+To; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUNhy+To"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89688C433F1;
	Tue, 20 Feb 2024 21:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464893;
	bh=9efFdhyQoYQ8EO8yR3EGBO/sV6f26UoMEbF0i1B2/Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUNhy+Toh3JqHnkrVbYSf0xNU1Uh9Rj+h0yVndcsK8NUPMPhogLyZ+uDyS2AyXsOd
	 6kORB/Vz6wiRwKtU0J7GkuUm7uBQMyqlGnY4dHM6JA6FvdDBYlRBBGFPj87TlX7y6N
	 CzOHc1WJkCZa2T6iyHx0GGo4+widkU/pNKZpyDLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 171/309] iio: commom: st_sensors: ensure proper DMA alignment
Date: Tue, 20 Feb 2024 21:55:30 +0100
Message-ID: <20240220205638.496043837@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit 862cf85fef85becc55a173387527adb4f076fab0 upstream.

Aligning the buffer to the L1 cache is not sufficient in some platforms
as they might have larger cacheline sizes for caches after L1 and thus,
we can't guarantee DMA safety.

That was the whole reason to introduce IIO_DMA_MINALIGN in [1]. Do the same
for st_sensors common buffer.

While at it, moved the odr_lock before buffer_data as we definitely
don't want any other data to share a cacheline with the buffer.

[1]: https://lore.kernel.org/linux-iio/20220508175712.647246-2-jic23@kernel.org/

Fixes: e031d5f558f1 ("iio:st_sensors: remove buffer allocation at each buffer enable")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240131-dev_dma_safety_stm-v2-1-580c07fae51b@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iio/common/st_sensors.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -258,9 +258,9 @@ struct st_sensor_data {
 	bool hw_irq_trigger;
 	s64 hw_timestamp;
 
-	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] ____cacheline_aligned;
-
 	struct mutex odr_lock;
+
+	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] __aligned(IIO_DMA_MINALIGN);
 };
 
 #ifdef CONFIG_IIO_BUFFER


