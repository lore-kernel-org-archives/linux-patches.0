Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8DB1509BC;
	Tue, 20 Feb 2024 21:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463097; cv=none; b=atROixFfjnGHGbgmCkmZvLYrABmCRzsUvCJtFheY5WjS636ItfXFmHVEBrMOiHCtUdMBxtJ2CmU3CmnIN2ap5bDn/vfj7V8vdCILRTJFjZIlqwigwxFt7BdJj78ju+lB4hNfU4sF9fNo5OAVs+/asE8/l4Ns1VBG1jqRJGJyLYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463097; c=relaxed/simple;
	bh=6ETZHzPvsFtSXyX7uWwJIGnGDXqc9GYy70R6fJ65O0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtFGpMwbHhaqXUdz7CNT3u7M2yQPORdU6euQ26DtB1lakPXKy3TOHiigDf+X/QbwpXDQy2nMUVxA1YLbEIResPQf67aKUJ4DDid8bIYDbXGPU3srtTTfXOQatm+tdHJyPmIyeLExzi7zBQ2AVgQ0az1EXZgNG74Ds8ytUzMc1B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E0Zqsn3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E0Zqsn3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A134C433F1;
	Tue, 20 Feb 2024 21:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463097;
	bh=6ETZHzPvsFtSXyX7uWwJIGnGDXqc9GYy70R6fJ65O0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0Zqsn3EKHjym4JjoCs6t4CEk//7brTAhsw9t+LjnsT2R5dYUtctB7O5i6dT7U+Eq
	 m+7EmdTyvedAAVIMwLXrmGI1kARjl6ODBRLVqly4G1ICWN2ejFDBJJV4UoVAWebT2f
	 /NJ4RGIxn07yEa6NjisqG7O7prw+SqZbvUS2VvSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 104/197] iio: commom: st_sensors: ensure proper DMA alignment
Date: Tue, 20 Feb 2024 21:51:03 +0100
Message-ID: <20240220204844.195662850@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
@@ -261,9 +261,9 @@ struct st_sensor_data {
 	bool hw_irq_trigger;
 	s64 hw_timestamp;
 
-	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] ____cacheline_aligned;
-
 	struct mutex odr_lock;
+
+	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] __aligned(IIO_DMA_MINALIGN);
 };
 
 #ifdef CONFIG_IIO_BUFFER


