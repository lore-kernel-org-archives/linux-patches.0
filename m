Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FEA24A05D;
	Wed, 25 Feb 2026 01:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983447; cv=none; b=CTZtbDYzie7+6BbQeVeWTpXyI/n7db2XJ4VgWI9EpiqEXXqcPp1GNse4R5ZPF/OYfoEya+Jpes/04vvzudFrDikVyXNYHaFFu8wArB1ohP6dVoI7uQK+DwobSyvYhPqZJalUSqjIBKI3jGg7McqxIKNH2wb1OxTATcqy+QvvpM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983447; c=relaxed/simple;
	bh=e2ptglDbXDE8HmquQSZoIKswU2BN7d/Uws6KILOKrH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KReU/5xNutcg+Y3ONIQNCCzqzpdC3IBvQp4Dmc/AF+QXWVid2q6Yht/FwXIWKI9JhW+V3Bf2lUOeONqekmi0Rek8YkR+veGJo++5op/ksi+i48IAXY5VwrVEeGTAq+7MBVkKgfukhdmKZx52YOITU8xEoJWeH5Hnt4ze7WIKQNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QNfkmuc7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QNfkmuc7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF3F0C116D0;
	Wed, 25 Feb 2026 01:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983447;
	bh=e2ptglDbXDE8HmquQSZoIKswU2BN7d/Uws6KILOKrH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QNfkmuc76r59nXRtG7QM8nP6wcYU1MQuZs4mQAGPm8bq9Q5TlKXkBCXwvCHHCxh+k
	 zjfbQ/tzV/fGQQsiGxmEmB/+GtzhqMFbQVPw93c3V1bMVgBmBNQtSK+Z5yZm9JKkRH
	 /tiYRS/kMFPAe1oZniBUNgvhL4ID7JC1ZaMylJW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Michael Hennerich <michael.hennerich@analog.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 563/781] dma: dma-axi-dmac: fix HW scatter-gather not looking at the queue
Date: Tue, 24 Feb 2026 17:21:12 -0800
Message-ID: <20260225012413.611454561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit bbcbafb99df41a1d81403eb4f5bb443b38228b57 ]

For HW scatter gather transfers we still need to look for the queue. The
HW is capable of queueing 3 concurrent transfers and if we try more than
that we'll get the submit queue full and should return. Otherwise, if we
go ahead and program the new transfer, we end up discarding it.

Fixes: e97dc7435972 ("dmaengine: axi-dmac: Add support for scatter-gather transfers")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
base-commit: 398035178503bf662281bbffb4bebce1460a4bc5
change-id: 20251104-axi-dmac-fixes-and-improvs-e3ad512a329c
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Link: https://patch.msgid.link/20251104-axi-dmac-fixes-and-improvs-v1-2-3e6fd9328f72@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index e22639822045f..0f25f6d8ae71f 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -233,11 +233,9 @@ static void axi_dmac_start_transfer(struct axi_dmac_chan *chan)
 	unsigned int flags = 0;
 	unsigned int val;
 
-	if (!chan->hw_sg) {
-		val = axi_dmac_read(dmac, AXI_DMAC_REG_START_TRANSFER);
-		if (val) /* Queue is full, wait for the next SOT IRQ */
-			return;
-	}
+	val = axi_dmac_read(dmac, AXI_DMAC_REG_START_TRANSFER);
+	if (val) /* Queue is full, wait for the next SOT IRQ */
+		return;
 
 	desc = chan->next_desc;
 
-- 
2.51.0



