Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECE41DF24C;
	Wed,  6 Nov 2024 12:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894819; cv=none; b=SaSBRBbrJAF23pM+OT6uAP3jJRJEPgGb21Q+L5vUzJW9sMPlwYHt1l5UFxuSovYgt9+Y/6jUmYTRVAYosoLyvatq4cVUTlaaZ9A1dmZnI0HlIEvfQTxkUch9fSrZrEzJJMeFWcU5bcDuc9lWd/cYxdIXDeKlETN6cSKizrZhxb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894819; c=relaxed/simple;
	bh=rmjTWp5nKqx4/qbbum5o3KE3M/YC87u9xLEHvhMJSSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro+6C0nhQcq3a4uoKvqQwTAY9zBgpSklYAXGbjmiBcHELosoL7RuQ2mPl51R3ik/Km4YQX3I9o12mJS0/RbWcPtPCreGDziuhnim9+hxFKPkG9Nvz60IwGDLwgIQqckdXf/SoxyzVSrPcNqxB5zkEpfo/pnv8v9ZHIjCKIP/gUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=su65ojQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="su65ojQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F96EC4CECD;
	Wed,  6 Nov 2024 12:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894818;
	bh=rmjTWp5nKqx4/qbbum5o3KE3M/YC87u9xLEHvhMJSSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=su65ojQFABFl5wTmZQHH4CfVb0k2w+mxALO/mwHTRiDqYXZSi6hy/itgQ0EsMfMKS
	 IT2HrM777u//znjTtKlSIe/FtDLdCJCM9aBaBNRaU+esIEtMrFZFXq3yHoujEaRndX
	 pmIPRvbbQDCZ0eyEbfL+W0uzKD/GNTYCG3b/JUwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Aleksandr Mishin <amishin@t-argos.ru>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 003/350] staging: iio: frequency: ad9834: Validate frequency parameter value
Date: Wed,  6 Nov 2024 12:58:51 +0100
Message-ID: <20241106120320.952383016@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandr Mishin <amishin@t-argos.ru>

[ Upstream commit b48aa991758999d4e8f9296c5bbe388f293ef465 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/frequency/ad9834.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/frequency/ad9834.c b/drivers/staging/iio/frequency/ad9834.c
index 5e98ee5dfbdc..3eb089dc220e 100644
--- a/drivers/staging/iio/frequency/ad9834.c
+++ b/drivers/staging/iio/frequency/ad9834.c
@@ -116,7 +116,7 @@ static int ad9834_write_frequency(struct ad9834_state *st,
 
 	clk_freq = clk_get_rate(st->mclk);
 
-	if (fout > (clk_freq / 2))
+	if (!clk_freq || fout > (clk_freq / 2))
 		return -EINVAL;
 
 	regval = ad9834_calc_freqreg(clk_freq, fout);
-- 
2.43.0



