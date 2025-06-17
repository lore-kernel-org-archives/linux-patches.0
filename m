Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFC318A6AE;
	Tue, 17 Jun 2025 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174627; cv=none; b=Z0nZp1KmDk54peKOFb2gzpvkiol8fnU7Fmyp2iVTx6YCtBd9BbwBfZQcclD5fUSSAY85i7TbNp4Z/d7dTaMFY4mwa5ogFOcDMQvxdTGbD4mOp7QTfBpRxuRzCX2zccE9mUBTgbB5wgID85q0ng2jmbTYfwXob9Z8QJFjw/Rtk58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174627; c=relaxed/simple;
	bh=LKc50pWKi0BPwMqlZymqiRIeU8OJTy9+6YLOJkL1LNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA+ntucoGtwL1EUD+kZdZQrNUgcAjTB7DrLHeuppB2anKF0Vcrw2LJ9ya6zerpUwDG76rSOM544x4p2vo7fXMxrFHRtWOnHoqZbSF3eJHU3e9WH8R8yVQsWenbbpq3lCWcXXYFsh7C9kirA5Vd9a8x1GU61hLRswagPusqHs6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niZA1b/z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niZA1b/z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B538EC4CEE3;
	Tue, 17 Jun 2025 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174627;
	bh=LKc50pWKi0BPwMqlZymqiRIeU8OJTy9+6YLOJkL1LNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niZA1b/zrsYHWU1pSw6HDTfM0Z1Vpbil5p8ZDp8d+aNUzAYwg3jtAzkhSV/gz0+sp
	 GY+Lhj+6+o8esYkT8rytGenfusCophGM0GJGJrNFjc8Q6fjDfTVOLdPkIyHHttLsg4
	 i1rhYfdNlCuLjom6UgZy1seqP8r0Abi78odtXVYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishwaroop A <va@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/512] spi: tegra210-quad: modify chip select (CS) deactivation
Date: Tue, 17 Jun 2025 17:20:11 +0200
Message-ID: <20250617152421.367904616@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 30ed4120a2ef1..92348ebc60c78 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1159,16 +1159,16 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 				ret = -EIO;
 				goto exit;
 			}
-			if (!xfer->cs_change) {
-				tegra_qspi_transfer_end(spi);
-				spi_transfer_delay_exec(xfer);
-			}
 			break;
 		default:
 			ret = -EINVAL;
 			goto exit;
 		}
 		msg->actual_length += xfer->len;
+		if (!xfer->cs_change && transfer_phase == DATA_TRANSFER) {
+			tegra_qspi_transfer_end(spi);
+			spi_transfer_delay_exec(xfer);
+		}
 		transfer_phase++;
 	}
 	ret = 0;
-- 
2.39.5



