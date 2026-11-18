Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060676;
	b=RhSZ2tJ3QvRbX8Bm/+t25ak/ArzoGZLRNHeN6M336XuupwKICzLlLLVyLj+3Sv4D6w3T
	 0F+CMXVYoiKLylBBLTwudVUiliNMNHVmV1nciDwKY8csctPxbXkvL8B0D1aRZoex89e9e
	 erU7SUsmfLJ6scgk/mhqTcFV0XimARpVWeHmCj+i2JU+sdp0/64C7bWWvNV43mSJKUae4
	 vsVXdIblW/F6C4To+Yyb3fF0YFDNK7IFnD0p/GbT6gW8V7hzXCeom6fM0wePhKgsMJlMp
	 9ykB23jcNs6Z44UlD/om2EgBnqvU5Y4dBzaSHnwCPuQW12jt8nWvcWp6YQkRLg8OGug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060676;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2MCY7ne3D9KjTZB9wJRF0aFDLOlFcSw7ZAa8GvU91O4=;
	b=OdIUcL0yvH8/EHcF0LSKpQ5xqeVLGV4u/gMoQXTDqd1EF4NdEaLclonkrPUuhF/5rHf5
	 BDDgYGexoXDfQ5yQI0w9a8wDuMylyTVla5OByVYdfysLjxJy6y/EZlv+6b7DmoRAzenzZ
	 oFFOct8rO2m/0Y272KO1KfBikDirb8wzzD3A7nmmweSrYndh+qkMaS15oBqYwgbbBt/Cs
	 4i0UY2nobiCAaqRhJOoO1IB2LNylczQFU6l52ZGRAleFXxZXN+XO8grkXcu/9aBpkyIhZ
	 XQYq6gpVOaIUNcTJ5l561zrfC7WU7+CZh64pRwavTNusafMSr9Zwt6Hs02gbECerr7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnyw530O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEFD606A331;
	Thu, 19 Nov 2026 03:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnyw530O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C83E1F000C5;
	Thu, 19 Nov 2026 03:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060675;
	bh=2MCY7ne3D9KjTZB9wJRF0aFDLOlFcSw7ZAa8GvU91O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnyw530O6wg7Nr7pcfcNBgLR308vUEj8Nn2a0UK1YQ3ddV9R4SmB0l31luamfswy2
	 DCsj1ipZBelRDBnlCmkoMIuLn+kpBvxyiFdxeafLZS1ggEzEd1yIasxzxL12cSYJUp
	 qV7a3ZC9YRLxIjPNr0zAzrkd8ZpNDglSbEYZTt+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1282/1848] spi: mxic: fix ps_clk leak in runtime resume
Date: Wed, 18 Nov 2026 15:55:20 +0100
Message-ID: <20261118150013.275079840@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 648e3c436032b675b339662ea9c0edd9221add76 ]

mxic_spi_runtime_resume() enables ps_clk before calling
mxic_spi_clk_enable(). If the latter fails, ps_clk was not
disabled.

Unwind ps_clk with clk_disable_unprepare() before returning
the error.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260902-mxic-v1-1-76806325826d@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mxic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mxic.c b/drivers/spi/spi-mxic.c
index 4fb19e6f94b05..60be411d09615 100644
--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -510,7 +510,13 @@ static int __maybe_unused mxic_spi_runtime_resume(struct device *dev)
 		return ret;
 	}
 
-	return mxic_spi_clk_enable(mxic);
+	ret = mxic_spi_clk_enable(mxic);
+	if (ret) {
+		clk_disable_unprepare(mxic->ps_clk);
+		return ret;
+	}
+
+	return 0;
 }
 
 static const struct dev_pm_ops mxic_spi_dev_pm_ops = {
-- 
2.53.0



