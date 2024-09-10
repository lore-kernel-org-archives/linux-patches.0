Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53161188A28;
	Tue, 10 Sep 2024 10:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963961; cv=none; b=cTl7NvmDdHyEtWyV3QYTujd2NTJJJMBlHV806KSCDd1n9olQ/cEBYhn2JeaqdzK7Oo4ekRfNlgedlT9zekn9Ugefi4a7H2nFB6d0n7BcLBb8vmHeQU2zbxtlhmVQ2n3jenx0aQxPkhO9cbf7UQS1n2+pb85kcfxRX3SJn/wSTDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963961; c=relaxed/simple;
	bh=/+Ajvf/xXzPzMxeYUR0mSUuhm5NoL9r+iQMJCcbbBLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkWRNDUuc7Be6tC1GwA2XefG+xzVu7UaS4gYNSjz4f36fx1weOXrhhqdusP0ewGcOUCTmZ6djh6PxqyqMkPSYHpuDTH6AqjMFm6dR91qbhyvfd9+Wa87eyWqkXJ8p5HSsOlRLjjqjWgJlJd+Tsam2vkpthrz4mszozt0Q+Yk4bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ4l0lq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ4l0lq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB1BC4CEC3;
	Tue, 10 Sep 2024 10:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963961;
	bh=/+Ajvf/xXzPzMxeYUR0mSUuhm5NoL9r+iQMJCcbbBLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ4l0lq1cNBNj0KEEEc6jdkCw9Lt+8WhqqsnWcwSPGKoIaWs6P6emcSqU43APdXuR
	 r72Zbrl5E+6nv9LGxzvITenwFjU4zTw9+32G/rTsynkrSpMEigPZ4dITw5OC/3SpfP
	 Wv6cSruWV7V8nj39aQn1Cton7D2VMH14esvMBEZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 020/269] nvme-pci: Add sleep quirk for Samsung 990 Evo
Date: Tue, 10 Sep 2024 11:30:07 +0200
Message-ID: <20240910092608.986167898@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit 61aa894e7a2fda4ee026523b01d07e83ce2abb72 upstream.

On some TUXEDO platforms, a Samsung 990 Evo NVMe leads to a high
power consumption in s2idle sleep (2-3 watts).

This patch applies 'Force No Simple Suspend' quirk to achieve a
sleep with a lower power consumption, typically around 0.5 watts.

Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2929,6 +2929,17 @@ static unsigned long check_vendor_combin
 		    dmi_match(DMI_BOARD_NAME, "NS5x_7xPU") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1"))
 			return NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND;
+	} else if (pdev->vendor == 0x144d && pdev->device == 0xa80d) {
+		/*
+		 * Exclude Samsung 990 Evo from NVME_QUIRK_SIMPLE_SUSPEND
+		 * because of high power consumption (> 2 Watt) in s2idle
+		 * sleep. Only some boards with Intel CPU are affected.
+		 */
+		if (dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
+		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
+		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))
+			return NVME_QUIRK_FORCE_NO_SIMPLE_SUSPEND;
 	}
 
 	/*


