Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D9923E358;
	Wed, 28 Jan 2026 15:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614410; cv=none; b=mQsm1w4CcQC5+HUiouKy5ApTsic/qGz059rCDa1YqU0qjvPTaKQdtlgv1J7L0k46bginACRUju/Qp2J3YBaH75dyu9Dg2Hg07fQYTJOfj965WHncj7wUeU0tadzBWJG8ezcY+3vLciBc0iTkPYw2oGOWFJhYjJO+c999r43rw2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614410; c=relaxed/simple;
	bh=hDex9PaA4SY6YReo+5nAA6gKJ7BpSH1NYpVUgyyhU+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/oEloJoWSPm2CXsqUxue63NFPKOPK+4wgnPt3mEipMcih8v45L0z5LohO01VkQah2ETAy6Fy4geBh/Z2HLjRcLuWpH761N58dsAAlCE388V3LwpxYwK7CRaiHrqWF9vFvwHx4y5DJNEjyPoes0+hEW2Ovx4yYLKGEAuWBYnuzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ou0eL/XK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ou0eL/XK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241C0C4CEF1;
	Wed, 28 Jan 2026 15:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614410;
	bh=hDex9PaA4SY6YReo+5nAA6gKJ7BpSH1NYpVUgyyhU+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ou0eL/XKkF+7bMTE4CZvYyqPSjNrOEwN7oVusb+LQD4GskwDHBdjqPD1X0YFvU8B3
	 89NDLICY3/K/5cgkxjshFO+/wcR9fdWLeqE4LPg9ux+dMH4x3z71KQblqbn7gHG1l4
	 gkljaweVsh3I35ZkGIytHlUhxDaMAnnNYXh8XXuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/254] fou: Dont allow 0 for FOU_ATTR_IPPROTO.
Date: Wed, 28 Jan 2026 16:21:43 +0100
Message-ID: <20260128145349.390771337@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 7a9bc9e3f42391e4c187e099263cf7a1c4b69ff5 ]

fou_udp_recv() has the same problem mentioned in the previous
patch.

If FOU_ATTR_IPPROTO is set to 0, skb is not freed by
fou_udp_recv() nor "resubmit"-ted in ip_protocol_deliver_rcu().

Let's forbid 0 for FOU_ATTR_IPPROTO.

Fixes: 23461551c0062 ("fou: Support for foo-over-udp RX path")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260115172533.693652-4-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/netlink/specs/fou.yaml | 2 ++
 net/ipv4/fou_nl.c                    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
index 0af5ab842c04d..91721ee406413 100644
--- a/Documentation/netlink/specs/fou.yaml
+++ b/Documentation/netlink/specs/fou.yaml
@@ -39,6 +39,8 @@ attribute-sets:
       -
         name: ipproto
         type: u8
+        checks:
+          min: 1
       -
         name: type
         type: u8
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
index 98b90107b5abc..bbd955f4c9d19 100644
--- a/net/ipv4/fou_nl.c
+++ b/net/ipv4/fou_nl.c
@@ -14,7 +14,7 @@
 const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1] = {
 	[FOU_ATTR_PORT] = { .type = NLA_U16, },
 	[FOU_ATTR_AF] = { .type = NLA_U8, },
-	[FOU_ATTR_IPPROTO] = { .type = NLA_U8, },
+	[FOU_ATTR_IPPROTO] = NLA_POLICY_MIN(NLA_U8, 1),
 	[FOU_ATTR_TYPE] = { .type = NLA_U8, },
 	[FOU_ATTR_REMCSUM_NOPARTIAL] = { .type = NLA_FLAG, },
 	[FOU_ATTR_LOCAL_V4] = { .type = NLA_U32, },
-- 
2.51.0



