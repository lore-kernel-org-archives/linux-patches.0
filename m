Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E282264A7;
	Fri, 17 Oct 2025 15:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713750; cv=none; b=jyRV8D8g1+09coWRhRCSWp/4CNcqXcq82Vdrywoh7JmrGWlnBROyNW/yFkDZ8R6c3nAqmWe9r5bXQG9Ic9Xbpsf6f3YxgJumDs9UbtF2yxe47pWVks/Oqva6aV5atidO2y50ONKRgWeJvmY2dPF1Kqv114mh/WaLfZLjWY3AIEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713750; c=relaxed/simple;
	bh=GOYAwrAGKigJHJYYBfEWAEHi2PQPqAuo219GMzhAAWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfeRE+7Kie/AMVfOWdMxcWMTeP7ybyQ1LpKthzPODrNcVedS+6rsjQ69i2KOKVjO+B1cdC9ROgjQqI1oe0xKmXJsHXLRKch/Wv8qk6lK8epaGj29GqatzATtiwfi82wC1Yk5DKZjKyg5aheo7KoZJtr0j68YNWTTfFPneaK6IYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=btQBqURJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="btQBqURJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655EAC4CEF9;
	Fri, 17 Oct 2025 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713749;
	bh=GOYAwrAGKigJHJYYBfEWAEHi2PQPqAuo219GMzhAAWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=btQBqURJaU0a+YnMnehPP3WuYBOfqFfJN0L12OuaP/uga31dRFcG6br65Kwijid1Q
	 dWquCRyGSfvgqgkdZoxPDEkvOb37DQZLU3riZJEvzsPHzPNakFoEdBlU65eS1j3Pdp
	 Fg6w1qFOfiKBGYzMWUWEHoXXCte+3we9rB3EEmew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 106/201] nvme-pci: Add TUXEDO IBS Gen8 to Samsung sleep quirk
Date: Fri, 17 Oct 2025 16:52:47 +0200
Message-ID: <20251017145138.639540709@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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
@@ -2986,10 +2986,12 @@ static unsigned long check_vendor_combin
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


