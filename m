Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95823236F8A;
	Thu, 12 Dec 2024 15:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019085; cv=none; b=QWAw8g/LB6pAl059KtEoKNWQynx7OMt/5vZChYutkal+xbS8lq+2oYZYvWpfy+Ext8z/xi03smg1SWwXYDiHo8ShoQXRdRMc74sHu4JUEXFn4t/oyt03ehcIS4KjtDM9JO6mp/nsx20PTZBkH6O3Ku+LLzXR33WLYPgCRGJLU9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019085; c=relaxed/simple;
	bh=wumm/3skrCXZonkWJJeatkMpEq10h5VrIY64TNfAHdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPr/cENWW8qN1eRt0y7+vJoXTg57ptFv8u2MyWfSRpdRNvHWzYaYxFh0ESRW5qjIU9FOVhxEzX6pNX/SeT4326Yr2MalN77bgWRxUHP8DZO+keOZMknyePD3EecV0Hj7Qe/kLqLUIEIRS9t+vc7emFCW4dYMVlgBpfd1vlq01t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqlYdNV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqlYdNV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D82C4CECE;
	Thu, 12 Dec 2024 15:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019085;
	bh=wumm/3skrCXZonkWJJeatkMpEq10h5VrIY64TNfAHdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqlYdNV930OVwqVtRdHm4x0dVZjn80AWAAQ+oiH1CwE7+PeiqInmedqfWtuEwhqUC
	 Y+EYh8s8bDaP131nbOGjD5Rr4bZZMioOMiH3/NrzmcdC9g/+6Cggrgrvq/NCPT3q2i
	 wL61K7tUS/vDl5kdqdE0S4uNWJj8ZkrpyrUdiIJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 113/772] spi: tegra210-quad: Avoid shift-out-of-bounds
Date: Thu, 12 Dec 2024 15:50:58 +0100
Message-ID: <20241212144354.590914620@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f399051ec1ff02e74ae5c2517aed2cc486fd005b ]

A shift-out-of-bounds issue was identified by UBSAN in the
tegra_qspi_fill_tx_fifo_from_client_txbuf() function.

	 UBSAN: shift-out-of-bounds in drivers/spi/spi-tegra210-quad.c:345:27
	 shift exponent 32 is too large for 32-bit type 'u32' (aka 'unsigned int')
	 Call trace:
	  tegra_qspi_start_cpu_based_transfer

The problem arises when shifting the contents of tx_buf left by 8 times
the value of i, which can exceed 4 and result in an exponent larger than
32 bits.

Resolve this by restrict the value of i to be less than 4, preventing
the shift operation from overflowing.

Signed-off-by: Breno Leitao <leitao@debian.org>
Fixes: 921fc1838fb0 ("spi: tegra210-quad: Add support for Tegra210 QSPI controller")
Link: https://patch.msgid.link/20241004125400.1791089-1-leitao@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 06c54d49076ae..5ac5cb885552b 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -340,7 +340,7 @@ tegra_qspi_fill_tx_fifo_from_client_txbuf(struct tegra_qspi *tqspi, struct spi_t
 		for (count = 0; count < max_n_32bit; count++) {
 			u32 x = 0;
 
-			for (i = 0; len && (i < bytes_per_word); i++, len--)
+			for (i = 0; len && (i < min(4, bytes_per_word)); i++, len--)
 				x |= (u32)(*tx_buf++) << (i * 8);
 			tegra_qspi_writel(tqspi, x, QSPI_TX_FIFO);
 		}
-- 
2.43.0



