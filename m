Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1BD3B6377;
	Wed, 30 Sep 2026 18:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794306; cv=none; b=F32TP4HFg5r945GWfX0MrbSFpIUHUO54ykOpmM6U/uCgfR5Ao7buRCrTZ+RmEOlETDwtRlSbcn0jmoi1x8v/Zm2UHFm8s/QqiJr93Ge8k5lZlXdMtk/W1a62qE9/5vYYY+WeLpTUBL2cE3qrUD7m0shQqRLySBt9RdYlVuSAG0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794306; c=relaxed/simple;
	bh=goP8ax1sjif3veGKGwrfC3W8nZiIP+dPS5440FYotTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keMZ7ve8QVa04HSsN0Y113/4PzkSbZvJFZXXziNfxXQV7J9e5VQJ5RoQGBHmB2gBs130+fCXv7ZJuyai68btmHILpqK6cdT/N4AoNRg0ThdZ7QVi2r8wRXvXaVsXv+9hQ2Q3C07fJX72kYbHZDZJ7bjRMwV8bUWqm0Vj2DRHXjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km9dTCWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km9dTCWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766FE1F000FF;
	Wed, 30 Sep 2026 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794305;
	bh=OmiIbfPzVdCYkG00E7l9UJkGSRcyuYDDoUFhqMk6KZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=km9dTCWtdJjV5OoySCZggwYWxtWrfWQRNbl2vDqapdMEaTTJYQ7w6hNoeUZ5XMh0q
	 JdlhBw4QcCplc39HDc9BWJBJi35T8TrlEoGUkssypp+tzBcKwJ89kh0ms3zA+311pA
	 YFv1xMOrgcpmTUiOLrKqvJG417jBQzVt40wAUH0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0165/1193] net: dsa: sja1105: flower: reject cross-chip redirect
Date: Wed, 30 Sep 2026 17:14:09 +0200
Message-ID: <20260930152437.861627294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 9e8ca182c722b..de12bb6a16354 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -388,9 +388,9 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
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



