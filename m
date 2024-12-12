Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62D7222D74;
	Thu, 12 Dec 2024 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025654; cv=none; b=bY4U9/Zf/7bVq8oa1TclEWHRrdsPWFGvh8ht+l9YBIzJFrTOGpIi/gFlmuy2dIJbNYumbyvBHbLl1OXJRFD+Jw3u4GM98FVD3ODjGwkJpv95cChlaFXjRFxLkBBKxaGlT22/YdG6qWo2ln2KICueHpnUXY3I4o4Ja1k5qwCFMi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025654; c=relaxed/simple;
	bh=2zhtGnvwF1/caSpdlQMMocZJEZ9ZiyhFfO0P1vqYMyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPHQIeZ9BrwU7WVGtBT2EvMZpObWBxXUyiF+Ycy77L/VDL1Y/eelw6bCtuEqY1/W4uFAYjMbV9TEFnLzVrN8J/5ANkjFudkPqn895BMX6lyI5oecZNlDrdBsXwewrM6APKPQaYisn8KmjUArDin5WyV2slYml+4rxZm1UND+xUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0X2Zzma+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0X2Zzma+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51AEEC4CECE;
	Thu, 12 Dec 2024 17:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025654;
	bh=2zhtGnvwF1/caSpdlQMMocZJEZ9ZiyhFfO0P1vqYMyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0X2Zzma+snuVn1lHDhBmIIGu93jsaitLJ7QHeQd0pE2EHjNto91q2rMgcZJtHyoSE
	 i7RgvifcQQp5DkIvwlXoCtFmjHa6d36VtIVV8ZSScjqAq+ZjmaMNDw+LOKe1XyVQgL
	 JlFwbwds2I74ACZXwPbuI99dHs6ceAUYcrn0qCFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 212/321] ad7780: fix division by zero in ad7780_write_raw()
Date: Thu, 12 Dec 2024 16:02:10 +0100
Message-ID: <20241212144238.354705220@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


