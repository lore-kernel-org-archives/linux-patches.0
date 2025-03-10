Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5333C17CA12;
	Mon, 10 Mar 2025 17:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626888; cv=none; b=QpPtg2Eoub9cQwNXZwLfdmw6OgZJ9uI7YdYfTU477uzyZvD/7Tnk0YVEeQlwgGPxmSIrd4bzQ5jMy+MneqyBikI4kH74u3ppzhQs0KgSKzfU4f2o7SASRrhhKbnyY4VDlWn3L8oQDYd/WyRsW9fEOa3+AVUZ7CZUUW4cJKHCeh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626888; c=relaxed/simple;
	bh=LBLfJftY2BbzJ/SgKj7cChLxW6wjYL/B9fURMYB9zik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFUG3qMXAigx7otCTVSRXUsgrQYwRzo17RvJDiMAzhnCCLp3h0fuQb4nqg1bH7FAVu4XQHvtBw9mPZZ8B9uwU4NUbBDNw86wbTSljHJPAg1G3U13h3z241KF2YxrRGPMENyBpd8YqtK9+3kfwG9njZQkUIhMXcxhUYDZ4FAQLTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl3yrfdd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl3yrfdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C880DC4CEE5;
	Mon, 10 Mar 2025 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626888;
	bh=LBLfJftY2BbzJ/SgKj7cChLxW6wjYL/B9fURMYB9zik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl3yrfdd6ukFYbf0fNTNY080JPc1QDAwyruZKGgsLgpVu+MUlE3bk1BUyWk67hRXy
	 /lzQn61LoL1FTKyAv5zfeOGUChDCRmrznWetdHM/WqqiNtue2jMvoJtnYWrL+sWQp3
	 XeyOzlRHY4lNaZOdH77OcRNlJ/cdIZGzEtkkTDb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 148/207] net: ipv6: fix dst ref loop in ila lwtunnel
Date: Mon, 10 Mar 2025 18:05:41 +0100
Message-ID: <20250310170453.680174092@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



