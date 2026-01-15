Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A6F2C11CA;
	Thu, 15 Jan 2026 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497416; cv=none; b=rLrwpoO+KqhS4sSG/VxJAzDorwFGF55htdWfrUBoabNrv1XTp0LBVn5+p14ffr0AEku8N5+nt0adq0LrT4baSVlixgzbux9DMbhdBIHQGpwdNV0dk3JJg2KUBKww1Y2XOmflr5CqVnVKUkHk9om2IrSHwGAkZls3EUgPecIZ3QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497416; c=relaxed/simple;
	bh=h0kHrPKMAoOuFrmNwfSwTJJeUQFWZB8r8s44sZznZlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tcjtS86/6jU6//C0G2KgX68R8ZPFbMrliBOxyOsOEW8CKErnKVR91esh9Fu8WQ6ev3M5PSpwvKXbzAdvhxlKBqWU/wJiUoR7mfNPZi1Txiqe0QI3iCuTA0oGaGK8IouJEjIhUM1qfnTUdBB/9jU/KeCodx4hu4rb7CSMCRXeN8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hn+y75nQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hn+y75nQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B65C116D0;
	Thu, 15 Jan 2026 17:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497416;
	bh=h0kHrPKMAoOuFrmNwfSwTJJeUQFWZB8r8s44sZznZlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hn+y75nQBccNKzPyee8Ck2dQHGKdHwFg5TFjCuuyW9eslhmE4DwrWBVHz+5gRp2q8
	 21yHvJj3XL0tOcYcisGIimoIjV9YNYufku6UtbqOcRd0AdEPmJlseMC+TtXHFLNde4
	 ve471T0LoHJ8P8f9RqMkcNMMGG7ChM3n29A7qzQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/554] spi: tegra210-quad: modify chip select (CS) deactivation
Date: Thu, 15 Jan 2026 17:42:20 +0100
Message-ID: <20260115164248.920663209@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Vishwaroop A <va@nvidia.com>

[ Upstream commit d8966b65413390d1b5b706886987caac05fbe024 ]

Modify the chip select (CS) deactivation and inter-transfer delay
execution only during the DATA_TRANSFER phase when the cs_change
flag is not set. This ensures proper CS handling and timing between
transfers while eliminating redundant operations.

Fixes: 1b8342cc4a38 ("spi: tegra210-quad: combined sequence mode")
Signed-off-by: Vishwaroop A <va@nvidia.com>
Link: https://patch.msgid.link/20250416110606.2737315-4-va@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: b4e002d8a7ce ("spi: tegra210-quad: Fix timeout handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index ff6a2c297b8af..50243a520158c 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1148,6 +1148,10 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 			goto exit;
 		}
 		msg->actual_length += xfer->len;
+		if (!xfer->cs_change && transfer_phase == DATA_TRANSFER) {
+			tegra_qspi_transfer_end(spi);
+			spi_transfer_delay_exec(xfer);
+		}
 		transfer_phase++;
 	}
 
-- 
2.51.0



