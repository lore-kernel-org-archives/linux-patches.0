Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578B0258EF9;
	Wed, 25 Feb 2026 01:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983528; cv=none; b=GqBuKtUyuEX+aHEqHtWFWvUx0mOzrDtlQWy/RbfyPU9FKeU8nyEfZvayIK8kbsDSyP2jwkM5hzZoqqttVHsJ/RspmUm1BxqBAUiY6HZmotSq653ebYLKR5SnkPE//nOa/QObKgleGcpH0LfPZOMInWSb03oVPHrCVkWqKgDeYBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983528; c=relaxed/simple;
	bh=x0AyCp0XFOu9pVpmuI7Igy5qohLHZiaYDso6sZOMIW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tZYNt2PY0YOB5/bTfyDPfSSpmgJuzR12lQ3rqNDgvp2X5ql//cDX9FvocWGDpH+uzq7KnGxPeoNRFHHj7a/UhrLo8OmA57paIuDqltyXjwu6WdF8ouzKbNQbcvn4tmBpKtTXiPFB1lpXsMMjsWsOm8Ch7Y6eUq8nU8kzFRBdjOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxntZygA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxntZygA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175B8C116D0;
	Wed, 25 Feb 2026 01:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983528;
	bh=x0AyCp0XFOu9pVpmuI7Igy5qohLHZiaYDso6sZOMIW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxntZygAq4lmw5XFwW67PBf9RpOqyX4H0I6Z3+QpCSV+8uXaNu8Hmts33z2Zq4A54
	 8Ssk6NDk3W388e1UXR5In0fQjk7LVFC1FoASuyuQXtq3rUfPAl3Q+WSUwxn08+BF0q
	 4drmPpR30RYjQljCZJk6Bzks93/8OIboHjiWMCa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 635/781] net: mctp: ensure our nlmsg responses are initialised
Date: Tue, 24 Feb 2026 17:22:24 -0800
Message-ID: <20260225012415.382185816@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/device.c | 1 +
 net/mctp/neigh.c  | 1 +
 net/mctp/route.c  | 1 +
 3 files changed, 3 insertions(+)

diff --git a/net/mctp/device.c b/net/mctp/device.c
index 4d404edd7446e..04c5570bacff6 100644
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
index 05b899f22d902..fc85f0e693014 100644
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
index 2ac4011a953ff..ecbbe4beb2133 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1643,6 +1643,7 @@ static int mctp_fill_rtinfo(struct sk_buff *skb, struct mctp_route *rt,
 		return -EMSGSIZE;
 
 	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
 	hdr->rtm_family = AF_MCTP;
 
 	/* we use the _len fields as a number of EIDs, rather than
-- 
2.51.0



