Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DEE847F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:58:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1BBC4339B;
	Fri, 10 Mar 2023 13:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456732;
	bh=fMGz2DWCGd41BOKS0mJl82IWM79KeKk4E+6XC8PH7VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLul98dAcU3WW8VyiDYXf1UUvVGzWQc2HzA6xD6cEDf5aOJgukxnmzSGNdjbeaUoc
	 eZlko0BcOl1bOB+a+DcsREOCKPP1bs5OrJhBQ6l1wlDt6a9/gfyBywgYiAW+jBF0nF
	 8pYWNNFwawtyH7DT1c7ajWz4fVEmpXCCTd6ZC4Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 104/211] spi: tegra210-quad: Fix iterator outside loop
Date: Fri, 10 Mar 2023 14:38:04 +0100
Message-Id: <20230310133721.924845433@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit 2449d436681d40bc63ec2c766fd51b632270d8a7 ]

Fix warn: iterator used outside loop: 'xfer'. 'xfer' variable contain
invalid value in few conditions. Complete transfer within DATA phase
in successful case and at the end for failed transfer.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Link:https://lore.kernel.org/all/202210191211.46FkzKmv-lkp@intel.com/
Fixes: 8777dd9dff40 ("spi: tegra210-quad: Fix combined sequence")

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/20230227200428.45832-1-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 6498948e150a5..06c54d49076ae 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1156,6 +1156,10 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 				ret = -EIO;
 				goto exit;
 			}
+			if (!xfer->cs_change) {
+				tegra_qspi_transfer_end(spi);
+				spi_transfer_delay_exec(xfer);
+			}
 			break;
 		default:
 			ret = -EINVAL;
@@ -1164,14 +1168,14 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 		msg->actual_length += xfer->len;
 		transfer_phase++;
 	}
-	if (!xfer->cs_change) {
-		tegra_qspi_transfer_end(spi);
-		spi_transfer_delay_exec(xfer);
-	}
 	ret = 0;
 
 exit:
 	msg->status = ret;
+	if (ret < 0) {
+		tegra_qspi_transfer_end(spi);
+		spi_transfer_delay_exec(xfer);
+	}
 
 	return ret;
 }
-- 
2.39.2



