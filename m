Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387F4353A6B;
	Sat, 12 Sep 2026 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236923; cv=none; b=XG7zPFT2yKcKX4Qz8Bfm8v3LsyyWzQ4qNM9tRS5UNsv1QAzdbAxG0PzoNLT/VaZmYRhNuhfLEPGng6a8C5CEGLrsAqUQItZBK/WUFeTQAbRMKLTVwoxLm5aNA/L1r9WgaPRmi8DhEJc6gnZHOkvWKB9WhFs/k3d4K9b+SPNURPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236923; c=relaxed/simple;
	bh=t0eDmVQEXRvBNhkeEMnMwrrJck1hGrsE4qSGh/Fm5Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdOGQjaIU3M82JjvdQvXDWExbw9rmL2pCL69DZ+h4WYgiIVHbqtYxRE4bmKR0rXP0k6mVqq1GQ/KVT19AoWeW06d2fDap35XTi24UA3NqlHJq3V2NwTz+Yw6b4Lggv9pVeTbQEmyCcfQBcCKvsdYBG4Wwe2qi19PJMUITxu+LSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJJ3UVlk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJJ3UVlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E383C1F000FF;
	Sat, 12 Sep 2026 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236921;
	bh=wOBdRkPeLGxKoh6d+XxM9C7YvhvNQwSu9P5RLghaZ7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJJ3UVlkWplzihGO58TyHJoj13aW+aEmG7X6Dh3aJXipmO4iiaiP46uE5WQJBIUhU
	 oPpTAGavhZKcMGhSwcMwBoR5Fmv04tzuZwqYnTyDVW3J8aXP4qPxnyhQIgFLIHllfZ
	 jXkZo58nB1mlvMj6wMOceaOMeSeYcM1gqWE3iNuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jameson Thies <jthies@google.com>,
	Benson Leung <bleung@chromium.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 153/935] power: supply: cros_usbpd: Limit port counts to EC_USB_PD_MAX_PORTS
Date: Sat, 12 Sep 2026 08:53:03 +0200
Message-ID: <20260912065530.333323015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Jameson Thies <jthies@google.com>

commit 657cd3a42e937276262c0a8ae6b01a87004309de upstream.

Currently the cros_usbpd-charger driver probe iterates based on raw
charger port count returned by the embedded controller. The only check
is against the number of USB PD ports which the embedded controller
also defines. A malicious embedded controller could return an inaccurate
port count (up to 255) resulting in an out of bounds write and
subsequent memory corruption.

Update helper functions in cros_usbpd-charger to limit port counts to
EC_USB_PD_MAX_PORTS.

Fixes: 3af15cfacd1e ("power: supply: cros: add support for dedicated port")
Cc: stable@vger.kernel.org
Signed-off-by: Jameson Thies <jthies@google.com>
Reviewed-by: Benson Leung <bleung@chromium.org>
Link: https://patch.msgid.link/20260722195059.1420738-1-jthies@google.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cros_usbpd-charger.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/power/supply/cros_usbpd-charger.c
+++ b/drivers/power/supply/cros_usbpd-charger.c
@@ -136,6 +136,11 @@ static int cros_usbpd_charger_get_num_po
 	if (ret < 0)
 		return ret;
 
+	if (resp.port_count > EC_USB_PD_MAX_PORTS) {
+		dev_warn(charger->dev, "Charge port count out of bounds\n");
+		return EC_USB_PD_MAX_PORTS;
+	}
+
 	return resp.port_count;
 }
 
@@ -149,6 +154,11 @@ static int cros_usbpd_charger_get_usbpd_
 	if (ret < 0)
 		return ret;
 
+	if (resp.num_ports > EC_USB_PD_MAX_PORTS) {
+		dev_warn(charger->dev, "USB PD port count out of bounds\n");
+		return EC_USB_PD_MAX_PORTS;
+	}
+
 	return resp.num_ports;
 }
 


