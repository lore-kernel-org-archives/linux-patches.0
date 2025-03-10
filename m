Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5A5231A3B;
	Mon, 10 Mar 2025 17:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629438; cv=none; b=C1ovo5BW6eyrmMj0yhaO/yTZTKqv4AW1eKJztEvFj2jZCsh0vhC4O/TeJD2qtyC+YZkYJykkQ3bhd5tLfJSMaidzcplH6oRRjchpU/NSZ8w18I/XXO6X3A25Tj+vuHA9t9k2EuH/ou6pn+LWEBty9LFjOFnPiyp44Awk+Wk3nMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629438; c=relaxed/simple;
	bh=Usyl3SPSrg+45pXFYH+UcaBUo84cEaAwrfoaIcLKGDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QFyiRBc9Xw5rkxWRmg6vUaN9vSzCVTlpU+/gnlwPnia/WC+3TpwtgoRN/2Yayl1i+pa97zNPRKw21wnay9RLZzVyffvVjIKaeidTyTL9gVCwnUcT2Cx1MkriHDM+gt2d9YfuTbKhggL0bPNOioqv3fLPDD4VSmjOKySREKJFsRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMvMBWFe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMvMBWFe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901B7C4CEE5;
	Mon, 10 Mar 2025 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629438;
	bh=Usyl3SPSrg+45pXFYH+UcaBUo84cEaAwrfoaIcLKGDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMvMBWFemDeMXzeuRmOA8gHW9oTaJLmmq78QUzIijBV4/hg2oSCqb0F3GXVaOfrBx
	 Uz+nZFQn2dMrpqphaE8DnVfzlmbsP6VuGP0fyO1IGB5+Lu517ddbZAhdGA+22VFkqC
	 wXlP8iyOkhEftS3w35aTfO1UBf85ZDtHI7x0wWSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 295/620] nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk
Date: Mon, 10 Mar 2025 18:02:21 +0100
Message-ID: <20250310170557.267058788@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georg Gottleuber <ggo@tuxedocomputers.com>

commit dbf2bb1a1319b7c7d8828905378a6696cca6b0f2 upstream.

On the TUXEDO InfinityFlex, a Samsung 990 Evo NVMe leads to a high power
consumption in s2idle sleep (4 watts).

This patch applies 'Force No Simple Suspend' quirk to achieve a sleep with
a lower power consumption, typically around 1.4 watts.

Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2975,7 +2975,8 @@ static unsigned long check_vendor_combin
 		 * because of high power consumption (> 2 Watt) in s2idle
 		 * sleep. Only some boards with Intel CPU are affected.
 		 */
-		if (dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
+		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


