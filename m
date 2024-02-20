Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF25151CDC;
	Tue, 20 Feb 2024 21:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463813; cv=none; b=OReqKVFp8EmIP4ErYnsWcuypaX4tF201BfD0U0Odazmb3p15GSIJCFL3UMkBSEeUgSyfUFvIT1U6w8C00ok+3HuqT5CCK6EALF7nUivKgJrsKXj5hX/pjE730uf17asgwysw6DHEh/6UB8pRek313Nebr5MpQ6QE60iL8Y3nmng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463813; c=relaxed/simple;
	bh=H7kUqLkMP32ETMVNs/fMWfxjIhWwe1iQiaKkn5mkcKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxRk9bb+tdj5VC81m2v3zLsBe/NDFmgmSefTzZaRYuMSK7jcBeK8hILX6iOo4jxQuI1RZixuvNU5JMxe14pZ5RjP3Gp9cqcMjQqK3fsqCR54AXxwsU01Gv3eqasCTO/4kKyitkcj6AhF7mis5hdFwav6h/VT2+ZJdXeGwsLgG2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/f/900j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/f/900j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1DEC433F1;
	Tue, 20 Feb 2024 21:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463812;
	bh=H7kUqLkMP32ETMVNs/fMWfxjIhWwe1iQiaKkn5mkcKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/f/900jeRHSiCnvEJYsI/PbzTdx2eASnPtkeg2Z+4/tnPTbE6AuhtsL84vsT+0Q+
	 /KUKTZd83DiN41d1qTpmUeW3nNvG+wpKMiiq1rzEL9JraJynhNCSdKXhXu6kmbTxn/
	 KDRaFCJAdHsPpZlzM3rYvALOJ0W3CMahoVhW33Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 161/331] iio: imu: adis: ensure proper DMA alignment
Date: Tue, 20 Feb 2024 21:54:37 +0100
Message-ID: <20240220205642.600045399@linuxfoundation.org>
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

commit 8e98b87f515d8c4bae521048a037b2cc431c3fd5 upstream.

Aligning the buffer to the L1 cache is not sufficient in some platforms
as they might have larger cacheline sizes for caches after L1 and thus,
we can't guarantee DMA safety.

That was the whole reason to introduce IIO_DMA_MINALIGN in [1]. Do the same
for the sigma_delta ADCs.

[1]: https://lore.kernel.org/linux-iio/20220508175712.647246-2-jic23@kernel.org/

Fixes: ccd2b52f4ac6 ("staging:iio: Add common ADIS library")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240117-adis-improv-v1-1-7f90e9fad200@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iio/imu/adis.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/iio/imu/adis.h
+++ b/include/linux/iio/imu/adis.h
@@ -11,6 +11,7 @@
 
 #include <linux/spi/spi.h>
 #include <linux/interrupt.h>
+#include <linux/iio/iio.h>
 #include <linux/iio/types.h>
 
 #define ADIS_WRITE_REG(reg) ((0x80 | (reg)))
@@ -131,7 +132,7 @@ struct adis {
 	unsigned long		irq_flag;
 	void			*buffer;
 
-	u8			tx[10] ____cacheline_aligned;
+	u8			tx[10] __aligned(IIO_DMA_MINALIGN);
 	u8			rx[4];
 };
 


