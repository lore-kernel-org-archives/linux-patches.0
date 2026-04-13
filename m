Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1098730F52B;
	Mon, 13 Apr 2026 16:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097381; cv=none; b=j6Ek+1htsO8skR20qGu4q1eyKRGBFyD4QAtROCJHzqvTLGn4Lrh3KRKhHBehdV6cwhprnbYUIzBvb/fPrqltqMT4l0Ff4E+uYb6Qe1iF6mX+K6ZnhPcuDeHrKOMdnwy7SqCAzWCUnDdHRROZCGLwng3MTjPIGnxTf1SIDf4ngXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097381; c=relaxed/simple;
	bh=iyxEBCwEmmuB3SENLAVbkB/zRR2av/FeA6uj7J4ljMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ennq8hI+2GytQhGxmi/ly4aCqv63H4X0jlFyskp6pZuR1AVhUpnO0ridJByTQjuc5HfsCfdQfsU7WK6j99cq/oOFso6bQWGywgT3OzU3ypqDEZ9y73sWBuFRs9WuJCTdKGVO61yUHcmpyRANM90rRXyPcUf8EJvV/0wMqiS8aDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vq8n4W6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vq8n4W6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D29C2BCB0;
	Mon, 13 Apr 2026 16:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097380;
	bh=iyxEBCwEmmuB3SENLAVbkB/zRR2av/FeA6uj7J4ljMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vq8n4W6zh+/c+s6E5rsXy+qlLWu6DVACBQuhmIu/cTbUHObKxFEGCg1Ak0SofJ6Q3
	 G7wdzihp9pWdU3YM4gZ16r1lxlruGnKZXqP2WwDX5V2HYxnvyntN6OHNWmy3X/8mHD
	 pe7uTLJ+vkwtSdttuPhV4cCx7sfdKqO1GeZ82dBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Dull <monderasdor@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/570] netfilter: x_tables: guard option walkers against 1-byte tail reads
Date: Mon, 13 Apr 2026 17:54:05 +0200
Message-ID: <20260413155834.714088119@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Dull <monderasdor@gmail.com>

[ Upstream commit cfe770220ac2dbd3e104c6b45094037455da81d4 ]

When the last byte of options is a non-single-byte option kind, walkers
that advance with i += op[i + 1] ? : 1 can read op[i + 1] past the end
of the option area.

Add an explicit i == optlen - 1 check before dereferencing op[i + 1]
in xt_tcpudp and xt_dccp option walkers.

Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables")
Signed-off-by: David Dull <monderasdor@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_dccp.c   | 4 ++--
 net/netfilter/xt_tcpudp.c | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index e5a13ecbe67a0..037ab93e25d0a 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -62,10 +62,10 @@ dccp_find_option(u_int8_t option,
 			return true;
 		}
 
-		if (op[i] < 2)
+		if (op[i] < 2 || i == optlen - 1)
 			i++;
 		else
-			i += op[i+1]?:1;
+			i += op[i + 1] ? : 1;
 	}
 
 	spin_unlock_bh(&dccp_buflock);
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 11ec2abf0c727..73f50dc01b19f 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -56,8 +56,10 @@ tcp_find_option(u_int8_t option,
 
 	for (i = 0; i < optlen; ) {
 		if (op[i] == option) return !invert;
-		if (op[i] < 2) i++;
-		else i += op[i+1]?:1;
+		if (op[i] < 2 || i == optlen - 1)
+			i++;
+		else
+			i += op[i + 1] ? : 1;
 	}
 
 	return invert;
-- 
2.51.0



