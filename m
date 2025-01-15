Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F76C1E7C22;
	Wed, 15 Jan 2025 11:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938824; cv=none; b=P5FM6w/e/sD1p+fXnjORh6CsRlSTYBc7YEbmBdog2BMfA2x6qiL2Dsywt/UPtktFqDC9cI9dY+bbp+BaCutnzCXSY59bHRrPNTHF3d0QROyi6BHNCRQ5X5ppN8qkoUdbtg7dA+9bSZlZ+HRHPxWMHuhQ4/2JClY3qFX14Yaannk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938824; c=relaxed/simple;
	bh=Zk/ypXSW/XlzKa7yAS2qeE2srLU06k82snOcq4wLlZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baHBA+snxRWPYfDiFDqdJqj7QwxrBFUqk+rYDEMH/AWU8EJzzXvfZ98lzFNZOxuHEB6HSnhcA4yjkBLIFiHuIYp9RIN4IhPjh6hEgUp3MB+HQCqnNB/MUhPGCoE1erQCq2V3NhvCzgJ1ZE9ea/Z78yvTEvWqKidbauC5o5hiebo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xu7bSXED; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xu7bSXED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B84C4CEDF;
	Wed, 15 Jan 2025 11:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938824;
	bh=Zk/ypXSW/XlzKa7yAS2qeE2srLU06k82snOcq4wLlZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xu7bSXEDxRQkfKSXjuo3R/4+rs6hE4aFrB8ik22OElge5Qipd3YCukByPiwP84rYP
	 gbhAJWUyn0AE96qPMq1xxNlsTNc4k6JHHAYj9WUOkigApXiAlxlfz8ONYjAdFIqGsy
	 Aj6UQpWFeQDhIr8zdzn+sGf/8srNH5eS/5VH1KDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 107/129] iio: adc: ti-ads8688: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:38:02 +0100
Message-ID: <20250115103558.620353998@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 2a7377ccfd940cd6e9201756aff1e7852c266e69 upstream.

The 'buffer' local array is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: 61fa5dfa5f52 ("iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-8-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads8688.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads8688.c
+++ b/drivers/iio/adc/ti-ads8688.c
@@ -382,7 +382,7 @@ static irqreturn_t ads8688_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	/* Ensure naturally aligned timestamp */
-	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8);
+	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8) = { };
 	int i, j = 0;
 
 	for (i = 0; i < indio_dev->masklength; i++) {


