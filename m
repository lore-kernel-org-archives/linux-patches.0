Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB731A680D;
	Mon, 23 Mar 2026 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275742; cv=none; b=Bx+pR+unz4fFLkbArc/NJqGhYsWV0GzaNsAhW0/K4Rx3BAsRws88ZIO2CvU+tsIpkzTDyQloQHoTkwtIPBwWHMvwN2GdAzkC6gFiowjz2oLJIsuqd1D6kBIukaCT8D1CV5g3zYJNecmyNr1IlQlB8xH5X672OIW4tfCUsAj+ghQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275742; c=relaxed/simple;
	bh=rP8XTaU2NguznEzAKfxe3wIxEUiTLFLOZ9j9NtyXpa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTz3APFg1E8CkR+oMI8gKMVWOBIiGKY8/zyQVeqVDv7yfYmUmxgFUnFH3xMTXWBBnm47b8pR/g47xTWaQnS+mfatvShRt9RnBnkxYqFsdv2/7v/A7hc2mSiAzk5ekuS9aFXnDk6ZKhU7Y5g02CpDXV0XA7/JlgYRHaoDY2vDCJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0h9rUwpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0h9rUwpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1029DC4CEF7;
	Mon, 23 Mar 2026 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275742;
	bh=rP8XTaU2NguznEzAKfxe3wIxEUiTLFLOZ9j9NtyXpa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0h9rUwpm6p5ld8jrFPkAUkMkZEMgp27ln8Lm+ZDsf1cXK1spgD6q0NNTO81D/WdvM
	 dp6fwyeRmkWr899n2+ZOU3r1WugINaVOp45J18nyT2exyaTIYlVKAckQ9G5nzL0cT+
	 xBaGMKICMjwjbfMgvkCYWmIxlbYQ3Y9YLzfUGpNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 204/460] iio: frequency: adf4377: Fix duplicated soft reset mask
Date: Mon, 23 Mar 2026 14:43:20 +0100
Message-ID: <20260323134531.545019162@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeungJu Cheon <suunj1331@gmail.com>

commit 6c8bf4b604a8a6346ca71f1c027fa01c2c2e04cb upstream.

The regmap_read_poll_timeout() uses ADF4377_0000_SOFT_RESET_R_MSK
twice instead of checking both SOFT_RESET_MSK (bit 0) and
SOFT_RESET_R_MSK (bit 7). This causes an incomplete reset status check.

The code first sets both SOFT_RESET and SOFT_RESET_R bits to 1 via
regmap_update_bits(), then polls for them to be cleared. Since we set
both bits before polling, we should be waiting for both to clear.

Fix by using both masks as done in regmap_update_bits() above.

Fixes: eda549e2e524 ("iio: frequency: adf4377: add support for ADF4377")
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Cc: Stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/frequency/adf4377.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/frequency/adf4377.c
+++ b/drivers/iio/frequency/adf4377.c
@@ -501,7 +501,7 @@ static int adf4377_soft_reset(struct adf
 		return ret;
 
 	return regmap_read_poll_timeout(st->regmap, 0x0, read_val,
-					!(read_val & (ADF4377_0000_SOFT_RESET_R_MSK |
+					!(read_val & (ADF4377_0000_SOFT_RESET_MSK |
 					ADF4377_0000_SOFT_RESET_R_MSK)), 200, 200 * 100);
 }
 


