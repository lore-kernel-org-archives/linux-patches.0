Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC5F33B6C4;
	Sat, 30 May 2026 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164278; cv=none; b=C7XxxQVGeGiiHE2Z4gbwYxdpGpEFuJ62ccbr4toxkQDaCkOkSRWRA0ZBuwYvC0KsOoW/hcwzvUzh36oa6PNUAvWjkMAabTm7sTa7k/GgCBURNBMHfEwmUn8gtWTLn6RdxclZSpNwGBDJI80XY9q5ECDJejP84tZEIJQOa+Pg5uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164278; c=relaxed/simple;
	bh=0jy/jsKVWEoZiORSuHXgpPCx2VaJgqrPxGIf9gBDLMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNVJZ6HV0vRlbKfNHMDs8lc6mjI457iCozIqZSMRz0mZWsEx1ORUmGQIVsb4lZ/gr+0GO71gOsxxxA/Vos/lAcMlTak+dMNcICpyp/V/5L3EEQ6pt5ELaBj7LSqpXSc23S1luwwfjt+tpo0Tjk57Eb09WF0W8zV9Rd4q+3N0fnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rn2SZIzv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rn2SZIzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCA51F00893;
	Sat, 30 May 2026 18:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164277;
	bh=fvwwvla0mr44cnoMNhhYCgYbFEBv4KkatMRevlKeVjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rn2SZIzvxwNks5Kg+ivN0ZZMvyqMnNT1bKFv65bT6JSBfcOXUzktqynnm1jalkGxo
	 kVQhaVZu3kz4wr8+1Sa7TUdnrbXbBew9LQRrsnbK64dMOxsMmyVeG61sWMWJAe/to5
	 3ufNRTU59uwCJhAVSdCqOaYBVTS2ZqAE7lhhpGQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 507/776] mtd: spi-nor: core: correct the op.dummy.nbytes when check read operations
Date: Sat, 30 May 2026 18:03:41 +0200
Message-ID: <20260530160253.378108699@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 756564a536ecd8c9d33edd89f0647a91a0b03587 ]

When check read operation, need to setting the op.dummy.nbytes based
on current read operation rather than the nor->read_proto.

Fixes: 0e30f47232ab ("mtd: spi-nor: add support for DTR protocol")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index e115aab7243e1..4de12532cb757 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2160,7 +2160,7 @@ static int spi_nor_spimem_check_readop(struct spi_nor *nor,
 	/* convert the dummy cycles to the number of bytes */
 	op.dummy.nbytes = (read->num_mode_clocks + read->num_wait_states) *
 			  op.dummy.buswidth / 8;
-	if (spi_nor_protocol_is_dtr(nor->read_proto))
+	if (spi_nor_protocol_is_dtr(read->proto))
 		op.dummy.nbytes *= 2;
 
 	return spi_nor_spimem_check_op(nor, &op);
-- 
2.53.0



