Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9CE2690EC;
	Mon,  9 Feb 2026 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648620; cv=none; b=VJLHGviv5qj3V+KPIgvSx2x6M/p60kUGLv5ZG+t3qIHtAzSnZU7Rdri/9dPu6SCfVw0cMEt6i+5hik1OMWpof+vIfkMcKRN+rXPNggqOFwW0Q6qs48P1ZokqHNPJsJSsQi4hNgG+ReZCJWQ6jBQOYf6s17SH+r5nvzboQVdRwaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648620; c=relaxed/simple;
	bh=RFwDqJb+yGwj3rGxknsvsAHFPAbdjyGlC17hQ9TnRJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3EIPyNoTyjjzZNyc2/b4mHgkV5+0hb3Di7JX/kmq3o9tEs7GezZAUpCa8l99Ac0rt/panV84yWp3+aMd3neH2ABJ6x4bwnBpnDRRl9O2cgN1Hr53ocaq61S4clrw/mEplOnowtJ+gzgT39A82xDVQk6pKm6ynSO7L9ga47dxHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gr4WBeCW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gr4WBeCW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D198BC116C6;
	Mon,  9 Feb 2026 14:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648620;
	bh=RFwDqJb+yGwj3rGxknsvsAHFPAbdjyGlC17hQ9TnRJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gr4WBeCW5e1584kC5VIpk+xubKBeT0DLjBXX805RPrfXgyH9RXDx08B2kFpwQ6YuB
	 1iQH3Ay3QJbRpjc+jP5FEHzW3ftgo5JoqFzGFOou6HMPdCfVusM7j0gi9yj5Ie+R2O
	 uucHeFdnHIYOz6x5PHFcDuEth7rI+LwtZDzfrDk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Zilin Guan <zilin@seu.edu.cn>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 65/86] net: liquidio: Fix off-by-one error in VF setup_nic_devices() cleanup
Date: Mon,  9 Feb 2026 15:24:28 +0100
Message-ID: <20260209142307.116755651@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 6cbba46934aefdfb5d171e0a95aec06c24f7ca30 ]

In setup_nic_devices(), the initialization loop jumps to the label
setup_nic_dev_free on failure. The current cleanup loop while(i--)
skip the failing index i, causing a memory leak.

Fix this by changing the loop to iterate from the current index i
down to 0.

Compile tested only. Issue found using code review.

Fixes: 846b46873eeb ("liquidio CN23XX: VF offload features")
Suggested-by: Simon Horman <horms@kernel.org>
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Link: https://patch.msgid.link/20260128154440.278369-4-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 62c2eadc33e35..15ef647e8aad3 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2221,11 +2221,11 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
 setup_nic_dev_free:
 
-	while (i--) {
+	do {
 		dev_err(&octeon_dev->pci_dev->dev,
 			"NIC ifidx:%d Setup failed\n", i);
 		liquidio_destroy_nic_device(octeon_dev, i);
-	}
+	} while (i--);
 
 setup_nic_dev_done:
 
-- 
2.51.0



