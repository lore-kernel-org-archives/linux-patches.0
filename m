Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFC9442372;
	Fri,  7 Aug 2026 14:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114717; cv=none; b=Mj8m35ifM6Btm7l4bwJb1GCqqnlNpiEuEi7yp23jrh2AOSXv4jTUYjY4+xB0UgOo6rqmhCfAObCXFC9sQ8tRCoQUAFk0dteA5aI93QIwYoA6mIzwVAE6ny9HVerYimSF+VJuulTRlDtVkdHQKiOwwzdoBnn1HoE3JN4xKLXovGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114717; c=relaxed/simple;
	bh=Kf3E/JXlng83hYe532LM1VFIbQD6DCgJbj665ID3tYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCrQZDSSDtxMKB+lu5Glk5KTt28kX0O0uwIrhuGDI3kDepIVQMo0a05IYhHHTMe3996NTB4n7XS8GQ3AeLVp5z06RGcEI9ltfS0DeL5+BXSpPuwQFwboPHHg56WBIwZ9qRUPZvjUuOgc3EnxK0rCylMxvF4K6de1KSgSihElGkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdkIhngS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdkIhngS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821941F000E9;
	Fri,  7 Aug 2026 14:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114716;
	bh=O7lzAeRzCqPNlfO29rr+R0dHBHIGeJPtnxQI1y90qXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MdkIhngSESYEhHUQQRnz+jhjDbicJniAARswMN8TtRtyWijCtUaGNaH8ZNQW0jIJq
	 peX5uV4BjdpMWy8lpQJURcsgifR8X3c9JT7BNrkZGgeGax/omSMWwagIPWC8UsOYbv
	 aVMupiSM5Q0xdVhaxkyJStRkM4qZT7z5eZQ0J0zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/396] ata: ahci_ceva: fix error paths in ceva_ahci_platform_enable_resources()
Date: Fri,  7 Aug 2026 16:33:03 +0200
Message-ID: <20260807143424.775784372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

[ Upstream commit 4d99a91574c420decab56cc880fad0dc15b8a7a3 ]

On phy_init() failure the error path fallsthrough to disable_rsts, which
deasserts the controller reset and then enters disable_phys calling
phy_power_off() on PHYs that were never powered on. That corrupts the PHY
power_count and triggers an extra runtime PM put.

Use a separate exit_phys path that unwinds with phy_exit() only and falls
through to disable_clks while the controller remains in reset.  Reserve
phy_power_off() for the phy_power_on() failure path only, and skip
masked-out ports in both unwind loops.

On phy_power_on() failure re-assert the controller reset before disabling
clocks and regulators, matching the teardown order used by
ahci_platform_enable_resources() and ahci_platform_disable_resources().

Fixes: 26c8404e162b ("ata: ahci_ceva: fix error handling for Xilinx GT PHY support")
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci_ceva.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/ahci_ceva.c b/drivers/ata/ahci_ceva.c
index 2d6a08c23d6ad..2961e53288f42 100644
--- a/drivers/ata/ahci_ceva.c
+++ b/drivers/ata/ahci_ceva.c
@@ -211,7 +211,7 @@ static int ceva_ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
 
 		rc = phy_init(hpriv->phys[i]);
 		if (rc)
-			goto disable_rsts;
+			goto exit_phys;
 	}
 
 	/* De-assert the controller reset */
@@ -230,14 +230,24 @@ static int ceva_ahci_platform_enable_resources(struct ahci_host_priv *hpriv)
 
 	return 0;
 
-disable_rsts:
-	ahci_platform_deassert_rsts(hpriv);
-
 disable_phys:
 	while (--i >= 0) {
+		if (ahci_ignore_port(hpriv, i))
+			continue;
+
 		phy_power_off(hpriv->phys[i]);
 		phy_exit(hpriv->phys[i]);
 	}
+	ahci_platform_assert_rsts(hpriv);
+	goto disable_clks;
+
+exit_phys:
+	while (--i >= 0) {
+		if (ahci_ignore_port(hpriv, i))
+			continue;
+
+		phy_exit(hpriv->phys[i]);
+	}
 
 disable_clks:
 	ahci_platform_disable_clks(hpriv);
-- 
2.53.0



