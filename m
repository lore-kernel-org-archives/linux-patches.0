Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7744932BF5D;
	Thu, 28 May 2026 19:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998117; cv=none; b=gp9Xd0/sLNRcaZhzl8XkZ+zzluqCRA/MgepzQVUv0IVoN67qSB/8kUwcKqKWWnHsuM1tpiSj4klx+539SzvEi+3FuTovTax/JN69ae56Z7qpEjVeFRKFtEyWVPmyLC7Y7SO9bVsoliYJWXyRbXyTZAo/I6vYD4SC3PbHXklaTYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998117; c=relaxed/simple;
	bh=Y1e/oaLrOXZIGXBDvms9fSjfkU/WBu3GpgBWKoLaZOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DeDuJghXKtySFqvVz8UYza1oLCzwUkZUtK7oprD7CCVxMJOwnS5qpVnqoWx21lY9/719TOC+SeNTuKjCka+XKXTns2EV6mT0G9yPz/T9raTh375Z6iBqN8DjCMXxlo7vZQQpyEC2uxPRsMTy3euHwoGwRJynaPemj181+G7w+X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=npZQLTL7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="npZQLTL7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721BF1F000E9;
	Thu, 28 May 2026 19:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998115;
	bh=qmqulZDV2qDz+eAWFFFWkfgaKoSlDM+KIYP++Pfra2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=npZQLTL7AuN/5UOvjwVGdSBJkWcJ5NrJzi092J11ckc0MoM8eB2Wb+eMlxZ2bpPvz
	 VTDfdB7wRVxW+O8rHCz1wV4LBSa+Je8iLFp5B5IPqxwcGPaIxWQojVyD4JbvgqKlCP
	 kLFKRTphHY8kmyVRGkplei+hElLEBOzkIGrL86dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Nan Li <tonanli66@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.0 059/461] netfilter: ipset: stop hash:* range iteration at end
Date: Thu, 28 May 2026 21:43:08 +0200
Message-ID: <20260528194648.621118893@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nan Li <tonanli66@gmail.com>

commit 0d3a282ab5f165fc207ff49ea5b6ad8f54616bd6 upstream.

The following hash set variants:

hash:ip,mark
hash:ip,port
hash:ip,port,ip
hash:ip,port,net

iterate IPv4 ranges with a 32-bit iterator.

The iterator must stop once the last address in the requested range has
been processed. Advancing it once more can move the traversal state past
the end of the request, so a later retry may continue from an unintended
position.

Handle the iterator increment explicitly at the end of the loop and stop
once the upper bound has been processed. This keeps the existing retry
behaviour intact for valid ranges while preventing traversal from
continuing past the original boundary.

Fixes: 48596a8ddc46 ("netfilter: ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Nan Li <tonanli66@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_ipmark.c    |    6 +++++-
 net/netfilter/ipset/ip_set_hash_ipport.c    |    5 ++++-
 net/netfilter/ipset/ip_set_hash_ipportip.c  |    5 ++++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    5 ++++-
 4 files changed, 17 insertions(+), 4 deletions(-)

--- a/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -150,7 +150,7 @@ hash_ipmark4_uadt(struct ip_set *set, st
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++, i++) {
+	for (; ip <= ip_to; i++) {
 		e.ip = htonl(ip);
 		if (i > IPSET_MAX_RANGE) {
 			hash_ipmark4_data_next(&h->next, &e);
@@ -162,6 +162,10 @@ hash_ipmark4_uadt(struct ip_set *set, st
 			return ret;
 
 		ret = 0;
+
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -186,7 +186,7 @@ hash_ipport4_uadt(struct ip_set *set, st
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++, i++) {
@@ -203,6 +203,9 @@ hash_ipport4_uadt(struct ip_set *set, st
 
 			ret = 0;
 		}
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -182,7 +182,7 @@ hash_ipportip4_uadt(struct ip_set *set,
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++, i++) {
@@ -199,6 +199,9 @@ hash_ipportip4_uadt(struct ip_set *set,
 
 			ret = 0;
 		}
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -274,7 +274,7 @@ hash_ipportnet4_uadt(struct ip_set *set,
 		p = port;
 		ip2 = ip2_from;
 	}
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		e.ip = htonl(ip);
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
@@ -298,6 +298,9 @@ hash_ipportnet4_uadt(struct ip_set *set,
 			ip2 = ip2_from;
 		}
 		p = port;
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }


