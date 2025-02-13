Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 036D918DF6D;
	Thu, 13 Feb 2025 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460606; cv=none; b=k92jjJxo+2Ah6wr346B0EhSyERyFvQmIIZcbn+R+bQop5af1JH4EYxjBtN6zxy6cN2Xna8d+zx7XGw96n3iX+mCNk+lpFTsmdZB/J9VsQs2nnkzNaARkeFe4u+yEGc4uFC+zQQD2dbFBqqwrNWDzQu9I0DXGnDK46l6CkzTn0Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460606; c=relaxed/simple;
	bh=F2DC9gOdoqLCH36BiL69zMKzo4RZBKCXZ2REfCT76Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7nONV0ta2ZCl8W3YdTrrQyRHtwjF5NmARmlFnU/tzZU494y79Fg1xphDTZRHO2S6JHmq76jsNVR+Y1DWfRt+gs2YpM5rNsK+rzp1ao0ivvcGYpxf5R/9fjT0AGuBBxBOFUu2qy2Zk9KkVWb05+PbVhIzc38Zj6qjU1NuKHXBt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGlZNlYm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGlZNlYm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7ACC4CED1;
	Thu, 13 Feb 2025 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460605;
	bh=F2DC9gOdoqLCH36BiL69zMKzo4RZBKCXZ2REfCT76Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGlZNlYmEpTQZ5E7oKVILQwH6J5Nz6D/ivJbUbFhz1x3UXTdDq3cBjfIktdjYjJp4
	 eLfUOPcJyVtF2eAtPDjuw6oH9wCK85tZ2SKqruC7IEvr3rveehj0vxPsVE3wTWXDLN
	 zns35bwek+TaIGg+ZqxVH12CMW65hK2FKOCxZGJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 160/273] nvme-pci: Add TUXEDO InfinityFlex to Samsung sleep quirk
Date: Thu, 13 Feb 2025 15:28:52 +0100
Message-ID: <20250213142413.658779974@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2949,7 +2949,8 @@ static unsigned long check_vendor_combin
 		 * because of high power consumption (> 2 Watt) in s2idle
 		 * sleep. Only some boards with Intel CPU are affected.
 		 */
-		if (dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
+		if (dmi_match(DMI_BOARD_NAME, "DN50Z-140HC-YD") ||
+		    dmi_match(DMI_BOARD_NAME, "GMxPXxx") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PG31") ||
 		    dmi_match(DMI_BOARD_NAME, "PH4PRX1_PH6PRX1") ||
 		    dmi_match(DMI_BOARD_NAME, "PH6PG01_PH6PG71"))


