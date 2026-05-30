Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5A7241C8C;
	Sat, 30 May 2026 18:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164996; cv=none; b=uMByl0BzQ+DPdw4ariPLRuB8iDrRYi0tuJsGDIDzhIolMH0x9oXtn4LU9PN0BT5Gn3Gf7ZFiRF1QXQ+xHlWIShsPZkW9Bfjk/8l0CTyqAC9exS/KhmKcbzR5z0k8Qlvs9lasybrvM3MWj2fkoZzDLRg4mE6iH1E/z9UvyVNwZGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164996; c=relaxed/simple;
	bh=Qr7gFVPIJNgzx1P75U5CADfIMMibo/oF3LLpPtnzxWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgmY7I+Di6F0V6vSSGF4n+v+houj3IzH/+iaCLedLgu4UuJQev9Cn1WtYIpE/nPOigifdlbiULdwre/Mvnn7zFfPHNKHPTwwF45/jcTJ4F9OQYx+a79yIOl1HL2m0jI5+SzRs3UGAzxAt7Vuh4KOjv+3eUjId1Cgs9IS6Fz/vYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jv8ly2WJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jv8ly2WJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A701F00893;
	Sat, 30 May 2026 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164994;
	bh=R9Mm6yXtAni1E3wvzjBcVBTsWSGmQwpIVUrbNrmOTaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jv8ly2WJpbgNixo1LQv/vnbVVw6NWk/DJ6AQCG19cfeP6Sc7ebMwZh639AZ6GKjnL
	 r9cgmb744s0FIftght8HScyq09TsxEvk8oKKB5Jgft3+hOYvid6INAuhzBGE1m8s9l
	 GwAlGkV3zqxyK4EDH6+DGmeNxsRHaki5uW+trYoo=
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
Subject: [PATCH 5.15 689/776] netfilter: ipset: stop hash:* range iteration at end
Date: Sat, 30 May 2026 18:06:43 +0200
Message-ID: <20260530160257.660793169@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -175,7 +175,7 @@ hash_ipport4_uadt(struct ip_set *set, st
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++, i++) {
@@ -192,6 +192,9 @@ hash_ipport4_uadt(struct ip_set *set, st
 
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


