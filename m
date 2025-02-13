Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEDC335BA;
	Thu, 13 Feb 2025 15:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459586; cv=none; b=O62mthaH5rbpr6mZMtpjEUQKZFFG+OBcDsUOi/p0xDvJOKGwx+EChNRvKiXNxwkrKDfWbeU7JvdWVwMccD3mbNylZgJEMQwIYX0j03O55P05MpTIEEA9SudtWVCpxeNw28S3HJYtyZ2EIYjG6vh2p81dQZDkjldM6glIOU2H680=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459586; c=relaxed/simple;
	bh=AjJPRX6xvFlOundlhzv95QnpirEloMUL/EzciLdVfTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojQU8k0JsK712N/67y5wrQxTmip/hIN6tPMMRLVkdHUhzP3pY8nnaJarJAtP7NOZAsJFyrTCBlNicl9V8whgFDuDa9T4zvNUHTk9LVLMu0uPJsB66nhDmQ29a1M0/7S/5JChAdr8+Ekh140jBLX2agGa8d9VcgxxgMV/i9Jt+Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jfbx6Ls+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jfbx6Ls+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BDEC4CEE4;
	Thu, 13 Feb 2025 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459585;
	bh=AjJPRX6xvFlOundlhzv95QnpirEloMUL/EzciLdVfTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jfbx6Ls+e/JfAu+mT/3Ad4VVf0qwEuWKcHzlL0PNAQUyWpZSV7R9gaTRGF8E4F74B
	 MZj67eUZLWXF7mt9pk2dbW5aJ6ArbS3mH0WvWsIbahqEcMeW7Hu2yPP2aQynZVPmWB
	 56jIwebd3W9gWE02/HwwquknvVpBCtznu6DOQTlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.13 277/443] nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk
Date: Thu, 13 Feb 2025 15:27:22 +0100
Message-ID: <20250213142451.298764326@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3148,7 +3148,8 @@ static unsigned long check_vendor_combin
 		 * because of high power consumption (> 2 Watt) in s2idle
 		 * sleep. Only some boards with Intel CPU are affected.
 		 */
-		if (dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
+		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


