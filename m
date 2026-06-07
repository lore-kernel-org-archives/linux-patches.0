Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F045B1DE8AE;
	Sun,  7 Jun 2026 10:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780826905; cv=none; b=XrW9OxiGiGNc/ulthpk0OjD2/XE10zb2ZWHbefjeZMP760h72YhdaDEpViXkRjAtKb+RdS1DOm0R6Pi3CslyN7a8LEGEaDyPoJ9h5xhSY4pUnC7kC4m81eYD1CVFSxeNuzoC6DUCrABEzo1eqm+A7lP7L645MXIrYZWTWiNCV6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780826905; c=relaxed/simple;
	bh=7+zrtTTn2/iy642pGY42/TYCkJfnOPJIvwQO3Z5jYuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0EGhSbDnlOH57CpL7c/zbndJDOdeLHv3D3BMcBO7TlwOfjvL2RimPudyOELo5D36i6qo3s2iBi+n1pRq0WsDpDfa9aCP+5tjlxqUOeSZ5pH4NgSqb2/vo8HA4DosbbcTLo75AovnsXD1zQc/Ow24VV6iGaq54vGqlzygI4el6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atETCDbq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atETCDbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497F51F00893;
	Sun,  7 Jun 2026 10:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780826903;
	bh=eosu3afRcl15bSR87uhlC3IdEHdi1D7DHa30bmR9+gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=atETCDbqvfN6TgBfEEXSS5js1p8wcN3OZd0OGpCqlPiGu1XkniAwNA4B542i1cSnO
	 xtfNdjmT1op4b0UFYF2sVjkNvGd3Wjx9u6Ax2/7DHUWnNimyI5F5J2lDWk2gSMMaqh
	 zdwV09EpqtHyuuxLUj/evo3jAJaTxlgwekb5R4NI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/307] net: mctp: ensure our nlmsg responses are initialised
Date: Sun,  7 Jun 2026 11:56:42 +0200
Message-ID: <20260607095727.843003200@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit a6a9bc544b675d8b5180f2718ec985ad267b5cbf ]

Syed Faraz Abrar (@farazsth98) from Zellic, and Pumpkin (@u1f383) from
DEVCORE Research Team working with Trend Micro Zero Day Initiative
report that a RTM_GETNEIGH will return uninitalised data in the pad
bytes of the ndmsg data.

Ensure we're initialising the netlink data to zero, in the link, addr
and neigh response messages.

Fixes: 831119f88781 ("mctp: Add neighbour netlink interface")
Fixes: 06d2f4c583a7 ("mctp: Add netlink route management")
Fixes: 583be982d934 ("mctp: Add device handling and netlink interface")
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260209-dev-mctp-nlmsg-v1-1-f1e30c346a43@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 1 +
 net/mctp/neigh.c  | 1 +
 net/mctp/route.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 8d1386601bbe06..67576cb2728ece 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -70,6 +70,7 @@ static int mctp_fill_addrinfo(struct sk_buff *skb,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->ifa_family = AF_MCTP;
 	hdr->ifa_prefixlen = 0;
 	hdr->ifa_flags = 0;
diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index 590f642413e4ef..c0151a69d2b7c2 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -218,6 +218,7 @@ static int mctp_fill_neigh(struct sk_buff *skb, u32 portid, u32 seq, int event,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->ndm_family = AF_MCTP;
 	hdr->ndm_ifindex = dev->ifindex;
 	hdr->ndm_state = 0; // TODO other state bits?
diff --git a/net/mctp/route.c b/net/mctp/route.c
index ccba2abbbbfbcc..35a0681123a33f 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1405,6 +1405,7 @@ static int mctp_fill_rtinfo(struct sk_buff *skb, struct mctp_route *rt,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->rtm_family = AF_MCTP;
 
 	/* we use the _len fields as a number of EIDs, rather than
-- 
2.53.0



