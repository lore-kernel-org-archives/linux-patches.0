Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519C232C946;
	Fri, 17 Oct 2025 15:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715513; cv=none; b=hZDeCwJz2aaMm4UU7eqry/zzGJHDU8Xu0Dy4pbxkOhQ/8mQHRVpK2ncCtAMxxcEGMYseG6P/Vd44C5WRwMFTh/RaXmXgd0LMS39e6sfQOXM3d0SMP2TQ7BTyF35vecDfyC9jNZvkHLm5q+YFIkHafXFNphZNdcQF0EV0v7CScPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715513; c=relaxed/simple;
	bh=cB+5/1upxyuunge0WMXYdB6G5KgnSFYHHl8l8AgC0bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUEz8kV+qT8g5LGH7uKc1B4a0+hxJpFDUYIpnGp10oV9KXGbGecHU/F8sgn7MQOzFRQjEqFzrc7D+YYpZgLxU/f9dTPuBAeTjii13UnuDsfOzlmmjoqDE60RTBm+sofrIzAPeZdKFnGRGjl5kZ7QW9KGMuMIwOCymEgMBdwJGyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1sN99LL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1sN99LL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDAEC4CEE7;
	Fri, 17 Oct 2025 15:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715513;
	bh=cB+5/1upxyuunge0WMXYdB6G5KgnSFYHHl8l8AgC0bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1sN99LLT5IjvINBONCE2SObcVZB4jAP6FUYs25lIzTrQ8/o/Jjqy0jj384xpYt4j
	 fm2jadOtlyP7RmdHle+QAoJDmDZQicL8TdrcG90u82op6yTPrxcrtlHhz+adXfH3xe
	 fI5+b5v9g0Db7YZ6boSLkbCYn+F3/18SFGmfE0V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.17 243/371] nvme-pci: Add TUXEDO IBS Gen8 to Samsung sleep quirk
Date: Fri, 17 Oct 2025 16:53:38 +0200
Message-ID: <20251017145210.870512219@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3324,10 +3324,12 @@ static unsigned long check_vendor_combin
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


