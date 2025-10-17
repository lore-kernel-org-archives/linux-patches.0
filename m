Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E76432E143;
	Fri, 17 Oct 2025 15:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714458; cv=none; b=N4E+42jlMvoS2LpgJQY9bDrTrXfYsqKOOr6y+Q1bw1WVJXjmhvZq9c+oYoBhBIwfov1cQoOfzUqjhyjioCc769GOG1dN6y7dbP8f41CA6Tr3OykjJgGYFk+1r3sfdxibzoAn1HSPe/RJdzPgGV7EXORqQmdqRACo/umPq7Q4Xj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714458; c=relaxed/simple;
	bh=ag9icF00RJ6CThBbFz+R1ZyrIGDduWbePoy+51VxMoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKFtA5smc7V683Lsp7aEv7pKI0t8DYgin1A25rZDCw/JbL2r4+91Kl7qIXKez54r5x4n1w6Jj8ih/+wnETxlFbSuHmAmxaFulQZuMSOFwhLllSTaL0B02wr7Yeao/UOs4Zk1I12rIiIwRVslYYEgGLDDzBePDdW4E79qSrjRzSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Er1T0gxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Er1T0gxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AFCC4CEE7;
	Fri, 17 Oct 2025 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714458;
	bh=ag9icF00RJ6CThBbFz+R1ZyrIGDduWbePoy+51VxMoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Er1T0gxD+LihPMTV/4T4zqffYwyyvNoTAmDIV+XbTVWldDXNdiKcjjFmh+KVbFqog
	 jz+0NYhgwfvRxdQPObVRL3xoj/7yrBWSUNwdaqBXqEQFV6DzVWjfcAzyBVpRyaVQBD
	 uQ0QKI/sEO3Si3cB+T2TC88a+W189HJhhXDP0yFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 153/277] nvme-pci: Add TUXEDO IBS Gen8 to Samsung sleep quirk
Date: Fri, 17 Oct 2025 16:52:40 +0200
Message-ID: <20251017145152.712157851@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georg Gottleuber <ggo@tuxedocomputers.com>

commit eeaed48980a7aeb0d3d8b438185d4b5a66154ff9 upstream.

On the TUXEDO InfinityBook S Gen8, a Samsung 990 Evo NVMe leads to
a high power consumption in s2idle sleep (3.5 watts).

This patch applies 'Force No Simple Suspend' quirk to achieve a sleep with
a lower power consumption, typically around 1 watts.

Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3140,10 +3140,12 @@ static unsigned long check_vendor_combin
 		 * Exclude Samsung 990 Evo from NVME_QUIRK_SIMPLE_SUSPEND
 		 * because of high power consumption (> 2 Watt) in s2idle
 		 * sleep. Only some boards with Intel CPU are affected.
+		 * (Note for testing: Samsung 990 Evo Plus has same PCI ID)
 		 */
 		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
 		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
 		    dmi_match(DMI_BOARD_NAME, "GXxMRXx") ||
+		    dmi_match(DMI_BOARD_NAME, "NS5X_NS7XAU") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


