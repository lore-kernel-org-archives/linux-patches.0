Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6683370FF;
	Fri, 17 Oct 2025 15:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713303; cv=none; b=RxqsEZ/gbGeuXyyRO9saQc5jRNGwLiaftn3wvPCLIyafMkNb9sOpAO7Pyvl44BtgZPJ0SofSCwo+LFQILmH+kW7KmokdimAOS7AUpWDeU4gBya1qyOluPIc9iYL4knn3AgI1b1NHnn6zdk6bAvc8wxEVTKMuef515VtsCwn686I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713303; c=relaxed/simple;
	bh=GNIHHK0FDP3GAGWT1yXjP+7RjtCSWjXJny+xI9qZPFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp8UKzo/ih67waGe0HLIbk/eEljHl6siKBbwTb9kbPtnbBvFVTqKnC4298ZKW/pweu8tXIhAtgVX+EXhnUWN1OU/Shu2HkGsMmF25GlF6jnp5jmOwh9Ohx5LxbtgdqWd3DH3rWqqnSKa4IbnJu58TXDaiTUyr67NcvHCFap2pkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sVHEzuVs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sVHEzuVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E465DC4CEE7;
	Fri, 17 Oct 2025 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713303;
	bh=GNIHHK0FDP3GAGWT1yXjP+7RjtCSWjXJny+xI9qZPFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sVHEzuVs/IVKcJmkiaYrP0awSCwGTHSbAISahE1yC0bGk4LZ8prexa31f1g0wFB9b
	 zz9WRGxoNCsUNZYB76385ovwl9GD1aupbYbuC/n3B4rXczqU1QwwdjE79CodGKtjJR
	 WZLEnM7g5WdiHz8k38bOZeQ3U71fkNeupC0h4Kco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 091/168] nvme-pci: Add TUXEDO IBS Gen8 to Samsung sleep quirk
Date: Fri, 17 Oct 2025 16:52:50 +0200
Message-ID: <20251017145132.381214044@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3109,10 +3109,12 @@ static unsigned long check_vendor_combin
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


