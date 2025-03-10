Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B52230BF8;
	Mon, 10 Mar 2025 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627023; cv=none; b=Hl13sXaMSY454LdHW+zA7EFJlaqQqAWtzf7Dgt3eXrzv6MlwbEVqK0NCU4pNgXrb7+vf0SV7wHNZF3KTNyvHWTxfvJweYEy72LqrtHsE79eS5Ekz4fYXi4e3/KE8msZuwLskVvjP0ute1tzGOq2oRBe4h/wlQjadTyQD8tVwrsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627023; c=relaxed/simple;
	bh=clEaxjjKiQTOUbsrGnDYmxva+qS6/pY0Tvg4tQJ+afs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ps/CalJB5926YqaBWhPI6UlGMc4IYcwwrAdJ5ctiYkUdXIi92R1hvfJf7KQEptYdIRyMZkW/Tb/c2RDqlBjJ3Pp/ydK3u6orGEJLbUnv30fFW7BNysHjAmmLGqtUh6ftXabAOQfqi8Pjaps2+zJVGL4bWvzXRRQW4uXPmQpgqeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqF+E4RR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqF+E4RR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FC9C4CEE5;
	Mon, 10 Mar 2025 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627023;
	bh=clEaxjjKiQTOUbsrGnDYmxva+qS6/pY0Tvg4tQJ+afs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqF+E4RR+j7sbtWV8IviYjl4CXi5i0gzVBjHo6d0jljqEGnqOJ9bhbNjBuVCfpy2/
	 hRe6038n/jJBXYQjZQuLTYb4ULz4JtJ1DMpQsDUKz2nxM2w/SvrjFXqPsnwhNPrOwu
	 zhKdVAuzIWUQS8hnAlE86NPmlTiYfPFPxB0h2LT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.13 194/207] iio: dac: ad3552r: clear reset status flag
Date: Mon, 10 Mar 2025 18:06:27 +0100
Message-ID: <20250310170455.493801936@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -410,6 +410,12 @@ static int ad3552r_reset(struct ad3552r_
 		return ret;
 	}
 
+	/* Clear reset error flag, see ad3552r manual, rev B table 38. */
+	ret = ad3552r_write_reg(dac, AD3552R_REG_ADDR_ERR_STATUS,
+				AD3552R_MASK_RESET_STATUS);
+	if (ret)
+		return ret;
+
 	return ad3552r_update_reg_field(dac,
 					AD3552R_REG_ADDR_INTERFACE_CONFIG_A,
 					AD3552R_MASK_ADDR_ASCENSION,


