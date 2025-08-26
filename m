Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7102E267D;
	Tue, 26 Aug 2025 11:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208134; cv=none; b=NntZVZXkwHcQ7go8OpQvFpjj7vG0Za45Uny6phvpF2KcEIsWtFg38mCkX59PxZj5dKfBu6uOY0ZXO3dgon+qixA1nnDPwkxhZXue5QJkP4HAz2HonS3SqtDM0NvEv8RVc/ENPj+V1cJuRmU2haxPrLPl7zFYDYxRgem02dcSreQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208134; c=relaxed/simple;
	bh=JkI1q5e/asneZyX2Gt1mn/KFhjPtBqxtLa8SrgZ2n2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZL7wV/D90OH2gZ/OQJ8kuvJzUCAKpi0p4Jc0LBg9MlH6uWbFbf4trFztrLta1uOF+KY9l2BEsgLqXSzz5sonF2Hehwa4fxTugnFy1u4CnrdxIT+W+7CJJKKIRZt5TFeiuzntf2goURT+qX6q6q2ofVPLQy5yRnDWGEbZQVGs/30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks89mHWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks89mHWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6667C4CEF1;
	Tue, 26 Aug 2025 11:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208134;
	bh=JkI1q5e/asneZyX2Gt1mn/KFhjPtBqxtLa8SrgZ2n2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks89mHWXN6BAvWhFHPSsJnz58zac1nN47M/1HVfTKrZqWOKyunC/BHlGUvVggEST7
	 KB8hQUKA8XchgdLksijYBNZPT0LFLGQr6nnDFgsUq3OPPFAKSGGGt8tfo3svVtg4a4
	 a4sY8EGelYy9pX0SjPNgzmr8vmNkEaE4tSG74iTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 420/457] microchip: lan865x: fix missing netif_start_queue() call on device open
Date: Tue, 26 Aug 2025 13:11:44 +0200
Message-ID: <20250826110947.673816298@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>

[ Upstream commit 1683fd1b2fa79864d3c7a951d9cea0a9ba1a1923 ]

This fixes an issue where the transmit queue is started implicitly only
the very first time the device is registered. When the device is taken
down and brought back up again (using `ip` or `ifconfig`), the transmit
queue is not restarted, causing packet transmission to hang.

Adding an explicit call to netif_start_queue() in lan865x_net_open()
ensures the transmit queue is properly started every time the device
is reopened.

Fixes: 5cd2340cb6a3 ("microchip: lan865x: add driver support for Microchip's LAN865X MAC-PHY")
Signed-off-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Link: https://patch.msgid.link/20250818060514.52795-2-parthiban.veerasooran@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan865x/lan865x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan865x/lan865x.c b/drivers/net/ethernet/microchip/lan865x/lan865x.c
index dd436bdff0f8..d03f5a8de58d 100644
--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -311,6 +311,8 @@ static int lan865x_net_open(struct net_device *netdev)
 
 	phy_start(netdev->phydev);
 
+	netif_start_queue(netdev);
+
 	return 0;
 }
 
-- 
2.50.1



