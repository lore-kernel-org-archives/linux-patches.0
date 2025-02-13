Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B621EEA36;
	Thu, 13 Feb 2025 14:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457920; cv=none; b=IclEJgtGdNMYOOTijozFC9XXCHhW0rpC54f6JecpbwTn/C2xAv/S/t2EVmenIcVxPxMff0xbhGgI0W4Z2hWgSQcgiM/8J910fMj7ew/s/FRwVPFXeX32su8NfDjYNsEaP3tGVcaSXTkfuCDsHAiGZfb5J+XTqNanjYm8kr8f+bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457920; c=relaxed/simple;
	bh=LA/opa+4N4nUXk1wKQjBeOx2aenOmH3H8LYHeLZvAeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTz5PHTJa2/48JIuTsLSk1C0z1Do0u/Cii9iBqIboFp/MGIR2LSC+VR00YE7qCWOjPij1c7n5IKx4Zko99FiproS9aWjvhSyrdd/DEFao7Nm9S167v6kx/VsV1yazqnqo5xYfGSvEWmXZom2DX3yCBMWuBqYVbFVZpIIxkrUBuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJ99rZCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJ99rZCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B221C4CEEA;
	Thu, 13 Feb 2025 14:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457920;
	bh=LA/opa+4N4nUXk1wKQjBeOx2aenOmH3H8LYHeLZvAeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJ99rZCE+Smjzb+yRTzSa1i8KHdk/vWJWcRwIPWZ1YfJmsl6yHj9k/tOYzv2nG7fG
	 LSfJEKHOWxuKxw95H2s3nNWJJBkXrG/DxDwPNgZvQZWG02Fua4G4FCoYH/GVjV9kW4
	 nKFVgW1ZwuotHnZUJyO5qIby9l+1taMWc817qpRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 251/422] nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk
Date: Thu, 13 Feb 2025 15:26:40 +0100
Message-ID: <20250213142446.227453812@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2987,7 +2987,8 @@ static unsigned long check_vendor_combin
 		 * because of high power consumption (> 2 Watt) in s2idle
 		 * sleep. Only some boards with Intel CPU are affected.
 		 */
-		if (dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
+		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


