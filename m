Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A312833B945;
	Mon, 20 Apr 2026 15:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700217; cv=none; b=iJsyMWgiPZsJp4LgInv+EmvWOjwOwF7JlRaXw7Tc7Mo+B+yf8CESpjo9mUzzkSriCc9Jzlo5bJK3EmVav7Rt0+IcJQH/YHE4wOWxJF1RFcavkvq86arI4fPBd+S3cPpcEDCOq01mWfpaqLjqM6e154YeDWkV07QaamVrHvejlm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700217; c=relaxed/simple;
	bh=S+VacZNsUveTlql97uPJwuS93ldpcVF/EvLSgLl2Pns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=savl1B265MbPHeffIgrU2sLaBj0Cz3lDKRygBncBaRZfDYd+KxK7CabZ0rPLqGNaA/pViqqmKdJhPDQ44qus3Q9cL2h0esa8j0k3j3313IefGTsflOhvrTwdSSImaWT7UiGHvSoZNFviDzKS5ORSgk0juPtoZTCpgJoBvjUNvnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMlHugu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMlHugu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3888FC19425;
	Mon, 20 Apr 2026 15:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700217;
	bh=S+VacZNsUveTlql97uPJwuS93ldpcVF/EvLSgLl2Pns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMlHugu2u3LGg70yIwR4bbLtXwc5HpgMOki8Ov3ltoCJitrM8W6epRaSan9khGF8N
	 cDYFO1GgXDxlnmUstMSUmmg0E9WVJoxFSnxWXyOnXiLQa49rE3RDuge7YNhh6LsLJ8
	 Wk8cNFov2BdRh8uyAPalgW1/K+lLGiRlP//7xPTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris J Arges <carges@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 087/220] net: increase IP_TUNNEL_RECURSION_LIMIT to 5
Date: Mon, 20 Apr 2026 17:40:28 +0200
Message-ID: <20260420153937.169458273@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

From: Chris J Arges <carges@cloudflare.com>

[ Upstream commit 77facb35227c421467cdb49268de433168c2dcef ]

In configurations with multiple tunnel layers and MPLS lwtunnel routing, a
single tunnel hop can increment the counter beyond this limit. This causes
packets to be dropped with the "Dead loop on virtual device" message even
when a routing loop doesn't exist.

Increase IP_TUNNEL_RECURSION_LIMIT from 4 to 5 to handle this use-case.

Fixes: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Link: https://lore.kernel.org/netdev/88deb91b-ef1b-403c-8eeb-0f971f27e34f@redhat.com/
Signed-off-by: Chris J Arges <carges@cloudflare.com>
Link: https://patch.msgid.link/20260402222401.3408368-1-carges@cloudflare.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_tunnels.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 1f577a4f8ce9b..d708b66e55cda 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -32,7 +32,7 @@
  * recursion involves route lookups and full IP output, consuming much
  * more stack per level, so a lower limit is needed.
  */
-#define IP_TUNNEL_RECURSION_LIMIT	4
+#define IP_TUNNEL_RECURSION_LIMIT	5
 
 /* Keep error state on tunnel for 30 sec */
 #define IPTUNNEL_ERR_TIMEO	(30*HZ)
-- 
2.53.0



