Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92039188A38;
	Tue, 10 Sep 2024 10:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963831; cv=none; b=oKENd8eHvfodiN5zO7BdM13lWQQRaY1uM2gFyeC+c3lyFF3srpKFFqraEFEiUFiPAa49zQ0slLhAyCEU7eDUYrfvRSRtHmA8aTHSC8wApqvyRAM1lu6XaeK47GdUag1WB4KscQvPPB22ub65FP+XEjvK7X4lUebcDAYzvI+Ge/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963831; c=relaxed/simple;
	bh=aNCFUXENEqIqOPN5dR/fUw8b+Y8s6GavrD2XKOE+gDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNXAxVaZn1nBHsAsCcIo8zbeFbj2poSgYShh0b0+cY1Yjpc/pKrL5PrAPz3zwM5Gz4M5/wN/iy746qwzHDxX+Ps9jayY1TU9U6JWsSo1VDYVVoiH/gbv0i5+hrNfVz4dchnvA8h8cBgNfDrjA3xcOikXEwf3QPUVniX3wVoYh8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dSNFvTaq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dSNFvTaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186F2C4CEC3;
	Tue, 10 Sep 2024 10:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963831;
	bh=aNCFUXENEqIqOPN5dR/fUw8b+Y8s6GavrD2XKOE+gDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSNFvTaqS2kqS+QssBfP9nUBgjMWjsReYa5Qc+vJlPCVRAk7+H2M4ogKpecGJtdgH
	 TmZ9FqtfI7cGLQ4MMuCddNknjUhKi1ChwatfxgNndtNQfk8oEHMJt43lqGoJRRQDYR
	 gncHlUy7XjppjgcWj58fhW1QoRpvgGLjDSfuaFds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 174/214] staging: iio: frequency: ad9834: Validate frequency parameter value
Date: Tue, 10 Sep 2024 11:33:16 +0200
Message-ID: <20240910092605.819857219@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Aleksandr Mishin <amishin@t-argos.ru>

commit b48aa991758999d4e8f9296c5bbe388f293ef465 upstream.

In ad9834_write_frequency() clk_get_rate() can return 0. In such case
ad9834_calc_freqreg() call will lead to division by zero. Checking
'if (fout > (clk_freq / 2))' doesn't protect in case of 'fout' is 0.
ad9834_write_frequency() is called from ad9834_write(), where fout is
taken from text buffer, which can contain any value.

Modify parameters checking.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 12b9d5bf76bf ("Staging: IIO: DDS: AD9833 / AD9834 driver")
Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Aleksandr Mishin <amishin@t-argos.ru>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20240703154506.25584-1-amishin@t-argos.ru
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/frequency/ad9834.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/iio/frequency/ad9834.c
+++ b/drivers/staging/iio/frequency/ad9834.c
@@ -114,7 +114,7 @@ static int ad9834_write_frequency(struct
 
 	clk_freq = clk_get_rate(st->mclk);
 
-	if (fout > (clk_freq / 2))
+	if (!clk_freq || fout > (clk_freq / 2))
 		return -EINVAL;
 
 	regval = ad9834_calc_freqreg(clk_freq, fout);


