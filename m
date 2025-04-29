Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B96AC148;
	Tue, 29 Apr 2025 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948885; cv=none; b=tDQ4OF2MDVhAbzFDD25BcTZNeVai/vAWSDtktJo1oCl24GiyQ+uh94iubBfPgbjtMIMOLNGhE+gfkj9qDRKsod6owbyAO9Onz1KgqNuceF22g2Bs9OIrSyX9bgiVZY074kO7GdoABK7cKwupdnPIoL0ztQrD/TBo7ybDRhzDhn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948885; c=relaxed/simple;
	bh=dV0s4rqVBodU3dL1vZuanY2M6Qkcl9nl2kvOnBNnQQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oddClGr8LuyeW1wz2/3i/k/E8XE/gOf1K93qQ//QN0fgJAIhuecZqkIOclyuRzZ6uhSsuWNCqaOyUgQ8ElaVtM5KlZXqGwiu6EjkU2UjFrz0lOeMyCAVlbmBbpzqueGI5tes5Xsn9mdfMSoVAvOX04Z/Vpai1kHzqor9BcYO1i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZGemiaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZGemiaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200C4C4CEE3;
	Tue, 29 Apr 2025 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948885;
	bh=dV0s4rqVBodU3dL1vZuanY2M6Qkcl9nl2kvOnBNnQQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZGemiaZgo9yT8zYBXjOv4XUzqZDYL81gb90KClXkrN7WyhFxlaynhRYwEJ9PfI+0
	 roWy+g3rwKyASAZgNh1lRgvsHTH59HaudvSfsD/3i70RIYCd0pleodN/QqMnOmANwX
	 NVIcqzhC8KPYtoBL1kYhjKKlt6wvxJ7w295V5xKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/373] net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails
Date: Tue, 29 Apr 2025 18:40:26 +0200
Message-ID: <20250429161129.287211392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 514eff7b0aa1c5eb645ddbb8676ef3e2d88a8b99 ]

This is very similar to the problem and solution from commit
232deb3f9567 ("net: dsa: avoid refcount warnings when
->port_{fdb,mdb}_del returns error"), except for the
dsa_port_do_tag_8021q_vlan_del() operation.

Fixes: c64b9c05045a ("net: dsa: tag_8021q: add proper cross-chip notifier support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250414213020.2959021-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_8021q.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index e443088ab0f65..cc96afc6468de 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -196,7 +196,7 @@ static int dsa_switch_do_tag_8021q_vlan_del(struct dsa_switch *ds, int port,
 
 	err = ds->ops->tag_8021q_vlan_del(ds, port, vid);
 	if (err) {
-		refcount_inc(&v->refcount);
+		refcount_set(&v->refcount, 1);
 		return err;
 	}
 
-- 
2.39.5



