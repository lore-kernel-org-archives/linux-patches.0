Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2016439F7C;
	Fri,  9 Oct 2026 14:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555786; cv=none; b=elVWk+yOV4yPJ1sAZvsor2GfoPQCQCNNectMSml2OY2ywyRyqU4hW+l+woDcl41VPi/d/2KHPvxpIGoC2QmwYFqNuxUcvOR7ranEmuAnUneTB0z+/MRgOD6KQ6ttmjOvJ4wf1JT90RxjvA3si/F5lGZiIOrng+Cluq1jRd2Hpek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555786; c=relaxed/simple;
	bh=uK6B+TfASqcZ7Pk9Frqo895D4QtqZxBZ9DHoAA3rJJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWvY5Wtnz/iWXsV+B5VW9fx0PdfecAlK677mpw1wy7V/iypMeOwggmd4wJlqY+LYQ6/+FaDqyLIO4PLG1o9sF7ovOkTkHqB6tVH3YudNxYkDjKBNOMSwvBAuzbV+b5qY55emXi7rpRsRsdO2MR83U8ah3finbttmaZ775Sdnj24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KohyKwvy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KohyKwvy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF421F000FF;
	Fri,  9 Oct 2026 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555785;
	bh=7iIr4vMMq+rYAtYii4LWkujwYoH9oPBal3M4QaK8uEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KohyKwvy2zbh5tZ07K3yeUuQDWiPZnrqhHSnkfCNMZPIqMfeNsi45ob+PL/lSc8Lu
	 ZSeWzfbNipEanP7BmkaDNPNAczDN/7Mt105UvWNilRbf1jKmf/Ky4ayPXJLopk5/9N
	 8qag8nMwb6nQBaa2Bw5x1/XUFsTG82lMWsYAc3PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Freimanis <quentin@q-lab.dev>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/403] net: sparx5: skip ptp deinit if init was skipped
Date: Fri,  9 Oct 2026 16:07:59 +0200
Message-ID: <20261009140954.839380942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Freimanis <quentin@q-lab.dev>

[ Upstream commit 0d2c49915bc3aea4521cda5e4d42f24f63b94585 ]

sparx5_ptp_init() returns early on the base lan969x variants
because they do not have the SPX5_FEATURE_PTP flag. It also returns early
when no "ptp" interrupt is described. Unbinding the driver then causes a
NULL pointer dereference when cleaning up uninitialized tx_skbs queues:

    Unable to handle kernel NULL pointer dereference at virtual address
    0000000000000008
    Call trace:
    skb_queue_purge_reason+0x68/0x120 (P)
    sparx5_ptp_deinit+0x64/0xc0
    mchp_sparx5_remove+0x38/0x70
    platform_remove+0x20/0x30
    device_remove+0x4c/0x80

Before per-port tx_skbs were added, a NULL dereference would have happened
when calling ptp_clock_unregister() on the never-registered PTP clocks.

Fix by returning early in sparx5_ptp_deinit() if PTP is not used.

Fixes: 0933bd04047c ("net: sparx5: Add support for ptp clocks")
Signed-off-by: Quentin Freimanis <quentin@q-lab.dev>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260928044542.29287-1-quentin@q-lab.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index a16ec8136d6d6..5953e04ef14e6 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -673,6 +673,9 @@ void sparx5_ptp_deinit(struct sparx5 *sparx5)
 	struct sparx5_port *port;
 	int i;
 
+	if (!sparx5->ptp)
+		return;
+
 	if (sparx5->ptp_irq >= 0) {
 		disable_irq(sparx5->ptp_irq);
 		sparx5->ptp_irq = -ENXIO;
-- 
2.53.0



