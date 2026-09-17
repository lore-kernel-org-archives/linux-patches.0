Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DF64F93D6;
	Thu, 17 Sep 2026 17:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667914; cv=none; b=FaE1M8Lz1lMHv8JhRhWk4dAIDt4ppATR2e1tj/469gloiHz/0I1C3pyFrfVHJH5V0XNd3E0wEn95NC3pzjDs4e73lxogM9ik3M4RbV65YdjzO1qhlNdlvkskDjRYaOWt+vvm3YIn3zwlkAlqErteIPIkljI0AaU+DpgDIaZyIJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667914; c=relaxed/simple;
	bh=4sDYllvLPotaQkumrkPEbQFHmbpKSWPUEM+cHEqU8RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uc126BErSjlELqzw3tAjG26XHh9G9GA40Z1xCrmcpKq0OsCzoVogfKtKxiBYDJGiEhKO+MBe0+XVDV/uzbEmu6QWV5gcSjFclmWvuetBk9T7gvIIsoo8fNzyDFpNId8EWeui0rsoSjDmJQLBC96hM3vfoOUo1kavkazLsj7ojxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9H4zvX7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9H4zvX7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC871F000FF;
	Thu, 17 Sep 2026 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667913;
	bh=bdhTQh+KETSHcyKhhplgRtQH5pNhaNkq/huzDGCENLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9H4zvX74hmicY+Fk+fRpVUbss3vTxY9uxrn0pwkRxOs0iTZ76KXmMiSVGdk2C037
	 +pyiuz7Wb0BZI8Vlay/YDNT+WWSHoxdlCBEdyOlDjBBWXPLhWMRdxhbxxG/l4RuTJ2
	 BWFdOPnGVuBCGUZerxxEf7Ts9s93z8s8F43erlL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0215/1102] net: dsa: sja1105: flower: reject cross-chip redirect
Date: Thu, 17 Sep 2026 16:02:38 +0100
Message-ID: <20260917151544.975782982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit cfa5274a5dc2a23b957da5dc806d2ac0c7a66af0 ]

dsa_port_from_netdev() may return a valid port from a different switch
chip. Programming another chip's port index into the local hardware
causes redirection to the wrong port, or an out-of-bounds access if the
index exceeds the local chip's port count.

Apply a minimal fix that adds a check to catch this case and adjusts the
extack message. When cls->common.skip_sw is not set, the operation could
instead redirect to the upstream port and let the software or upstream
switch(es) handle the forward, but that is not addressed here.

Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260530003940.2000994-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/sja1105/sja1105_flower.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 05d8ed3121e7f..172fc163e1850 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -391,9 +391,9 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			struct dsa_port *to_dp;
 
 			to_dp = dsa_port_from_netdev(act->dev);
-			if (IS_ERR(to_dp)) {
+			if (IS_ERR(to_dp) || to_dp->ds != ds) {
 				NL_SET_ERR_MSG_MOD(extack,
-						   "Destination not a switch port");
+						   "Destination not a local switch port");
 				return -EOPNOTSUPP;
 			}
 
-- 
2.53.0



