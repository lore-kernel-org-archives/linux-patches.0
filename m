Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42231C173D;
	Wed, 19 Feb 2025 09:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957141; cv=none; b=oYZGdmyUtg+UrlMQEGxsLbNbcpv9uAwfFr4fzv7vVer40eSLAAPG1hnPLFyuwskouYm+b07rq+b891NmYUxVXWafVctM5EXqbLOTv3S1Vimkz0MHntdAIyEZwlFmcw9ecM4gceeMg2DZAvU9fIlfsaypl1z/2lpZwL1dkb60Ppk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957141; c=relaxed/simple;
	bh=wi2cF5Cw/H8kJ7sFFjE9jyzi/qv6qAFFRB57JX8UDDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjNxJqiYrrPFsK7pYFnRxRLm9qKDXQAuBI3D3VMwMs01ZpIybf1C78ruTC8Su1N7dZbAaBXZR5nLr4HR3DUdlsWJaziLQsE7GKGT/PdSTetLAsTcSRquVNUwn+ZM1odYC5/Hw5ban1HYgpbacTDynI/vHKyiUDkqjmXfPWFaexU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcVxjJ4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcVxjJ4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E767C4CED1;
	Wed, 19 Feb 2025 09:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957140;
	bh=wi2cF5Cw/H8kJ7sFFjE9jyzi/qv6qAFFRB57JX8UDDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcVxjJ4GHODi0XUoaXV4BA98DBA9k+HEsLs4BWwnaQb6xt0HhckWaqI57XDZEk/pU
	 3Lrzb9TsJXSMGqpJbsr3MDaq5OGJkWhIvQpxes/LhfEpgdUqtzwwQps2nCGursamkn
	 oSuQTdOflDp1T/QTQ8QHcixahezkw+1t9x5+MThE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 391/578] nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk
Date: Wed, 19 Feb 2025 09:26:35 +0100
Message-ID: <20250219082708.406609038@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3103,7 +3103,8 @@ static unsigned long check_vendor_combin
 		 * because of high power consumption (> 2 Watt) in s2idle
 		 * sleep. Only some boards with Intel CPU are affected.
 		 */
-		if (dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
+		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


