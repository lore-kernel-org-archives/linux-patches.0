Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1755518C039;
	Tue, 10 Sep 2024 10:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962702; cv=none; b=BLTAV7CXSifJ7IZjZNNciQHxRw0GZ7KtD/cH/OR5wCPS0dF/AA0DaHfhaDF5jD/PawdwMR9MF0yYV2beLrH+jCIkpzPhtyqx51sHNvJP4VQDITEmXzW9WCitPl0bSdoBOfTGOqIMHSJ591wuqnxyaCK2JBoHB05dNtNcJk/smBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962702; c=relaxed/simple;
	bh=ARpILm6jpiaJ6m6IF/u0sCt7CRZB2XLEfeHs2dHPzPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlVhadJqivdaKUrFHYqGKYvSwcPChJ1KSnpkUsm8vVnW8YDp2Q5QLtmgtmi+/nt91jWWNOENB16DNK/kG7ojbjL1JCOrYhjIy8Ebb8CB2/bnXmmShu/7yTVmvyr8m2QtuBJ32bi8OSxVrArmPGSdm14ygJsdaY9Fmec9v+4z+mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBlwR0Bv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBlwR0Bv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936F7C4CEC3;
	Tue, 10 Sep 2024 10:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962702;
	bh=ARpILm6jpiaJ6m6IF/u0sCt7CRZB2XLEfeHs2dHPzPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBlwR0BvVmXYWMxKhcR5HBn5xo6vD5FI/o7Lby9Kw4djj7svBumbo3XvjR6EQOgfM
	 BQEK1Bo7jJb/gynRO7vPmAxgTyeIGo6JcGLFkPbLf/G+zaPuEVa1oy/6Sq4454JeAY
	 6Ekdx+S9D3+GySiMTnIv6HmF3OWf53yqO4ovon04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 095/121] staging: iio: frequency: ad9834: Validate frequency parameter value
Date: Tue, 10 Sep 2024 11:32:50 +0200
Message-ID: <20240910092550.349938266@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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
@@ -115,7 +115,7 @@ static int ad9834_write_frequency(struct
 
 	clk_freq = clk_get_rate(st->mclk);
 
-	if (fout > (clk_freq / 2))
+	if (!clk_freq || fout > (clk_freq / 2))
 		return -EINVAL;
 
 	regval = ad9834_calc_freqreg(clk_freq, fout);


