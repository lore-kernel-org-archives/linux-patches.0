Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A6A22DF80;
	Mon, 10 Mar 2025 17:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628107; cv=none; b=QL+xGhFEjE4qGg9VrBT5nQhqbRjJde4RFyM5F2KgXn4zZm1n0rBtz5l2IsrjCADTAhZ+v1eE1bxnPsBcx8eoJYpOQUCTXDBj8yekDgnTwDZc+vCpDs9J+lShcTSEP2fTohnwUdjGzqJVGpTpZtDLqbq5PaKS4LjWFanSmPaRqFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628107; c=relaxed/simple;
	bh=Jsfm9S5JhEWUSj+9OFH4I0+eDpMkXJUSf5tI0C3UxwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzYFd2ZkkdISMBWudAK64djJMgqdsHGUnVIHulRJlsEHJbzS9zQOXvyXwycwfsKi11aYb7NCdgzfQYwOyYHKQA+oSH6WId8Sxj9z4z0LG6ooXtwGal7nMBmXhIFEcufS5Z7vKlSZtNtpsHjwNG6SIfhTZlhpKAKNaKCMi6OoYMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WsvDe5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WsvDe5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86968C4CEED;
	Mon, 10 Mar 2025 17:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628106;
	bh=Jsfm9S5JhEWUSj+9OFH4I0+eDpMkXJUSf5tI0C3UxwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2WsvDe5TP4PmuQFFBx/Rsr/OxnBQbckdTUH6aBYnD2KfmWm/pG3t+pkEJ1Mq46N/a
	 4wPWfFA8NB7lcCDTX9VA7/fBZ67s6tI9/VGC/mgfBCn1LkM+VHtSxe4yqsSxzVIflA
	 LxsMI278z2znL94H29pfj1EDXRtEvg67D75XMz5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/145] net: ipv6: fix dst ref loop in ila lwtunnel
Date: Mon, 10 Mar 2025 18:06:23 +0100
Message-ID: <20250310170438.348294077@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 0e7633d7b95b67f1758aea19f8e85621c5f506a3 ]

This patch follows commit 92191dd10730 ("net: ipv6: fix dst ref loops in
rpl, seg6 and ioam6 lwtunnels") and, on a second thought, the same patch
is also needed for ila (even though the config that triggered the issue
was pathological, but still, we don't want that to happen).

Fixes: 79ff2fc31e0f ("ila: Cache a route to translated address")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250304181039.35951-1-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_lwt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index ff7e734e335b0..ac4bcc623603a 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -88,7 +88,8 @@ static int ila_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 		}
 
-		if (ilwt->connected) {
+		/* cache only if we don't create a dst reference loop */
+		if (ilwt->connected && orig_dst->lwtstate != dst->lwtstate) {
 			local_bh_disable();
 			dst_cache_set_ip6(&ilwt->dst_cache, dst, &fl6.saddr);
 			local_bh_enable();
-- 
2.39.5



