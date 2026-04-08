Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A3D3176E4;
	Wed,  8 Apr 2026 18:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674762; cv=none; b=GsL0zZLbmD+whXalJ604w6pBpbVIwSkMjSogB1h3rjJ6xgJoPTuzito7yeIqWJt26vIymr4cobCi6zL7DBImLviRxbgYJPlZf7TOvLxX+VON57g05JNULJEkMFXi4XhtM057PO1reL9srXfc/tgWAGFBYs2WtRiItFJ016gQkgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674762; c=relaxed/simple;
	bh=ApfZgSqTvTX1t5hVdO2p05jT2lLLw5zv1Aqe1g4U9Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyL4a5lpqqsi2doJE0CEALifG6SH6v0mzyQvRr5bQJaTmMv/8rg8stPBQ33F/xF+RRUbYSn5Wo5Ozz6QUGVnPc8uN5BUrhMptRlyf4CEdFneFTB0tnKBs/GjkvIUh0ZgDmXUeV2BA2X+2YdG1vNisvhAzsHux1EpbexcHU7wSyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VAAe9Hde; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VAAe9Hde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2991AC19421;
	Wed,  8 Apr 2026 18:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674762;
	bh=ApfZgSqTvTX1t5hVdO2p05jT2lLLw5zv1Aqe1g4U9Yw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VAAe9Hde7EstMl7LO5CrIY4Y/gRltHRsn4yLBY7dgoAJWhn8DjebTyPJBfHlgynEi
	 BDq0HCf3J0KM5qaCyOTdInj8pryzVGPatcAyInr+7ZWVEZQfiTIbQTqnZV+mxwFBXm
	 XJeS45BEFm3ZsfwlrcZuVGq3rgId1OOqthZoAdOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 224/311] iio: dac: ad5770r: fix error return in ad5770r_read_raw()
Date: Wed,  8 Apr 2026 20:03:44 +0200
Message-ID: <20260408175947.765602388@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit c354521708175d776d896f8bdae44b18711eccb6 upstream.

Return the error code from regmap_bulk_read() instead of 0 so
that I/O failures are properly propagated.

Fixes: cbbb819837f6 ("iio: dac: ad5770r: Add AD5770R support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad5770r.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/dac/ad5770r.c
+++ b/drivers/iio/dac/ad5770r.c
@@ -322,7 +322,7 @@ static int ad5770r_read_raw(struct iio_d
 				       chan->address,
 				       st->transf_buf, 2);
 		if (ret)
-			return 0;
+			return ret;
 
 		buf16 = get_unaligned_le16(st->transf_buf);
 		*val = buf16 >> 2;


