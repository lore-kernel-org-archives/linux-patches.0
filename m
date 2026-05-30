Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA70137750;
	Sat, 30 May 2026 18:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167011; cv=none; b=lMgnK1lEflg5F+6bLSV3ASsmuAxG4Emod87cKD5nwZd3q20KJ2ZXSxq6ttlMnkM8JhpOoDh0CBNr0Xt9dMjh8o55i2GM4x6T97pmWg5ViodKoH79dIpO6dUfZQfM18xrte7R1q62YhiLUXyavHJP0XUdyqgyFP/h5juPg97hbwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167011; c=relaxed/simple;
	bh=Ik0ow9buupzsKQkD7yK9oO01Gs+SKRQE91/HzG5Wi2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unA+yp5+27VJDy5L+924CVjtRCz6cmlab9bddBpEEXFKVvYbDSvKHIbaBDJuHqjUaiqoCRTiOMXsEJd8TEHgeV3DO+iUe4Rggr5u8da+faw1DsOruAPGE/IkonSwP+8RCVZotbGr06eZHEOKsz2xMMDqRe+tPudhbmn03KoJOkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkGPVR8R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkGPVR8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2471F00893;
	Sat, 30 May 2026 18:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780167010;
	bh=kPRTiJMqBdL7X2/YbnBF2SrspX+0hpLuchrPGjjmQWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KkGPVR8Rga5wg0H8p3BQUQnl1ylW7kD6AVkk17w200opxtBd/gIh1FvRbia+zYgOg
	 wsqqgoL13xN3eH8zjfTOMrVT+Of0IYO4OwxQcjGFwuThTg4V//siGlSI1R5+oa0Z0o
	 vBi3NV7gUcWYXbAothTiSR6uxKBeYX3UlNuY4O3w=
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
Subject: [PATCH 5.10 536/589] netfilter: ipset: stop hash:* range iteration at end
Date: Sat, 30 May 2026 18:06:57 +0200
Message-ID: <20260530160238.781181025@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -149,7 +149,7 @@ hash_ipmark4_uadt(struct ip_set *set, st
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++, i++) {
+	for (; ip <= ip_to; i++) {
 		e.ip = htonl(ip);
 		if (i > IPSET_MAX_RANGE) {
 			hash_ipmark4_data_next(&h->next, &e);
@@ -161,6 +161,10 @@ hash_ipmark4_uadt(struct ip_set *set, st
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
@@ -174,7 +174,7 @@ hash_ipport4_uadt(struct ip_set *set, st
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++, i++) {
@@ -191,6 +191,9 @@ hash_ipport4_uadt(struct ip_set *set, st
 
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
@@ -181,7 +181,7 @@ hash_ipportip4_uadt(struct ip_set *set,
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++, i++) {
@@ -198,6 +198,9 @@ hash_ipportip4_uadt(struct ip_set *set,
 
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
@@ -273,7 +273,7 @@ hash_ipportnet4_uadt(struct ip_set *set,
 		p = port;
 		ip2 = ip2_from;
 	}
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		e.ip = htonl(ip);
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
@@ -297,6 +297,9 @@ hash_ipportnet4_uadt(struct ip_set *set,
 			ip2 = ip2_from;
 		}
 		p = port;
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }


