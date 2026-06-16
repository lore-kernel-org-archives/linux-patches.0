Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8943CE4BA;
	Tue, 16 Jun 2026 18:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633657; cv=none; b=hoQ6bYq4UJOSEktxg8Ac3+g96UuZ30nEIjMLxa2SAyxnBlGk+BUV+a/k41W9GnDJV3J9Wk46q2duB6Q/pl9oD87zEyQiJImqVyxdIBM+BCMzbRI5Y3saOTLPTHP90cvyY1dKa5qpAKa6uKgsEdYxWwqQWuaa8FHT1YiQ4SHqJsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633657; c=relaxed/simple;
	bh=NrvWLHnGIXEtqw0F7VCgKZiZqJ5v2Ix6+tWhJClQ32I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6rVpmWGHQShqQTNEB4Vcxq5TbiJtn+LVCs9iGHLQd7iq3h5T6kutHENc5LyRa23Cxp07ok7rJlNUDidlYO8dPlsnCBUMmXXmV5ONy2F0Ey5B9tZbu4+snwCNTCcYSmzD89gAzgCUm+JDxYZ3naa8YE+avIip4YPK2/WZL7mG1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSZjwftQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSZjwftQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725FB1F000E9;
	Tue, 16 Jun 2026 18:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633656;
	bh=YGtnU8SFTiVmzljZmU4nNA3UYJNCIiaQM6BKovwwVUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eSZjwftQSqSVM91b+40Khmw6CcSUnT8U9FcrC5/DldS/odxZYea8jDDvoSLRTkPAy
	 k88v3Wa8VmKmXdg0ELnN/KEnU+SB7jrWnjXhjtSo9Cd3r2E1cU8mRBGRIW9PHH5Rx/
	 aeiZIqjzLT9dzCRS/AUsuG39eqQEdqcDbn5qQUI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 119/411] USB: serial: mxuport: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:25:57 +0530
Message-ID: <20260616145106.640595509@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 4085f0dbb1ce2251c9a5938d693de6593f0ab2bd upstream.

Make sure that the bulk-out endpoint max packet size is at least eight
bytes to avoid user-controlled slab corruption should a malicious device
report a smaller size.

Fixes: ee467a1f2066 ("USB: serial: add Moxa UPORT 12XX/14XX/16XX driver")
Cc: stable@vger.kernel.org	# 3.14
Cc: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mxuport.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/serial/mxuport.c
+++ b/drivers/usb/serial/mxuport.c
@@ -962,6 +962,14 @@ static int mxuport_calc_num_ports(struct
 	 */
 	BUILD_BUG_ON(ARRAY_SIZE(epds->bulk_out) < 16);
 
+	/*
+	 * The bulk-out buffers must be large enough for the four-byte header
+	 * (and following data), but assume anything smaller than eight bytes
+	 * is broken.
+	 */
+	if (usb_endpoint_maxp(epds->bulk_out[0]) < 8)
+		return -EINVAL;
+
 	for (i = 1; i < num_ports; ++i)
 		epds->bulk_out[i] = epds->bulk_out[0];
 


