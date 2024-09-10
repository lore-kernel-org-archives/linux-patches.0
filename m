Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938B214D431;
	Tue, 10 Sep 2024 10:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963479; cv=none; b=XcKvSkr1YKQ/yfPbaF0LTfj2R3KeJaGgOsj8whppGqtadO1M/pZpcVtxKT3k6rC22fbuFp7C2WQewMVvvmGzdJkcJ8kd7S2xNMEckZbWKtNAQZPxJyQiapB5eHCqWTsF/B5rrJn911Mv3KWi4H1rXuw/blFv5POk9pCqDyk5KJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963479; c=relaxed/simple;
	bh=fMUy+5XmCtCPmWQPq26x0/RX5Q/554u7Q7TKfczrxhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jz/sWxPQ8Vn5OvLlZ1/mWwe+djIafRoUcOrR3MVQu6EenCdMb8k5u0pLuyooR8+u6ye+bEYnnH0I8yPHsY6LCXjCEZ2dmA9GRmWE6fiICH/VY4VVCEiEGjmxhXraFOK3tPS1FOX+ZAK4UFmaWKA/3j291IbM4iEaUyXeapnplPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN39LuBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN39LuBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0E0C4CEC3;
	Tue, 10 Sep 2024 10:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963479;
	bh=fMUy+5XmCtCPmWQPq26x0/RX5Q/554u7Q7TKfczrxhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SN39LuBs1XOq1wlKSa7Mt0QNCD/Ux7FIQuELRhxkRjIjFyO1GZ3gV4zjGJYWIKhv+
	 yfZEaX380SljMsMMSuIw00819oJnepd4ocrS/07cZiXHy1ujdLc8irR1OdLbsQBkHM
	 P5bL7rmvvfmUGN2p3pvxAi85HqZEPgIgvC2SKopA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.15 072/214] nvme-pci: Add sleep quirk for Samsung 990 Evo
Date: Tue, 10 Sep 2024 11:31:34 +0200
Message-ID: <20240910092601.683034182@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2974,6 +2974,17 @@ static unsigned long check_vendor_combin
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


