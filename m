Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F05F1DE8AD;
	Mon,  9 Feb 2026 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647544; cv=none; b=VXqPtcFyIkCsCOFasI0b06yzHw5mvaG5tQAZNmmz/AHoAKBFp0KA7DGoLX8XVflwJw6HaLSCLH5hrYB+YzwTTZe0z+O0Q0c++fwrcAXh/l5/Kdfr3q3Ef21ayA8VTPY+h6KMaxNRG5eEDNnbsATNQo5huG4mmUimrTw9XersZ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647544; c=relaxed/simple;
	bh=Dj8u71Jnv5jR2bFb0q4K+XjOZZXP1K0poFyLSB5IKb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxABrZe7k4/nVtALe1z0mbI4QR72wwbiapjFacL6mIKcyZE1Jr86Ce4gzHBtYEA0mxLoNNpddVMUopYra3Z/vC6kxUFhtF1nzACIfGoHD+rtWnCsitPi5lHYy4LRY3dxLENu4P2GdCZ5V/08Si6Feqjvh12cNfldhU56ppQYGiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Axb31G3Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Axb31G3Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA80C116C6;
	Mon,  9 Feb 2026 14:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647543;
	bh=Dj8u71Jnv5jR2bFb0q4K+XjOZZXP1K0poFyLSB5IKb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Axb31G3Qk0G8FS2e6WEw3YXHwHgW5uhdHeXfJWMZudYGDKnBxeAXU34dHoUPETCR7
	 H4+TBiV1Z5C4NNYstxgXUoZdjNcQyhbOkSeoYW62lablLNA4QpijbzMDSHa+US2OeZ
	 QOy6rncu0dJct4SWo4iOxgEh6l9e+3GEFenIh4gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Zilin Guan <zilin@seu.edu.cn>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/175] net: liquidio: Fix off-by-one error in VF setup_nic_devices() cleanup
Date: Mon,  9 Feb 2026 15:23:17 +0100
Message-ID: <20260209142324.971657455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3230dff5ba056..5c177146b35b1 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2222,11 +2222,11 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
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



