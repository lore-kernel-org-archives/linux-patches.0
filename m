Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96AF36E470;
	Tue, 16 Jun 2026 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622521; cv=none; b=a+d4VZXV4TOj+3Bk3jTJVj5Sm/vgshqvbZYSH0X+6ULE50JWSZdYlzbnXFEnKGZvLwcFKjwyMUkdqUStb1um107eHfH6cPgVFl2Bp3wHO9HUk0IGNco2BGSZKyWYa+tN8iLizinYEMTlLCsqAp9bYpdW+y4Ecur1b1+d6NOg6ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622521; c=relaxed/simple;
	bh=R4UowT8JccGuMcoQ+iA7msaUPlvCVDH4LyjpiYNyzeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/d8mxAnbcurPA1LWGLPjCfDY3IGyJ9DNkPwHm+wDYV1V6N6KxoN60M9BQx6Q+eb4O9Ke1OuPuCwfBipuy8/izB6D3lrv3MaUB8rVpAoO6RILjtisUj4quuJKm2T9WQg9S00OcBf0OWAG56Sk5i7MPGzfYPfvoEiPHVPSgpwY5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HOL6mV4E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HOL6mV4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D211F000E9;
	Tue, 16 Jun 2026 15:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622520;
	bh=lKtiU30No4okjl7JHBIsK99YO1vC/d/SgJf7AKgDhF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HOL6mV4Ej5666txsO72aka8MUvkdXS4cllI1Ja3izdjt30SqrRR0B1OQ3gkArq30Q
	 VV2BLchrbxowLDllCxnUotYxr49l4XXKVS3iQaTHXw1RYddcGFDqBiT3QCIp9aHAIW
	 sGK8sBHkSyqsT00N7XNe9WSm11068paIG3RMVUfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Li hongliang <1468888505@139.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/452] net: mctp: ensure our nlmsg responses are initialised
Date: Tue, 16 Jun 2026 20:23:50 +0530
Message-ID: <20260616145117.976025220@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
index a565cf2bc7330d..6d6e19c049396f 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1332,6 +1332,7 @@ static int mctp_fill_rtinfo(struct sk_buff *skb, struct mctp_route *rt,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->rtm_family = AF_MCTP;
 
 	/* we use the _len fields as a number of EIDs, rather than
-- 
2.53.0



