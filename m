Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A525C424651;
	Thu, 16 Jul 2026 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210480; cv=none; b=NMWp4LawDoE8HIWI1wHZbI/+2swDNsEnI/AGyMcS/LRdUpd9BLkjiNbwGetrDu9OfTSfkV6LamCpy/ABACjpjg3hDRJKoEJTD+hNjJpnx+uju+by2dCFCacdKbkGog/UCboU2ekkkG6NY0HNPPUN19qVW0vjz+1lUULFbYlqG/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210480; c=relaxed/simple;
	bh=CKmioRvn8cBwz02KYsZ8Y9Fue+HBs7zMIfT3rAVh4CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyuRegqT++6AvYkZIchlHnlpwyjQNSCHy2gTk0NJd7ThG+TvIj5h1QY27ELXkRDdiMUVmyFZ6NPguV7rdV2x7ujFJ658zbhuMK5puaeOIr8r5YfuyUQ3lW616d8l4bjsjZ8LWqfKon/piivK2x/PHVI+lZTF5EOzmGajrlhlVO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOcTPIKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOcTPIKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66D11F000E9;
	Thu, 16 Jul 2026 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210479;
	bh=UGJeYfLbkvRhwuA8htLFwmL6yEY1+QUBVzbXkkXcb4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOcTPIKXrhS+iBWWBuYAHVaqMCqgP+1Jco0Drzv8v2BxrIXKcAieDaXfSx28fBC4B
	 62PdDBOHSn+xJTT0+n9K2FB4Ixu1WGjKdBvtW89uzOYH/9VYpREisOGtT55N3qDez0
	 cxUvN9Bl1fYfhF3gohOnxAWNUjdDhrT9FT/GWzY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 063/480] iio: dac: ad3552r-hs: fix uninitialized data ni ad3552r_hs_write_data_source()
Date: Thu, 16 Jul 2026 15:26:50 +0200
Message-ID: <20260716133046.073602364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

commit eaaa7eef181892ef7ba56c6295b81f0ae4492c13 upstream.

If the *ppos value is non-zero then the simple_write_to_buffer() function
won't initialized the start of the buf[] buffer.  Non-zero values for
*ppos won't work here generally, so just test for them and return -ENOSPC
at the start of the function.

Fixes: b1c5d68ea66e ("iio: dac: ad3552r-hs: add support for internal ramp")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Angelo Dureghello <adureghello@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3552r-hs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad3552r-hs.c
+++ b/drivers/iio/dac/ad3552r-hs.c
@@ -549,7 +549,7 @@ static ssize_t ad3552r_hs_write_data_sou
 
 	guard(mutex)(&st->lock);
 
-	if (count >= sizeof(buf))
+	if (*ppos != 0 || count >= sizeof(buf))
 		return -ENOSPC;
 
 	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, userbuf,


