Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD05330678;
	Wed, 21 Jan 2026 18:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019502; cv=none; b=nQTo1zsfZuChQlNkSSOSJ7BsmeMVcuOHCzrxYgBshULfs8QIfIkRF6JFiGuEvmIk0opjV2y+1lQIUjEkXYg1DDhm5bp0Wbtat34k6RSNjmqOXfOEF5s9zvEDgpy9fZ8ZklZjnO8qhnfSO+DPV6wRXdt1JwVfCNnUl9JBYbb60zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019502; c=relaxed/simple;
	bh=l1beMKZ7bZrlEdInb/8dBNgZC2FNZRmzcP0om72px5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uarE3fe618lVvKRoTBDYn3ySvEsL7C9obbmj33sNi562NAQIdlsNfIPZaPVy9LvpJGWE9Jt3baPIPZOIBwsO1f4l22f96sd+jFVtPzmkkNARVG9bxQ+9Tv0pLqN2XdEJC0qqebwO0XTZmX5Sx78rKIIHB5fckie/vfEVCmhcNAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdrDg+uW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdrDg+uW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85600C16AAE;
	Wed, 21 Jan 2026 18:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019502;
	bh=l1beMKZ7bZrlEdInb/8dBNgZC2FNZRmzcP0om72px5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdrDg+uWNKovY7S9Zit8HcCtEYiV2t+fIgRPDZqNOq78aQdYHBRFAs03e1baHMJip
	 lBK9G391SiTIRDtpQj4odoep3Wf1Ip5BsGSBHrTbR+wq0TRadbdIMXorOZe9uP9mdY
	 62k3AsJulG+TDSDffjbXgl5ZmYZiml/2GN0YEKuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/139] xfrm: set ipv4 no_pmtu_disc flag only on output sa when direction is set
Date: Wed, 21 Jan 2026 19:14:15 +0100
Message-ID: <20260121181411.723261722@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit c196def07bbc6e8306d7a274433913444b0db20a ]

The XFRM_STATE_NOPMTUDISC flag is only meaningful for output SAs, but
it was being applied regardless of the SA direction when the sysctl
ip_no_pmtu_disc is enabled. This can unintentionally affect input SAs.

Limit setting XFRM_STATE_NOPMTUDISC to output SAs when the SA direction
is configured.

Closes: https://github.com/strongswan/strongswan/issues/2946
Fixes: a4a87fa4e96c ("xfrm: Add Direction to the SA in or out")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index b9bac68364527..c927560a77316 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -3058,6 +3058,7 @@ int __xfrm_init_state(struct xfrm_state *x, bool init_replay, bool offload,
 	int err;
 
 	if (family == AF_INET &&
+	    (!x->dir || x->dir == XFRM_SA_DIR_OUT) &&
 	    READ_ONCE(xs_net(x)->ipv4.sysctl_ip_no_pmtu_disc))
 		x->props.flags |= XFRM_STATE_NOPMTUDISC;
 
-- 
2.51.0



