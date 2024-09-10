Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC023190072;
	Tue, 10 Sep 2024 10:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964615; cv=none; b=qGGhZYst6kilXfGwBo8Ks1j0mwFArrLjja4eFz7F/aBOnQa6DNgQkl54oepNqQFjjN1LL1N9Rl79DFrTFxuz2EnG1UoEywHRlpttzaPlvINecrTtdea0fn3eEiaAtBgE52sNnaZEZ3XF+uuguwiL79rR6dhcads2PMBJHNYumIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964615; c=relaxed/simple;
	bh=x4hu3FWnrFDJSFLfYLJ5AF3+KAnfePZDTv7+vtsC5nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lfck+wxh7clMztGBuyUvc+/MXWZ7OCWVj96zyWRnBoHOgIa1N2rZBFPWd50j1mtNM8UMyccirFBNFfEDQNmLToydrFALaeYpOYxYXtto7cCabWU6OV9BJ0UOxWH2Nn3y5+iC/lS+tmYpTxfnoeEsn4xzpPRMuphOTJHY0Jgod/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6myK+4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6myK+4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15E9C4CEC6;
	Tue, 10 Sep 2024 10:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964615;
	bh=x4hu3FWnrFDJSFLfYLJ5AF3+KAnfePZDTv7+vtsC5nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T6myK+4urpccgdI29P09XviRTzjZrmYOUn+xMZfB8Vzs5/gHLLfa4a4u4nqahZzTR
	 xG4cOtkThgd4imFlplXVG2K8xDbbJU62WeJe95nEvuelXBqKWrxXq6LCDzkPcoS4xE
	 H5byEZTLHnv/h+8JkuxHD6H4WX3xd5urUH4TeRIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 205/269] staging: iio: frequency: ad9834: Validate frequency parameter value
Date: Tue, 10 Sep 2024 11:33:12 +0200
Message-ID: <20240910092615.366668309@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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


