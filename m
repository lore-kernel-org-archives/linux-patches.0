Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042288;
	b=W7HUkze/nzciytlQi6fVtp0NMRxVD7btl0fZ+Kh1TXVETRdS9zdyRTasw0K8bjvhKJjR
	 MD+VumLWdeul443/XdUHt+WNOg0ceab4Aj40HqWli6fadThciSOB86rRqA5zt8qcIw8ss
	 BP42dMahnwFQAI8ir/pLB/vcM0dtMM3f4WciQgA1W2wJnJHYbrQvmu32Yurp7oyQyDDQz
	 /yNUU9PJrzgeN458NYLwYo0i5i55OM/5VxdPKVil42lgktb3ugaVDKMBnn+5Vfpy9gnKF
	 ufWZQZR+f+OJodLD1/CbOxIy3SogL0UaUFbSNiSqUD5TtXOknd/7RV7WeYe6O22ekvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042288;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=388b0s1QVUrDfL1SxWIiJ7fjnPAir1i10yE0exde5VU=;
	b=QcCSGWtKSrbGN8YOPzXAF83XwTw4ygk9sEick94mqIfhVzWpa2wvqq5ewnYOndaQnaFy
	 TRLS2E5grNoQCZzt5jyxTVr/o109hymKknHEgyLNiTO8VPFX6rB2LR1IooX33DgsRROEZ
	 FSDnU8NrBCa75xV8Xk/sHHLRVrX4mVROfnsgYc/sc937Vlv/3N8B2CprX/vQDodmJ5a03
	 lNUHUo5LNjcuqcPc4fx/zBjNSBITa6VYsCyC8R2l76niQCCwDnb0PBcD0q0Ms0IvNse4B
	 TwoKBEwEKJp6VocHHQ+v8tFSvCoYOpqay8swZtmTa/fO3SKg7Slhgvpqpx3PXMeZ+eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T0/DG1v4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BAC606A325;
	Wed, 18 Nov 2026 22:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T0/DG1v4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7461F000C4;
	Wed, 18 Nov 2026 22:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042288;
	bh=388b0s1QVUrDfL1SxWIiJ7fjnPAir1i10yE0exde5VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T0/DG1v4Mhr7zs70rmbesJATrGo+jw+jOvlf3LC59MopeyxSY09WWebmAhdXdfTHB
	 KWHndbjvF6QyY+hZQn8Q3nEeXZl8cKRUwnm7Qr/MlokE614FsaUxQ/7xoKOumiEsw1
	 mHYaUCsqvimBcqrx5gMh61F5Udsx0U5CEldxva3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3076/3318] net: bcmasp: fix OF node reference leak for phy_dn
Date: Wed, 18 Nov 2026 16:01:38 +0100
Message-ID: <20261118150452.366341735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit a31623d91c6e48b08c74dc95567aeb62f1f35938 ]

In bcmasp_interface_create(), intf->phy_dn is obtained via
of_parse_phandle() or assigned ndev_dn. of_parse_phandle() returns a
node reference with its refcount incremented, but of_node_put() was
never called on intf->phy_dn in bcmasp_interface_destroy() or the
error unwind path in bcmasp_interface_create().

Acquire a reference on ndev_dn for the fixed-link case as well so that
intf->phy_dn consistently holds a reference, and release it with
of_node_put() on teardown and error.

Fixes: 490cb412007d ("net: bcmasp: Add support for ASP2.0 Ethernet controller")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Justin Chen <justin.chen@broadcom.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20261013204439.3494046-5-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
index 4a795ffc7f00f..4e9fa6463831a 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_intf.c
@@ -1272,7 +1272,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 				 ndev_dn->name);
 			goto err_free_netdev;
 		}
-		intf->phy_dn = ndev_dn;
+		intf->phy_dn = of_node_get(ndev_dn);
 	}
 
 	/* Map resource */
@@ -1311,6 +1311,7 @@ struct bcmasp_intf *bcmasp_interface_create(struct bcmasp_priv *priv,
 err_deregister_fixed_link:
 	if (of_phy_is_fixed_link(ndev_dn))
 		of_phy_deregister_fixed_link(ndev_dn);
+	of_node_put(intf->phy_dn);
 err_free_netdev:
 	free_netdev(ndev);
 err:
@@ -1323,6 +1324,7 @@ void bcmasp_interface_destroy(struct bcmasp_intf *intf)
 		unregister_netdev(intf->ndev);
 	if (of_phy_is_fixed_link(intf->ndev_dn))
 		of_phy_deregister_fixed_link(intf->ndev_dn);
+	of_node_put(intf->phy_dn);
 	free_netdev(intf->ndev);
 }
 
-- 
2.53.0



