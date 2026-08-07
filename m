Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA18C2F0C74;
	Fri,  7 Aug 2026 15:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115825; cv=none; b=ClsbJs5YQ3ThdLSxOCu8Ni2xaNRRJ7q03BO0221V+3+uSwFZOxjC58rzQ/I3m1+tNN1ak5qPBlKcSPsEM+XxEBX2tB/ppC+GMZNBQ8jpJCWtZXYNFqLqC31J9Kw3w0na5ULGPeOK7eTWkSE7DrsV8s/METimLOY2R7Sg7jls35g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115825; c=relaxed/simple;
	bh=abhkEssOd7jt849H6KbX8PrxfFrSOQ1eQUR27H5QOzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2KD6BMRKExVMBwKuGcvstvqk4+2BqBWVougwIwOFUVIqduMYSqRExySL/iqEOhGkXdT6yWptc4uTuT8KvcZF7+reJOuNb4UMGBFIwBkl59cLKDGO3nh0nCGB+yTxEOaxsJYFWEofZylnwK0i7PZWFA/kDYc0nFxSP7NZEPVZIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3od7se9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3od7se9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786091F000E9;
	Fri,  7 Aug 2026 15:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115823;
	bh=HCiVp7UXOHD08ruO6TIcyB7M1E8UUUK3LSWDlDcfFUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3od7se93FDDfottQtgZFjfRTz4Clh5dgJGquMm7bFLmpPpKBUVLx2ROXs/75N+48
	 MhPdEQft88vb74cADGJx1j4URao0vBYh+I+rJELMiy6k832ok5qR3lvz1W1sBi8j/9
	 5EqcITQ7y+3ojjnX2n9EGd99FdmLAgnYe7e3i1Mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/261] ata: ahci_ceva: fix error paths in ceva_ahci_platform_enable_resources()
Date: Fri,  7 Aug 2026 16:36:13 +0200
Message-ID: <20260807143415.718630081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 93275b1b48898..b2918ad8e7e05 100644
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



