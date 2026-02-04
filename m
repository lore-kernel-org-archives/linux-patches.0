Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4253641C301;
	Wed,  4 Feb 2026 15:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218190; cv=none; b=JsHSjwLFxG670s9tGIPuQM3TA0b5BtxvGPHhlzvHTTX+27MiShLcE2ZyT0Q232CvUTDtj584OX+W9HPgDqkM2f85eWpMm0l8MowAMnVLoCKnlovGKc4e81V5EYbY9G7U3h4uDklGj39ybMKUrakns8ByS54L/Vy1Oiu+Z8aHqNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218190; c=relaxed/simple;
	bh=z9tsET8YBsDylTIuo6AgySI1vqMwRjhphGBpgwoXU08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aulEpiWMbY+dtOupGlPY+fTZKVs6kJzI3cvkx6NRV3CYUL/5boGRZFBchw2P4Y8fH9AR0NBJaGb9QQy60anhcIerqLThR5iECAK2Gygg7KBvTXEX2eGqpZ8BJz+mZr5YtjqZ2haL9XRBfpJqwrT3SWGcprXMZkgUvPA0BCIH97I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zr9lwRav; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zr9lwRav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7D4C4CEF7;
	Wed,  4 Feb 2026 15:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218190;
	bh=z9tsET8YBsDylTIuo6AgySI1vqMwRjhphGBpgwoXU08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zr9lwRavRqdzhOEk1i20wZ0EaT1LZ03niOWiqevPtXpo0F18UiYf0kbBJS7DhPXhl
	 WfLhiDnDNhyTuivSOQ4xCvwsVXlMz/7KEEQ7aOZsbSPll1M02r+TaiPGTaS54F1pa5
	 nblR+c7DHjvkhClepwyiyonj08MLNPbZ92LCigwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kery Qi <qikeyu2017@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 195/280] rocker: fix memory leak in rocker_world_port_post_fini()
Date: Wed,  4 Feb 2026 15:39:29 +0100
Message-ID: <20260204143916.622804444@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kery Qi <qikeyu2017@gmail.com>

[ Upstream commit 8d7ba71e46216b8657a82ca2ec118bc93812a4d0 ]

In rocker_world_port_pre_init(), rocker_port->wpriv is allocated with
kzalloc(wops->port_priv_size, GFP_KERNEL). However, in
rocker_world_port_post_fini(), the memory is only freed when
wops->port_post_fini callback is set:

    if (!wops->port_post_fini)
        return;
    wops->port_post_fini(rocker_port);
    kfree(rocker_port->wpriv);

Since rocker_ofdpa_ops does not implement port_post_fini callback
(it is NULL), the wpriv memory allocated for each port is never freed
when ports are removed. This leads to a memory leak of
sizeof(struct ofdpa_port) bytes per port on every device removal.

Fix this by always calling kfree(rocker_port->wpriv) regardless of
whether the port_post_fini callback exists.

Fixes: e420114eef4a ("rocker: introduce worlds infrastructure")
Signed-off-by: Kery Qi <qikeyu2017@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260123211030.2109-2-qikeyu2017@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/rocker/rocker_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 2e2826c901fcc..b741d335b1dc4 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -1525,9 +1525,8 @@ static void rocker_world_port_post_fini(struct rocker_port *rocker_port)
 {
 	struct rocker_world_ops *wops = rocker_port->rocker->wops;
 
-	if (!wops->port_post_fini)
-		return;
-	wops->port_post_fini(rocker_port);
+	if (wops->port_post_fini)
+		wops->port_post_fini(rocker_port);
 	kfree(rocker_port->wpriv);
 }
 
-- 
2.51.0



