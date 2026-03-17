Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8D421D5B0;
	Tue, 17 Mar 2026 17:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768365; cv=none; b=QNSBpUQu5aiNbzbAqRiniqEC8Dqm/XZmmL2ToXT6ll9R1u5Z+8KJDSpGVxTLrqU0Qc2c2cdhJX83Uy5C5muII2Vw2Bghi/3QfA5UVhfsBHvP+ZCnPWRVLXcBTs0f21VLSdWU7UUiN/l9HkBmkF032nSVjIhmvjy8MjffnZGi3Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768365; c=relaxed/simple;
	bh=XfQx2wF26AqXKjygCv1omWv3Hg/LMpkp2POyFwzVYnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFeBtItcM7nMexZ5/yHTxt0L05ij3I6QP3z8AYj+AAa3KDLf1W54XumjAAouKDxvNkwaqp0vrFC6ZV76lYlMuuU93/DB/ByTtaeWloJrPFCaaJTFDUu1vBTjyXml7WKcD1WwYw5n/5RnnSQEZ/KohM9curzkt5Ek3fpLRTPCbIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTrXU3I/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTrXU3I/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3E9C4CEF7;
	Tue, 17 Mar 2026 17:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768364;
	bh=XfQx2wF26AqXKjygCv1omWv3Hg/LMpkp2POyFwzVYnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTrXU3I/QuaHmZDtHrM1rMJKRxvX0gP7EDr0Mg5FW+FecYfGibLSyUVDYtvpBNE8d
	 izD9zmR2y2TRGiGXNvaITa/KcMBqaDShvWZbhhLKQuiQr+RBFcilXkJ+HM1RmgydgR
	 57A73lQ1auRW6tcc8lzBXwvhjBqkZJRTiML+lQI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 293/333] iio: frequency: adf4377: Fix duplicated soft reset mask
Date: Tue, 17 Mar 2026 17:35:22 +0100
Message-ID: <20260317163010.259643697@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


