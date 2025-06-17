Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F196A285053;
	Tue, 17 Jun 2025 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177602; cv=none; b=no4uRpdxyoYoGmHx6Aa9EAE5LoAmSpZZmpZOIOOUokhkEAw01bm/zffIJguWDEtBZzPc5aQFK6xiJexug6FOvAYvuBLSnUiilYjRWbdbFjEPr9gFrxO+a7Uu4S1dRKg4xNcwBG2sNFdo0ajWVDCWD28HNIVgo7UX4D062fSBiDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177602; c=relaxed/simple;
	bh=1qEtxk5eaHFO7TKelh+6lrmCRFTIGyB/vdEtCkr08q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0zI60Oa9+MDjT2qjvQIf86SN+Z2GO7UmCTiEwI/zVcVWE16fyVUOOYI/dxHA55H4Sa0Gy+8s+8Q7gl6a4iOkmXNdW9QLHsj8yv2vuWxOZaV6rC4IBQBrFpgHMgZL24SJ/k2aZRd5LvNxFqxoV9Zm11D0dtsUMoe1oa0e/L4fVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KR0tFDUL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KR0tFDUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2877C4CEE3;
	Tue, 17 Jun 2025 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177601;
	bh=1qEtxk5eaHFO7TKelh+6lrmCRFTIGyB/vdEtCkr08q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KR0tFDULqMLDh76HSLeKXrMqJYeeTDpzToo626IsQMz4FXTBSPNCCKfi4831G4dg5
	 vugMIUH2EsfHXNvBxp/+rbqABohj1u49/vGGqTWnoBBkqXTLpEiqk21FuVAVvrZjMy
	 BgryjMxp7MMQZSsCyTl9nDsC39gI21FLk0EbZtOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Singh <nitsingh@nvidia.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 328/780] net: mctp: start tx queue on netdev open
Date: Tue, 17 Jun 2025 17:20:36 +0200
Message-ID: <20250617152504.810834148@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 126cd7852a62c6fab11a4a4cb6fa96421929ab69 ]

We stop queues in ndo_stop, so they need to be restarted in ndo_open.
This allows us to resume tx after a link down/up cycle.

Suggested-by: Nitin Singh <nitsingh@nvidia.com>
Fixes: 0791c0327a6e ("net: mctp: Add MCTP USB transport driver")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20250526-dev-mctp-usb-v1-1-c7bd6cb75aa0@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-usb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/mctp/mctp-usb.c b/drivers/net/mctp/mctp-usb.c
index e8d4b01c3f345..775a386d0aca1 100644
--- a/drivers/net/mctp/mctp-usb.c
+++ b/drivers/net/mctp/mctp-usb.c
@@ -257,6 +257,8 @@ static int mctp_usb_open(struct net_device *dev)
 
 	WRITE_ONCE(mctp_usb->stopped, false);
 
+	netif_start_queue(dev);
+
 	return mctp_usb_rx_queue(mctp_usb, GFP_KERNEL);
 }
 
-- 
2.39.5



