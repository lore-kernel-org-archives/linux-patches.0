Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB0963D;
	Tue,  2 Jul 2024 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941478; cv=none; b=QCBwTdGViotD0TAgkkFnptIMEeWROaA1/VrlXjSqxdDVTITVYh0xcYiEZE3MyjXJ6BNyqnxs6+JNj1M6Eixibn8DX6erme2lah+ymyTHLi75BydZjOyKZ87osPZgRE9syeJWRAEsjMga8feIf+KNEMdTg97+3u2vZMql/4LJQ7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941478; c=relaxed/simple;
	bh=Gxi7X7IeySkAxg1vGYkeDRJTVRdMX+HBUcXOg6JGM/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J21hsqnaoztK65EV6emC4PuAlGJAOp/zRiMy2Lg4TsHlr3AMLSX2QCZFso7LOVxnv61sdzIBvawOxiJ4nA1nUBL38bcPzXk6WlMqA66CRb3HVG7liAN4XaQgJjTXEksvYYTUKvnXQ7OVFNygalEmnaSWyYsaNKlz+Et15vtLyKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbyAqQuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbyAqQuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72929C116B1;
	Tue,  2 Jul 2024 17:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941477;
	bh=Gxi7X7IeySkAxg1vGYkeDRJTVRdMX+HBUcXOg6JGM/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbyAqQuF9Wg5gJRG6XDtOVqswa4Ydnj3pUIrkmN/3ps5IG29IF6tg/PR4NtxLBgRz
	 bP+1Bw/7AFB+dN/elQAd5zAPO5JaMBzmgtSt2VTpmhpmxFMGsKPgvULLzE+bYFyGT6
	 ZEdDksxUcKHCp+aM9j5mW8+fmUH25W2H499dj+0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Yang <hagisf@usp.br>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 076/128] iio: adc: ad7266: Fix variable checking bug
Date: Tue,  2 Jul 2024 19:04:37 +0200
Message-ID: <20240702170229.104838530@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

From: Fernando Yang <hagisf@usp.br>

commit a2b86132955268b2a1703082fbc2d4832fc001b8 upstream.

The ret variable was not checked after iio_device_release_direct_mode(),
which could possibly cause errors

Fixes: c70df20e3159 ("iio: adc: ad7266: claim direct mode during sensor read")
Signed-off-by: Fernando Yang <hagisf@usp.br>
Link: https://lore.kernel.org/r/20240603180757.8560-1-hagisf@usp.br
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7266.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/ad7266.c
+++ b/drivers/iio/adc/ad7266.c
@@ -157,6 +157,8 @@ static int ad7266_read_raw(struct iio_de
 		ret = ad7266_read_single(st, val, chan->address);
 		iio_device_release_direct_mode(indio_dev);
 
+		if (ret < 0)
+			return ret;
 		*val = (*val >> 2) & 0xfff;
 		if (chan->scan_type.sign == 's')
 			*val = sign_extend32(*val,


