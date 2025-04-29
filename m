Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606AB241664;
	Tue, 29 Apr 2025 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946583; cv=none; b=M0IGVj19GGJlfQa/yhpTRbopzh5Vvx/m3reNuQ5YXJHPlqwIKisUsugSpwNQCALvSse3nRf28jwMX9jyxnd9HkJp8ZJXB6OycwJFEICeSrNWmm3cLuEOJ/jI/JsRDrKS7d5sp3r+HwOV/G2x5skWANUSipBuEWvvMzqp3BPshUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946583; c=relaxed/simple;
	bh=3ouw0GKSdcbafQwqV7jaA05To1IJ8Akhw1EQxw59TAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uj0i6uipcO4pVmUnvdaXbBqtLweWLuU/7lceTvNZfW21RpchCqYwJcsBFWzsmG8FkayzSbBA0PYeogriyQDiTe7rxdNqgAzVjZEoMZ7AUWDjW1ohemPxepqLdPdzLuO+wOAidpBA8yGr475enT+yvLRcqr6qFZ7p6GaOKYkd7hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTWEBQL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTWEBQL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0132C4CEE3;
	Tue, 29 Apr 2025 17:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946583;
	bh=3ouw0GKSdcbafQwqV7jaA05To1IJ8Akhw1EQxw59TAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTWEBQL+tWIlgN1yZb1h4O03UZ5k2U67FTgJ0vU+jR4xQ2QjViKeS+K/WIrIPYBda
	 1gZzGzcdq+acqiuVZf9CV+3rKhFw0HddrxfHGd0KmvsnJFgJcD871hVf2or5WW0rm7
	 UCNcANxGoiV37GchVrGsqrItcgXwCkxhjLTTpYU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 285/311] spi: tegra210-quad: add rate limiting and simplify timeout error message
Date: Tue, 29 Apr 2025 18:42:02 +0200
Message-ID: <20250429161132.681765321@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 21f4314e66ed8d40b2ee24185d1a06a07a512eb1 ]

On malfunctioning hardware, timeout error messages can appear thousands
of times, creating unnecessary system pressure and log bloat. This patch
makes two improvements:

1. Replace dev_err() with dev_err_ratelimited() to prevent log flooding
   when hardware errors persist
2. Remove the redundant timeout value parameter from the error message,
   as 'ret' is always zero in this error path

These changes reduce logging overhead while maintaining necessary error
reporting for debugging purposes.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20250401-tegra-v2-2-126c293ec047@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 2d320fbb8875f..64e1b2f8a0001 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1118,8 +1118,8 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 					QSPI_DMA_TIMEOUT);
 
 			if (WARN_ON_ONCE(ret == 0)) {
-				dev_err(tqspi->dev, "QSPI Transfer failed with timeout: %d\n",
-					ret);
+				dev_err_ratelimited(tqspi->dev,
+						    "QSPI Transfer failed with timeout\n");
 				if (tqspi->is_curr_dma_xfer &&
 				    (tqspi->cur_direction & DATA_DIR_TX))
 					dmaengine_terminate_all
-- 
2.39.5



