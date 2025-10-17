Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDDE330B1E;
	Fri, 17 Oct 2025 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716437; cv=none; b=CB0Wl1PEgbcrNNUg6KXzeKActgM4zsV/DR80gseTDi3vjo3fzjKO2jWKbcFYUIttd8a6cNEW0DSnSE7Jl0R2JJ3SqsZjorEhzJ3yAljvj68E7WgwpbX+X0ioXTN3PMJqg5HZbxiNVt4Mo5s/fivDmq4HtXEtO2pvCpdrEFZ+Pak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716437; c=relaxed/simple;
	bh=JWDKO63b8KSYeF//QI/sphXlryThGhNnpIZ4Ah1o+ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upSmSDXoBtQOHlraNWdD4wSOWApm8xfMn5Os1Vx+gWbpPs9X56bYnP1H2k8wrq8aPDAmoQ+osCaXanwddIXSzPMokgpgUZk14T//lsKPsHN+69NFyrj6ddJ11n2vVc3ear+GdBZ+qixxM389MDzS2x5LWVICtEFTGlJbBr32wsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g6k+7uSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g6k+7uSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1063C4CEE7;
	Fri, 17 Oct 2025 15:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716437;
	bh=JWDKO63b8KSYeF//QI/sphXlryThGhNnpIZ4Ah1o+ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6k+7uSE1Hy38WH2lABz792FokxmEt0Q3qWTepAMrPuIEJTtjaf1tVsMq6wyK6o1O
	 AS+kBmiRM5zlJqb3EyDlSGPF7ENtV+arHTp2pWk/B/SW2kQhdwB+pM/yDJ/5tU6SaZ
	 lCXFtA+l+uHFS8qZzkx7gpxuHfLpniXiK7orPAys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 191/276] nvme-pci: Add TUXEDO IBS Gen8 to Samsung sleep quirk
Date: Fri, 17 Oct 2025 16:54:44 +0200
Message-ID: <20251017145149.442865919@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2979,10 +2979,12 @@ static unsigned long check_vendor_combin
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


