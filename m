Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97574E1C88;
	Wed, 30 Sep 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783039; cv=none; b=Zi0dx3Q3n6nd03SjVRHbd1ujqFe5vdKpInYV1ywVFEzQqwX4Ra1S/qRFWyNQpi7WO0rKHJqrMyfw+tLKddn0ctOzZeTpeCtJSgyGjWRLlt6+bZiceTRcJwYiBCNWXLglzGvt3pc65Ye7/v753EszfqFNwkQGT6YGhsRQplJU8dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783039; c=relaxed/simple;
	bh=7i6/W9bCUyxa/xx55ebgAFUwMZxrKWwHRTbokqX5qlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaYiDaUj6KxXg2PzX0Efhufs+fi6D3XRdqV25mF6qun6ySDD+DnuAj9Y7Jt/X87tE3Z9X+DskszYI9wbDKfl7ZZAU6BiSbbMvr21AsjJCSrVrvS0SL4WT7AinG0T60Au5l9icDm3wV1QXv8pX+WmctfL7rgAxiH+DfHGqN9XfTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPOY+NBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPOY+NBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECDF61F000FF;
	Wed, 30 Sep 2026 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783035;
	bh=sZaGvE7pguXcl8ICvRiIIW12ubb6zteM3OHSVb6sijM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPOY+NBbyHdOk5Mi1DSCHThFcHT0x6IPcWnXYOIFU6B8JhDJvUeta13jn0E9qwfNB
	 7quA03BzbcMeFS4q7ey72VZZZt294BI1pMThxnzbJ6wPbCfD8aTfzIRNYbASWTA/qr
	 SnsfRbAr1fa8SOWncLfd8gCd6RinYUJtVyYNlpUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangdicheng <wangdicheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 212/595] ASoC: amd: renoir: fix disable_pdm_interrupts() to clear mask bits
Date: Wed, 30 Sep 2026 17:21:45 +0200
Message-ID: <20260930152352.293702614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: wangdicheng <wangdicheng@kylinos.cn>

[ Upstream commit 0c06c4ce0206290c9a934a1e7196aaa86adfe018 ]

disable_pdm_interrupts() uses |= ~PDM_DMA_INTR_MASK which sets all
bits except the PDM DMA interrupt bit instead of clearing only the
PDM DMA interrupt bit. Use &= ~PDM_DMA_INTR_MASK to clear only the
target bit.

Fixes: f621a3676d3f ("ASoC: amd: add ACP3x PDM platform driver")
Signed-off-by: wangdicheng <wangdicheng@kylinos.cn>
Link: https://patch.msgid.link/20260824063507.483784-1-wangdich9700@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/renoir/acp3x-pdm-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
index ca794c2b272d6..c23f3d9be5885 100644
--- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
+++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
@@ -99,7 +99,7 @@ static void disable_pdm_interrupts(void __iomem *acp_base)
 	u32 ext_int_ctrl;
 
 	ext_int_ctrl = rn_readl(acp_base + ACP_EXTERNAL_INTR_CNTL);
-	ext_int_ctrl |= ~PDM_DMA_INTR_MASK;
+	ext_int_ctrl &= ~PDM_DMA_INTR_MASK;
 	rn_writel(ext_int_ctrl, acp_base + ACP_EXTERNAL_INTR_CNTL);
 }
 
-- 
2.53.0



