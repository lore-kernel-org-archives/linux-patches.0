Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D68A137923;
	Tue, 15 Jul 2025 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587487; cv=none; b=kVo6ZjEfpPKH7eXqEO+V4CK+m/zy9m2PmKLPjkmiluXz7VP8iUxCak9nm2FzYwOrzI2nFBPiNiBT8xGAOfndhlNoGKI3zxFg3uop2Dvw7KKEWWQ1Ui3MpQeaHjtqQF3Vy1K40lsFfEmEfg8NfQ9UNXJsqdxtvUtBBtpgL58/MMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587487; c=relaxed/simple;
	bh=U9II0IO+c/JAoYd29BIwp+qH3XtQTjIv8zp2/C44Iic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7Q9n9J2lO1BNFFgZgsMFXMYAHOJ7+MITEHLu4xVE4XXFF/ZPVY3CHBVkQ/d+TdJnbhAsDx/a256rjxYtsoJHR6TDT3R5Xv/guNetHYvqEI1+WIvettcShZSCpux35SOdUys3Y529jh06GzQKN5ZsVw2ssiyXqSiSN6xFam/KWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGp8LUsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGp8LUsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17101C4CEE3;
	Tue, 15 Jul 2025 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587487;
	bh=U9II0IO+c/JAoYd29BIwp+qH3XtQTjIv8zp2/C44Iic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGp8LUsr2NKhSXlshGkMvakgI1DIRoN24ophafQAOtkm7RSlw/AKolaVtfuvs7IsW
	 34JpXRR2bGxCkifdE5p/127miwcogGlxqX5t6nEXi9Zp4QD6FM+XHobFgy8ONu9Gei
	 akc3zw0MFMcqd17rA1UQWBP9t9YFhesYVn7+zFjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/208] dmaengine: xilinx_dma: Set dma_device directions
Date: Tue, 15 Jul 2025 15:11:56 +0200
Message-ID: <20250715130811.131026315@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>

[ Upstream commit 7e01511443c30a55a5ae78d3debd46d4d872517e ]

Coalesce the direction bits from the enabled TX and/or RX channels into
the directions bit mask of dma_device. Without this mask set,
dma_get_slave_caps() in the DMAEngine fails, which prevents the driver
from being used with an IIO DMAEngine buffer.

Signed-off-by: Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>
Reviewed-by: Suraj Gupta <suraj.gupta2@amd.com>
Tested-by: Folker Schwesinger <dev@folker-schwesinger.de>
Link: https://lore.kernel.org/r/20250507182101.909010-1-thomas.gessler@brueckmann-gmbh.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xilinx_dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 12ad4bb3c5f28..3ecf0109af2ba 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2844,6 +2844,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = irq_of_parse_and_map(node, chan->tdest);
 	err = request_irq(chan->irq, xdev->dma_config->irq_handler,
-- 
2.39.5



