Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B354071DD;
	Sun,  7 Jun 2026 10:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829483; cv=none; b=glj88ak6Z90f4/w9qyKK9ONRvi35xom5EywXYdvAxaVZ+vc9c7KFf+ogIIuPr2hujU7ws345AICNi4Cq7gKg3dbGyoQwqv+smpq1fJunHVvSC6uS7SofhpJFkws3bwliXR41k7aEB1RL+OmKkqsQ1BCHSKrEz1qFq/jqkNADzGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829483; c=relaxed/simple;
	bh=HZZWHX4yv4RR/aW4iQEqd4xwdYstvgLUmsxRFwsQuPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYiGwmcuc62Ggltle59e6CS/ewqPYiJFiFUZetWCaRCLX17sL9ybosLQgeoAbauX7/bdDIdK6cF4vxUnyOYyk0aJD16/YoEj01am0YSFkUZ0ggc8v7CUhR/9dioIJ0ivji51s4PlpTiXoEGUHKWCZcigXysw3hwnOky78TVuCo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LfvXE11b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LfvXE11b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6161F00893;
	Sun,  7 Jun 2026 10:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829482;
	bh=pUa60TgMQN1LKMwg1c/wfeSpuvnnjRu4RnXns+WbnQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LfvXE11bP324H5JddcJL437JfC0fYX5xYH0h1iXMN1iVX+MNXtiRK2mw6j13tatfi
	 vTyKa7Vl9L9PJwtphSeFBAdZaVy+GsvnMXgDfhWwWJSTdj0Xx8uTWYotbO9hi5B2lS
	 Mo5b428+Dqd2a2ENsO+AgpR1XEYqq0B6QMbS+CU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 228/307] USB: serial: mxuport: fix memory corruption with small endpoint
Date: Sun,  7 Jun 2026 12:00:25 +0200
Message-ID: <20260607095736.083783173@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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
 


