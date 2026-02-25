Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075702C21DF;
	Wed, 25 Feb 2026 06:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002717; cv=none; b=LAD1PsXjnFafNG2tkNttHlLtJjAPW2z5QPdCtaRX6IhGdqfUVGdib8nYQqYWtsMxdsY1TO7bxkpQNXoUQxxLPImUs5prLt30n0lokCQZJCq2/OhRHqgGGqZ58xrM9LVnlcSQXqK3UiRu785NF5UpdKtWjfdFeKDDpE609T8TqBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002717; c=relaxed/simple;
	bh=HHZHvozvaIUdbhE+PtkdzpkAnTfU5+2ge3tO+8AfiBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6QBCG98BzCfqEsjvcJ5gW9dG/kuMNCAnoCtRIUCECrh4jD8cW4R+rpfamMG3NvU8Ht5f8gk7JmBit/Vxh7exvygrFg8eRuU0Xmyai43bYBU1X0Uzzyi7mqTyaQrJ2ZpyHBatJcCkkqZq4EuZPZqElji68Id/p38x2JhNuEBUGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehzxdXNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehzxdXNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F3AC19422;
	Wed, 25 Feb 2026 06:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002716;
	bh=HHZHvozvaIUdbhE+PtkdzpkAnTfU5+2ge3tO+8AfiBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehzxdXNItH8zzZXQDXQ34eehEUHlAyNlIcIhgItAv5S7RsgCbKgdHkbCDu2zMwuiz
	 KddLW1C4GImqCND24aGHZcxAqO1Sza1xT/cOXb3b79wrhQYzLBVQ4VHPFIVy1SD03F
	 xuPtIi35xn3jHDwasgvQn6XpBh5GnTGhRtMtfsI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 525/641] net: sparx5/lan969x: fix PTP clock max_adj value
Date: Tue, 24 Feb 2026 17:24:11 -0800
Message-ID: <20260225012401.251459749@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
Message-ID: <20260225012411.fgy8Dp-MaUIaxO1bmWY3X8cTXQpSlPlKVQInbHJZH9E@z>

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit a49d2a2c37a6252c41cbdd505f9d1c58d5a3817a ]

The max_adj field in ptp_clock_info tells userspace how much the PHC
clock frequency can be adjusted. ptp4l reads this and will never request
a correction larger than max_adj.

On both sparx5 and lan969x the clock offset may never converge because
the servo needs a frequency correction larger than the current max_adj
of 200000 (200 ppm) allows. The servo rails at the max and the offset
stays in the tens of microseconds.

The hardware has no inherent max adjustment limit; frequency correction
is done by writing a 64-bit clock period increment to CLK_PER_CFG, and
the register has plenty of range. The 200000 value was just an overly
conservative software limit. The max_adj is shared between sparx5 and
lan969x, and the increased value is safe for both.

Fix this by increasing max_adj to 10000000 (10000 ppm), giving the
servo sufficient headroom.

Fixes: 0933bd04047c ("net: sparx5: Add support for ptp clocks")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260212-sparx5-ptp-max-adj-v2-v1-1-06b200e50ce3@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 2f168700f63c1..8b2e07821a950 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -576,7 +576,7 @@ static int sparx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 static struct ptp_clock_info sparx5_ptp_clock_info = {
 	.owner		= THIS_MODULE,
 	.name		= "sparx5 ptp",
-	.max_adj	= 200000,
+	.max_adj	= 10000000,
 	.gettime64	= sparx5_ptp_gettime64,
 	.settime64	= sparx5_ptp_settime64,
 	.adjtime	= sparx5_ptp_adjtime,
-- 
2.51.0



