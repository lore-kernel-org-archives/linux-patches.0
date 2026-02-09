Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1F128725B;
	Mon,  9 Feb 2026 14:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648713; cv=none; b=ZN7ReMQ6YSjitgVUHhqc/DqR9jVxzr2qYtnmE/CPu2Tmrzu9JnkWKBEbaV418KynYOIwg5YQsgMufJqDOG4MGwBsc8Mvbu8lL4MlmubL22VpM7ZO64iXfGlLm+kTuOM81AyeXIi7PZ/kwiW+FooC+JzcUAMlV0+AabFr222adOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648713; c=relaxed/simple;
	bh=4oTsCI5iqVf4d1jwMrZoXkRku+YnJVL2aAeezPdZJnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=II5K7RbAnXwFJNYDz/dPJ/eaQ2Ch3ig09u47IiIzLhsMx7NzTMA4pxbdvjRK4wZaigumWlKeqKGjhYPPeiX24ActuAlD1imTZo1xCDKcf+vBz3CwyyEeM+aXJjFsj4hwvdOo5r2w7p8maEQ/GRLdaiGJTlv/8XehexoK4+pf1FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PncnWWMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PncnWWMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE23C16AAE;
	Mon,  9 Feb 2026 14:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648713;
	bh=4oTsCI5iqVf4d1jwMrZoXkRku+YnJVL2aAeezPdZJnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PncnWWMk0Ch8H/DcnoBMu5K9fD7wMEqSQBYTTSgFK2JGtSq+bEbyI9Wp4PgTGaOTd
	 xRRZbHJJkm6razgU8OAK381WFKChbX1RjAIc6BCAZD96pP0Rb6FIp7BbdwAjPdTFne
	 mryeCfCFmgLnz+5vT3JmusxYkvB8PNGS0dDFNlIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Zilin Guan <zilin@seu.edu.cn>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 27/41] net: liquidio: Fix off-by-one error in VF setup_nic_devices() cleanup
Date: Mon,  9 Feb 2026 15:24:48 +0100
Message-ID: <20260209142257.792346847@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 226a7842d2fdb..ff4346652e0f3 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -2232,11 +2232,11 @@ static int setup_nic_devices(struct octeon_device *octeon_dev)
 
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



