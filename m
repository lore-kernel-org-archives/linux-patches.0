Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD91E244675;
	Wed,  4 Feb 2026 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216446; cv=none; b=Z/WWf5Pge81mWbLi99GJGUHSfslJudUoI+on2buyVcVbc5/jfiqSmSm7kPRRoF+ZW2RIRjKyPI9T2xMtuU2TdAsDruDpm1WSg5PCjq8QLDHc36uynsKZY/9Sz5asQNY4+qp9vGFskazcZoNgNqkoivVBsSJOhKQbLpe1oS6miKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216446; c=relaxed/simple;
	bh=qvor09EpHF619Q/TgH+TxMBwYWWtnfHzqcgYLS7XVqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITbpdN73jl1NNs8OwgkakBzmFzEd00InCOjWi+/O7bPd+4XfmWK6Z3BsZfq2TodZVAHE9kpLNoMjEgaEBycU3Opv7HQj7RmHqHdPjRqxU1vkGNdm7rI4iMjz8dNANu8y+odVzBzNjvme7adbbWnyrKDPI99eGRfyEjqMjq+8anc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tl3gSYNc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tl3gSYNc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0ADC4CEF7;
	Wed,  4 Feb 2026 14:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216446;
	bh=qvor09EpHF619Q/TgH+TxMBwYWWtnfHzqcgYLS7XVqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tl3gSYNc/eCbZ325eYDWqPgX9YGcqq71myhDqg2viiMLVMHUafw+l1r1MOz7nDyNg
	 muks9gUwSWdtP1JCvIa4gzcKtwZHzhvFOBGY3rpARcwmJ+mdEYOnu4N1Nnq2I+RcEg
	 Y6k4dxJAJarzFW87pUeIsIaO/0dHMem2ORpZPMdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 090/161] iio: adc: at91-sama5d2_adc: Fix potential use-after-free in sama5d2_adc driver
Date: Wed,  4 Feb 2026 15:39:13 +0100
Message-ID: <20260204143854.984685082@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

commit dbdb442218cd9d613adeab31a88ac973f22c4873 upstream.

at91_adc_interrupt can call at91_adc_touch_data_handler function
to start the work by schedule_work(&st->touch_st.workq).

If we remove the module which will call at91_adc_remove to
make cleanup, it will free indio_dev through iio_device_unregister but
quite a bit later. While the work mentioned above will be used. The
sequence of operations that may lead to a UAF bug is as follows:

CPU0                                      CPU1

                                     | at91_adc_workq_handler
at91_adc_remove                      |
iio_device_unregister(indio_dev)     |
//free indio_dev a bit later         |
                                     | iio_push_to_buffers(indio_dev)
                                     | //use indio_dev

Fix it by ensuring that the work is canceled before proceeding with
the cleanup in at91_adc_remove.

Fixes: 23ec2774f1cc ("iio: adc: at91-sama5d2_adc: add support for position and pressure channels")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/at91-sama5d2_adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -1891,6 +1891,7 @@ static int at91_adc_remove(struct platfo
 	struct at91_adc_state *st = iio_priv(indio_dev);
 
 	iio_device_unregister(indio_dev);
+	cancel_work_sync(&st->touch_st.workq);
 
 	at91_adc_dma_disable(pdev);
 


