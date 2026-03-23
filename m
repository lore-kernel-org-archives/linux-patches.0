Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3010D23815B;
	Mon, 23 Mar 2026 14:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277365; cv=none; b=DbzwhQlgWdspqM3En51HMppsbcAa8ZM91kKFZrRoZVQylfnpdnzqSf55oidLZ3tTWzBaCPLN1CO1YW1q5xNa0i4v7AxvG+z6vRZUDOzoMQ3akyICXADv+OC9MKi50lfqlZaOMhZLWOr3Oh+0KlJ0vGnpAqTRfi9rgbJi8MBm6mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277365; c=relaxed/simple;
	bh=zsynROwYK7ev5IK4DvKbqeb8efjsOLepTKmmvZFm0sc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVCcDssQWMf7uNSOZBXziY0vCl23rjyhJWLgVrGSZdxRMADIEP+ijrU52EkVLZSQjZ6P8YdNB3mt8MtqH/U27soA694b3r6EEjcrMkSpFbPmlENdm5kgy7/Fev89oJjnSiyFqJ17mSqJ0BpceGQ6hSrIpkfXDXUJalH0sxWG7tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dW4R9Dqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dW4R9Dqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFA82C4CEF7;
	Mon, 23 Mar 2026 14:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277365;
	bh=zsynROwYK7ev5IK4DvKbqeb8efjsOLepTKmmvZFm0sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dW4R9Dqd9JbP6A9p6abvkNKpGsY89e6VRDmtoKjjq2dUP9QylBT/0VtOgGJZCesmc
	 N4hh8iewkPhPvZ2/BiYTOwjwvBdQnVCbRXhD/2J7Tmb4DOcUcktdIVazm0bZ+cvgkJ
	 VECAiJy3pzlMGvO//sRDh163ei0IT5PVEZ3HNjsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 411/460] net: airoha: Remove airoha_dev_stop() in airoha_remove()
Date: Mon, 23 Mar 2026 14:46:47 +0100
Message-ID: <20260323134536.651990321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit d4a533ad249e9fbdc2d0633f2ddd60a5b3a9a4ca ]

Do not run airoha_dev_stop routine explicitly in airoha_remove()
since ndo_stop() callback is already executed by unregister_netdev() in
__dev_close_many routine if necessary and, doing so, we will end up causing
an underflow in the qdma users atomic counters. Rely on networking subsystem
to stop the device removing the airoha_eth module.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260313-airoha-remove-ndo_stop-remove-net-v2-1-67542c3ceeca@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index 1dc051749603e..da259c4b03fbf 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -2784,7 +2784,6 @@ static void airoha_remove(struct platform_device *pdev)
 		if (!port)
 			continue;
 
-		airoha_dev_stop(port->dev);
 		unregister_netdev(port->dev);
 	}
 	free_netdev(eth->napi_dev);
-- 
2.51.0



