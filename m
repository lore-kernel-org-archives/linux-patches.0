Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0541487CD;
	Thu, 12 Dec 2024 17:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023094; cv=none; b=qt55mIpAgcHRWfOI+4yeSY+cGlYcVqTiTkFUmfpDFy76b9TY/4RQHkqrzPnXAXHjX0PVzv9RcDl+WjyJtRA892NBT5PSHXUg/0D3zVQCiuI2kdlWFz3u/icplHMj49O+xCc9uiYCfCfdF2RTdzjkRdkjcW2YxglFPD7FoMdAzk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023094; c=relaxed/simple;
	bh=4BtvbyAN57JlXyUSI8hkqmHvTam0+vrlfF7KsQJg9zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrauBqqPfktKLktgw57hf4HHXr7b0FhzYgaZOOghl+nFd9pLXtHv3UtreHHf0QH3Q1WPrwfwAEE3vkITNyA41A8MUQaKALZ19FxzqaOtzm5O9JiiiETyqkNP3DDN7MxG8A3eMZnkMJF7fsP6D+EAVMpeDmsd9FUlZvQBFGonL80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap7j9SOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap7j9SOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFA0C4CECE;
	Thu, 12 Dec 2024 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023093;
	bh=4BtvbyAN57JlXyUSI8hkqmHvTam0+vrlfF7KsQJg9zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap7j9SOziumkXuvi81dFtuSIC9/7L71em/XuZqJM4AXKcRM7IO1fUK6gRSO3mm916
	 nrpKMF5o3tQx0emp0sKi7bPxLg3QCR6RaLzsvQCWdRm9Nn/tBWo1tgqyg+8V/w0OCD
	 ZDhckyMQ4RtEjzCH4+/DyCzZ4gtJ+TVqvq926A7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 382/565] ad7780: fix division by zero in ad7780_write_raw()
Date: Thu, 12 Dec 2024 15:59:37 +0100
Message-ID: <20241212144326.736653131@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

commit c174b53e95adf2eece2afc56cd9798374919f99a upstream.

In the ad7780_write_raw() , val2 can be zero, which might lead to a
division by zero error in DIV_ROUND_CLOSEST(). The ad7780_write_raw()
is based on iio_info's write_raw. While val is explicitly declared that
can be zero (in read mode), val2 is not specified to be non-zero.

Fixes: 9085daa4abcc ("staging: iio: ad7780: add gain & filter gpio support")
Cc: stable@vger.kernel.org
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241028142027.1032332-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -152,7 +152,7 @@ static int ad7780_write_raw(struct iio_d
 
 	switch (m) {
 	case IIO_CHAN_INFO_SCALE:
-		if (val != 0)
+		if (val != 0 || val2 == 0)
 			return -EINVAL;
 
 		vref = st->int_vref_mv * 1000000LL;


