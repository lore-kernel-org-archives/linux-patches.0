Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D92A28CF62;
	Wed, 23 Apr 2025 15:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421882; cv=none; b=etgt4TjiuL27mhwyMSpSsno5TRVYQ/JORIO/vAqsQVRRsgdL8yEoc3bCL6kYBaJcdy+WjEyRxn+vWekhcj9YbeZQqVirG0WqUHfq3Feai1FHE/o83yfUjGA5q0eUR8Q0VM3QldXaDvJhHzNG6hpDtterBLcaG20og/ua8KZrAhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421882; c=relaxed/simple;
	bh=N+YOtuQfXFb4WsfGMNxksB6FZCXBiWmfMpfWojXiJsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOt/xrExB2GSFQ4jCvzIp1su5KPqOtdGtnFNuvSZUUYY/5nMZ+CO3Qa1+uqXiqeJIwi7ldUucYDETxP560jXgvY36pxSroBgi51r0nhCG67L0GEVUBqKd6FymEXH2jlfYJRynIPf/xGlQ04N/clcpIfynFlkLFB7aisUeTBI6sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YubKMR8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YubKMR8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDF3C4CEE2;
	Wed, 23 Apr 2025 15:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421881;
	bh=N+YOtuQfXFb4WsfGMNxksB6FZCXBiWmfMpfWojXiJsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YubKMR8ZDMUhDK1rSvoKbPwtPX5Bf5SfFzJ1/eZyT9HIfC9M9a1x7i1EdQaZFaq3i
	 72Wo/6VhwYrfBCaQBQdpNkBoen61ppLKa8MuQOKFeS+h2mGdlrI/jW7QLwBG+iZEoi
	 vtLSmBVeNVG6CPEgIHDi9wA++cRo0qKnemXUg3Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/291] net: dsa: avoid refcount warnings when ds->ops->tag_8021q_vlan_del() fails
Date: Wed, 23 Apr 2025 16:43:01 +0200
Message-ID: <20250423142632.230251208@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 89371b16416e2..6a33f35a0f748 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -180,7 +180,7 @@ static int dsa_port_do_tag_8021q_vlan_del(struct dsa_port *dp, u16 vid)
 
 	err = ds->ops->tag_8021q_vlan_del(ds, port, vid);
 	if (err) {
-		refcount_inc(&v->refcount);
+		refcount_set(&v->refcount, 1);
 		return err;
 	}
 
-- 
2.39.5



