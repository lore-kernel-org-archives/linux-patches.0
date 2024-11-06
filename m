Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 504E11E0B73;
	Wed,  6 Nov 2024 12:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897239; cv=none; b=tL4XVVgEivPJki7gf+Kujirnt06Cq5EAbITasaKK1vNL63PKb8qKbsLgMMUzLuJmzA/19TsTb9C4cqj4JjjhhfY6WbctfmAJvjadJT7BBNmJQQOirooyGoIwkcgDvZQbNo52YSdtAXjLNTHDoyV4tHtGDJ54ge4mnLVKBL8OHac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897239; c=relaxed/simple;
	bh=jhwUGLlzEGl0zii9mfaHyUR8B2evpPNikr8Omcj7+/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q27lAsaEePtvDo6EcxvvlMtHzMD3WYzGPIptmaev6wizOSIfnwVIO517kMY40X4eZfy5AeOcQVT4hefaYExUGMntvIjFGKz0AbgNUEKhBgc/9KMY+WdBM9W1r2xGIpjaKfJMLD/tcWfMeu6jhxEuhQOtjmUix18j07uvhhnTTu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/tzk7QI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/tzk7QI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73963C4CECD;
	Wed,  6 Nov 2024 12:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897238;
	bh=jhwUGLlzEGl0zii9mfaHyUR8B2evpPNikr8Omcj7+/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n/tzk7QI9qeZd+Ddq3tKSRrCxSasMv7mymgBQp20/9MGDV+Lm3i+HRs7wUk5DaWDf
	 JxfTtBUvBUiyrO09N0g2/cgNYBnA/ytqmIRUAT54mmVHXzlUZQHDx2DcoJ+Sn2rQUH
	 zM+EjLf1j7cFJewCJXLeZFe0ca5MTb8JdWWaIMao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 076/126] staging: iio: frequency: ad9832: fix division by zero in ad9832_calc_freqreg()
Date: Wed,  6 Nov 2024 13:04:37 +0100
Message-ID: <20241106120308.141115779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Zicheng Qu <quzicheng@huawei.com>

commit 6bd301819f8f69331a55ae2336c8b111fc933f3d upstream.

In the ad9832_write_frequency() function, clk_get_rate() might return 0.
This can lead to a division by zero when calling ad9832_calc_freqreg().
The check if (fout > (clk_get_rate(st->mclk) / 2)) does not protect
against the case when fout is 0. The ad9832_write_frequency() function
is called from ad9832_write(), and fout is derived from a text buffer,
which can contain any value.

Link: https://lore.kernel.org/all/2024100904-CVE-2024-47663-9bdc@gregkh/
Fixes: ea707584bac1 ("Staging: IIO: DDS: AD9832 / AD9835 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/20241022134354.574614-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/frequency/ad9832.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/staging/iio/frequency/ad9832.c
+++ b/drivers/staging/iio/frequency/ad9832.c
@@ -129,12 +129,15 @@ static unsigned long ad9832_calc_freqreg
 static int ad9832_write_frequency(struct ad9832_state *st,
 				  unsigned int addr, unsigned long fout)
 {
+	unsigned long clk_freq;
 	unsigned long regval;
 
-	if (fout > (clk_get_rate(st->mclk) / 2))
+	clk_freq = clk_get_rate(st->mclk);
+
+	if (!clk_freq || fout > (clk_freq / 2))
 		return -EINVAL;
 
-	regval = ad9832_calc_freqreg(clk_get_rate(st->mclk), fout);
+	regval = ad9832_calc_freqreg(clk_freq, fout);
 
 	st->freq_data[0] = cpu_to_be16((AD9832_CMD_FRE8BITSW << CMD_SHIFT) |
 					(addr << ADD_SHIFT) |


