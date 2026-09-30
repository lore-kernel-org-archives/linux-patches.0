Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A19D4BD348;
	Wed, 30 Sep 2026 16:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784419; cv=none; b=PfqcdUfb3/bNTm9Lqpp8ZFpGHHw9nZcYM4cTZN5X+MThH6WNLhIQBmCc7baOvbZKJLRpclwX/6IbS9nSy2HRkgGKITMY1WMODvVZl+ym+l6AuCN7T+AfY0fLj39EfmBJnrK/aUoe0CDlbZ/OhGPY0Jln69Gon/e8HvwBiGbun5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784419; c=relaxed/simple;
	bh=c2lc4Rr6NC3QiX438G3VPeT69QnTEg7jXKF+eP8frdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFNNQ+WRbaS3FhqQIlk6wajpmZCwwR9kN1LXzfpO+znpI8ZunX4/+IEseo7355YRLjHY6H1mcJB1kvu9GrGf2qHRXrkzE6m+Cej+UGivWbtXFakm9XcDCGUSrg4y3JC9vE6PS0vaA/dhe/D9he1lNUlBrvy8SSH2M5BjS+0+XLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+DiLDGe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+DiLDGe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67531F00893;
	Wed, 30 Sep 2026 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784414;
	bh=Jyh7pu7PwjY0u1RDrAYayPw8xEKOEwTIVmZ1sTb8Zj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+DiLDGeTzCtDDv7fYTeOkYboVHv0UqhrvxKL3o9wztUMCn/PTO/hgKa68CvGyfHg
	 7UbPvcMp+LgGtfKGRebyx3En0c2PQL2eAFfdpB70PsGmrGA8yfOFOSmk16zvroW62F
	 qTX2+/bgG99GR0H369r2QGkENWLlrCIiCTyEavMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 146/982] net: dsa: sja1105: flower: reject cross-chip redirect
Date: Wed, 30 Sep 2026 17:14:42 +0200
Message-ID: <20260930152419.953270219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fad5afe3819cc..23cc263085a8b 100644
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



