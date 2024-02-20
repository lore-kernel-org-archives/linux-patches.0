Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF99F1509BF;
	Tue, 20 Feb 2024 21:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463803; cv=none; b=sMOFsnzmQkaQpjvFQtUwh6tsbAy0BF3qzSpJywT00047sctQbBjGM124VqszJjdqrlYZFwv75AIpLUlkNKsJLYMZu7ClZlaYkMa+zdaq4mlE0p72SadOnEYaBB5R5lUrCH8X50XU/cBBRYiV8riR3F3zBd2AqhcJkflz7IPUk30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463803; c=relaxed/simple;
	bh=hQCjV42zBhaN/ClCeA00KqE58yXFQc/SkGmstEehADk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4I7ryGwYrFPhobIQMt1zEKKNRwFS81lpLy192/2R3Z+mM2ly2+b+DH8/sAqFYPSn34w+6Dy3uiEnKvMduZxAYrK0+pR+0Rrlop45kfRs4sJICg05ZdKN289q/dIz1wSLexpQmAoQ64NGZCiItXyuY49jJrwakuP/9C7OUJnvHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWwH92xg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWwH92xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1391CC433C7;
	Tue, 20 Feb 2024 21:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463802;
	bh=hQCjV42zBhaN/ClCeA00KqE58yXFQc/SkGmstEehADk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWwH92xgfmimuoqaVYweHXsa2Iot97aZUkhgg3MVHLzEhLJMUkJky9ka83vJPx9OP
	 vkn8Yooh3+A/XH4OXJC3ni7ipX7wHMGhIawI9ghv4ctiDuA/Jla8nlbDcXPkWrIqaS
	 nGdJZ2tToGzaVEQ7yf8p7MLhw64q4qfwHbgNu0u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 158/331] iio: commom: st_sensors: ensure proper DMA alignment
Date: Tue, 20 Feb 2024 21:54:34 +0100
Message-ID: <20240220205642.497485250@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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


