Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586C31BE242;
	Tue,  2 Jul 2024 17:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941001; cv=none; b=bBfIVJsIvH43xebU62nrbct+1fn/y9x8acufCMbgxad1tk3esThTqWNBWhGImP1t6JPGoQG9rSD81dnUr45k+PynnFRrk6dS3CpCSHRP+rRtj48gPV2jZ1ldByVFOxqXtE0knBW4E64hYCmv2Cmt29tiagb2gc18NYuOjhi0PDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941001; c=relaxed/simple;
	bh=7mpMWUbkl1ybZiNmk2NUW2IHbLs0IhIUJTic4p9X5R0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwTfP1EEzzaEJquSVcC48i8Odte8MbG/h0mSxDVU6/t+J4sT8h0epqGCQLI7EvjTHF8ycWQ0vJsbhF1L3xshXSIyPkb2kcd0vllWwCuCsuCfRhKheF+/srUJBErKuZlgLZetIzMGy04/XgNuWf9yENOf+PRI9w1zed6M3omshg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQQTF+iP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQQTF+iP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECF9C116B1;
	Tue,  2 Jul 2024 17:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941001;
	bh=7mpMWUbkl1ybZiNmk2NUW2IHbLs0IhIUJTic4p9X5R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQQTF+iPgyVxKGmYQbJloGrLbkKhJwT8GRdwMFjBWlN0gCzZaCT0/b7odktcALlni
	 /kVeiVnzmOFs5lnF5RRL1riX+0s+JUq3cOswH4EX+kskQTuqgQgIZUvWZ0DGYtw7jU
	 U1Ls0NRzDq74QIm8o47/wjKe6XwJg3u5H3aBVulU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Yang <hagisf@usp.br>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 098/163] iio: adc: ad7266: Fix variable checking bug
Date: Tue,  2 Jul 2024 19:03:32 +0200
Message-ID: <20240702170236.772583271@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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


