Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793522C0261;
	Tue, 16 Jun 2026 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635715; cv=none; b=JB+CRYn5hsFZHwR7rH+EnqfpA3PiWMs45WAeIHVROzYYWhoqhz/glbI4k1G5pLF2pMCkl6gIi/asT2hXPjilAQOrzGSgi7eDzTT4algg9ARS04/Bpm707Nwfqq1xjvc+0sJRZ2u6yuhEjFCRFl+rhBzEN6wcuiLT3aQKP9r+YI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635715; c=relaxed/simple;
	bh=HlWwExrm2Ak7XLcRDXatw5YQjDUm7aouY5B+/3XMyt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2A86LSjmzKAdk5iyfHlcfBz2jH8WiEY6Rptf8IaZI2o9OwOyXk4yFfeYBvzfb+ztU1L/lg40wQXeUe1Rzyn1IWBtvC4di9Vgxk6KltMHQd5NN9PjshNHCilceKcx3U8AKavtr8tvKFfKVCuxvM+iYfdM2KlWO18BAfR2ID9S7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxgTFe/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxgTFe/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B54B1F000E9;
	Tue, 16 Jun 2026 18:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635714;
	bh=PQcTxdrrAFUH6VhUiaXVZEGuiWJxUShWBozt5yvpnH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxgTFe/5I2AISeHi3SKmVgrsY6Se1ZIaGxBYNZoQR6tKPMbLwsX3d7Co+0+cTBABJ
	 3j/T1Plnu8ryOLZsPHVw8aUi2yoFvJ0qG04QMLfgmJ5oB+1wA8SZFcsuf03A0dAwcb
	 peJWc9qVPxS+9UA05mlNIXxNxnPXmMdX9jzSv4ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 102/342] USB: serial: mxuport: fix memory corruption with small endpoint
Date: Tue, 16 Jun 2026 20:26:38 +0530
Message-ID: <20260616145052.980413560@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -969,6 +969,14 @@ static int mxuport_calc_num_ports(struct
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
 


