Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFAE51DE89C;
	Mon, 10 Mar 2025 17:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628595; cv=none; b=bdqCt7jaheQWEIzbhaquRTrfIktwmleiivAMHfrSjhL89dmJQzN1638yFKV3qrJDfQgqNvaxCgHkseJYujsAcZnd4vW8MplOodwuswv5jsjbpMSZV06Q32UeiQ4dl+LfkfQKsYYYZC6Gz70Jk1JkJpa5GZIFEVp7EElAJxX+rSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628595; c=relaxed/simple;
	bh=kMPrw9clAIdvgg+edJjpI8euTXmoiwkjYfZQwArK2iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oz4gk6VPF3CAtS+8njyYt17UwJo9Erc95Q/eMLBqfd61mz+8r0G5iIAhanhe0lk/2sm6H2099yC3utt9k4tKaJGbb6jG7bq1ES2YZygmawCjQH8V6VRbc1YmE6X2W3ep8bn9UnpypNwLLN8SLvWO2lHAtaDyvx/Yy9iu00F+ars=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfXS604T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfXS604T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB28C4CEE5;
	Mon, 10 Mar 2025 17:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628595;
	bh=kMPrw9clAIdvgg+edJjpI8euTXmoiwkjYfZQwArK2iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfXS604TuTE7OcDr5zC4e+z5EblsDZwFj9ySXIUibPF+P3lUwOJ2lgoRHVZcnDU+X
	 mcqeOGck9JRg+ZZEFv9zles8zkUZoPonX5JADanM2mrrYK5Fj6l+mqImZqg63w16CE
	 ZPUZqszR5rfSE58a85WEfwRj9Qc4jm/Et+4WHuLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 090/109] iio: dac: ad3552r: clear reset status flag
Date: Mon, 10 Mar 2025 18:07:14 +0100
Message-ID: <20250310170431.144732184@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Angelo Dureghello <adureghello@baylibre.com>

commit e17b9f20da7d2bc1f48878ab2230523b2512d965 upstream.

Clear reset status flag, to keep error status register clean after reset
(ad3552r manual, rev B table 38).

Reset error flag was left to 1, so debugging registers, the "Error
Status Register" was dirty (0x01). It is important to clear this bit, so
if there is any reset event over normal working mode, it is possible to
detect it.

Fixes: 8f2b54824b28 ("drivers:iio:dac: Add AD3552R driver support")
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250125-wip-bl-ad3552r-clear-reset-v2-1-aa3a27f3ff8c@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/ad3552r.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iio/dac/ad3552r.c
+++ b/drivers/iio/dac/ad3552r.c
@@ -703,6 +703,12 @@ static int ad3552r_reset(struct ad3552r_
 		return ret;
 	}
 
+	/* Clear reset error flag, see ad3552r manual, rev B table 38. */
+	ret = ad3552r_write_reg(dac, AD3552R_REG_ADDR_ERR_STATUS,
+				AD3552R_MASK_RESET_STATUS);
+	if (ret)
+		return ret;
+
 	return ad3552r_update_reg_field(dac,
 					addr_mask_map[AD3552R_ADDR_ASCENSION][0],
 					addr_mask_map[AD3552R_ADDR_ASCENSION][1],


