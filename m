Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289CD21325D;
	Mon,  2 Jun 2025 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874572; cv=none; b=iPKreNLCEb+IOGp0Hz2GzZ7a+6Oq1RdBIbSMwdIVQvBSh9HDZePGXE/VSOAXy1pmLT29zKKxyngW01QIeEDPS/0HPQQB0Ez9q/P9KwLmGUT+n55+Q7opwc6NItusbAi1fTF3PaguVpLrZMoCquZcwkdffnxoOpSvFI2cMz/G+Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874572; c=relaxed/simple;
	bh=VbpkgkXPtKMo0DVjgHKrvUAltuqzyi7MT88l6ksMUy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QH9L8p1vkoeDsf29LgLjkGVlwnfBmZmaE9AuTRn1urlXPTxDF6ax9aaCinKBo/up7YbxgBb4ITMzL2MkjKuO2AZ7NAHDAVlF2wb8TW71nuhg2ZTYiZ3t4hyHSW0NAHzWmlVK/fQ+stIqJNsdfeJzYywq+b3OgvQm2AzrKaZ3VxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apML44As; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apML44As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C3FC4CEEB;
	Mon,  2 Jun 2025 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874572;
	bh=VbpkgkXPtKMo0DVjgHKrvUAltuqzyi7MT88l6ksMUy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=apML44AsF5jrOfLyYLY5NMc75i+NrvrZACrpVIq+9hRlIt9opSp1aev9qX2Sl8OaT
	 jElEDUNgK6gv0gC7Hn9IubE+EAbd2kQujTbvKeLE2Z5AHAuBtUz8LxkBSp61R3gjjB
	 EYMttRvw1ozIcFGeSc6M8wZ35K14N3DbPv9yfXFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Shahrouzi <gshahrouzi@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 066/204] staging: axis-fifo: Correct handling of tx_fifo_depth for size validation
Date: Mon,  2 Jun 2025 15:46:39 +0200
Message-ID: <20250602134258.276203771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Shahrouzi <gshahrouzi@gmail.com>

[ Upstream commit 2ca34b508774aaa590fc3698a54204706ecca4ba ]

Remove erroneous subtraction of 4 from the total FIFO depth read from
device tree. The stored depth is for checking against total capacity,
not initial vacancy. This prevented writes near the FIFO's full size.

The check performed just before data transfer, which uses live reads of
the TDFV register to determine current vacancy, correctly handles the
initial Depth - 4 hardware state and subsequent FIFO fullness.

Fixes: 4a965c5f89de ("staging: add driver for Xilinx AXI-Stream FIFO v4.1 IP core")
Cc: stable@vger.kernel.org
Signed-off-by: Gabriel Shahrouzi <gshahrouzi@gmail.com>
Link: https://lore.kernel.org/r/20250419012937.674924-1-gshahrouzi@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/axis-fifo/axis-fifo.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/axis-fifo/axis-fifo.c b/drivers/staging/axis-fifo/axis-fifo.c
index 08f9990ab499a..4dd2c8e9b7878 100644
--- a/drivers/staging/axis-fifo/axis-fifo.c
+++ b/drivers/staging/axis-fifo/axis-fifo.c
@@ -779,9 +779,6 @@ static int axis_fifo_parse_dt(struct axis_fifo *fifo)
 		goto end;
 	}
 
-	/* IP sets TDFV to fifo depth - 4 so we will do the same */
-	fifo->tx_fifo_depth -= 4;
-
 	ret = get_dts_property(fifo, "xlnx,use-rx-data", &fifo->has_rx_fifo);
 	if (ret) {
 		dev_err(fifo->dt_device, "missing xlnx,use-rx-data property\n");
-- 
2.39.5



