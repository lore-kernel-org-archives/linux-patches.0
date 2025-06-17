Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4859A2FA630;
	Tue, 17 Jun 2025 16:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179069; cv=none; b=Olm6qYGr+YoCRPbJaX6z3LkyjUaGHz6khTTGeps4Ju+zDeVY7FEjp54S5/7YqZxoz5AtOwweNxkVjdEiV488EjYtHJTItTnhc4Jiyx00x63qpbtv+JwAAB4U+gdDx1iJYemKqB49fxuxp6d68sIulmhlTkHcHdr0r55WTw0k3+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179069; c=relaxed/simple;
	bh=JTOyCf+9+8hMlEVzdX98j5QS6JN9YziXOqO1KYA2HB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bwbuSnge+fQjwQD3+0YZtnMA1+LMHrlOHTDV4f3aaDPQF/yP8A2gJlN5U+6wwXafHO/k1pX6gNkaWsBZrgjviQiBXWzc6maoYFjmOSPqhVVGFMMjCLTFLxHmheGvVNNQqrw6Dsnz0+lnf8UZD1lZ1raGhgCZ+YHF3O43MOLiZtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onAlcYzf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onAlcYzf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0529C4CEE3;
	Tue, 17 Jun 2025 16:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179069;
	bh=JTOyCf+9+8hMlEVzdX98j5QS6JN9YziXOqO1KYA2HB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onAlcYzf/yVwhhBAQ8wdAStZDE1l1x8WaIzV9NKDTGRH9F0UVUaRzb63TuhSCLVzD
	 c04KlKppPWBRPGy0Rafu6w6v3yKzr52AFnUnKKRD6kJ+M9lGdG5hiNl6NWXRWR8yKj
	 Eoff64Yxo15/5napEfwpWCVM77KsmyUX1TFO+Yw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 610/780] net: dsa: b53: do not enable EEE on bcm63xx
Date: Tue, 17 Jun 2025 17:25:18 +0200
Message-ID: <20250617152516.323238812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 1237c2d4a8db79dfd4369bff6930b0e385ed7d5c ]

BCM63xx internal switches do not support EEE, but provide multiple RGMII
ports where external PHYs may be connected. If one of these PHYs are EEE
capable, we may try to enable EEE for the MACs, which then hangs the
system on access of the (non-existent) EEE registers.

Fix this by checking if the switch actually supports EEE before
attempting to configure it.

Fixes: 22256b0afb12 ("net: dsa: b53: Move EEE functions to b53")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Link: https://patch.msgid.link/20250602193953.1010487-2-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 7216eb8f94936..a316f8c01d0a9 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2348,6 +2348,9 @@ int b53_eee_init(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
 	int ret;
 
+	if (!b53_support_eee(ds, port))
+		return 0;
+
 	ret = phy_init_eee(phy, false);
 	if (ret)
 		return 0;
@@ -2362,7 +2365,7 @@ bool b53_support_eee(struct dsa_switch *ds, int port)
 {
 	struct b53_device *dev = ds->priv;
 
-	return !is5325(dev) && !is5365(dev);
+	return !is5325(dev) && !is5365(dev) && !is63xx(dev);
 }
 EXPORT_SYMBOL(b53_support_eee);
 
-- 
2.39.5



