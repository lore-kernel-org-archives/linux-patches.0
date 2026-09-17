Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294EC49E5DD;
	Thu, 17 Sep 2026 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668551; cv=none; b=d7n78XLqZ7jnqMbQ81XWvkv40/QYvePQD+GqcS7vxudb3RNaPhXn1Ilp94zRXKmBKBJkxb0CuAi4uzApVr3Mg+mNVu0CW9EmLIUG0RJb2vhRlafEf69J0nctMgUgaXnEC/NbZz1RCpEHDUdCiUflwr/pK8HeFnXNVoyL2mhRZ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668551; c=relaxed/simple;
	bh=H3w5m3747wtzKnnayDfiMv3mzbqHHZHrR5vPWGFnNvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9GGQ/EqjIvow2meX5YsXohJBT5NsxYBLKLLV3A05C+uNWtgEhKupmhcTUJVwNxk3Jg25wC+kynNI3pieXQsIZ+JRBZR9TXORer0kKYgb/9Re/0sesSgv6YTOdcIegOoCorqk6XnzMnqLGq3336AA59qApiN4+aAEfQDyrNuvFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmkDUiNR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmkDUiNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2407C1F000FF;
	Thu, 17 Sep 2026 18:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668549;
	bh=SQ8wW7HbZ7FR7bYndDDivZOsz4hsx2wv0cty+jwMw3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmkDUiNRaRulNj0UGldw2iFfDhC1nFC70rG1KACp5jpqptfO/UHzNS7yl98v+/byd
	 CaZuZd8HoIGBKGPCqTuqbTrlNb8kFTD1W3wTDMY/Hem1FXjMPp7tQKVH3r/q+LuGYL
	 pp1LjObt0TMpcQJGryyEkl3QzlBYlkbeoUJMTDvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0459/1102] spi: dw: fix wrong RX_SAMPLE_DLY setting after resume
Date: Thu, 17 Sep 2026 16:06:42 +0100
Message-ID: <20260917151551.210707527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 133c71b2c0bc976a4751f9e05ef7cdea67f964e5 ]

On platforms which need a non-zero rx sample delay, the RX_SAMPLE_DLY
reg setting is lost after resume. The reason is that the reg may be
reset to 0 after resuming, but dws->cur_rx_sample_dly doesn't know
this fact. Fix this issue by clearing dws->cur_rx_sample_dly in
dw_spi_shutdown_chip().

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Suggested-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260803135925.12622-1-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 8a3c085c85e07..81609d2a3da6e 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -283,6 +283,7 @@ static inline void dw_spi_shutdown_chip(struct dw_spi *dws)
 	dw_spi_enable_chip(dws, 0);
 	dw_spi_set_clk(dws, 0);
 	dws->current_freq = 0;
+	dws->cur_rx_sample_dly = 0;
 }
 
 extern void dw_spi_set_cs(struct spi_device *spi, bool enable);
-- 
2.53.0



