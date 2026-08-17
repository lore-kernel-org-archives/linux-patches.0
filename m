Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CE13E00B6;
	Mon, 17 Aug 2026 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976055; cv=none; b=rewpjx8E4rmPzfQgMxSF+pjRitNHBBV0SGUexp2AMKDADRBQxbq1cphGGQYwNFD9qvmEXB5EZNcqYnjJfPWDtnzbRutXLnXhe0mfWANKG5Lmsm6I1iQsTO5VkMiQeyn98bGDw6sFhUA4q1SRg3br1YZKdlDEW9wleJQe7iTeYI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976055; c=relaxed/simple;
	bh=Vq1BGUOGlO5YVR6eY48tgfiIv5jD5YyflfcefHZqB40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrpmTAWVi+6ygQZwqomLNoCEyxbQNlC/uEQeTgbTnkfmfW9Ds40p6dEUyWFPMyaEddimu86QprbW4uQK9DH/a7FzuXNP58CX7vhDuLjKoFNK6ZEE+N9xCYcXkE7xTYTYX+I9L1+2Xd9Nv9SIBCInnMEquTmtQ6HPeNRgD2kAQh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lO2UVIfa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO2UVIfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF4A1F000E9;
	Mon, 17 Aug 2026 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976054;
	bh=Xy+ooiauuEySTbzs72uEOaeOkL2bY8/6T9eKhh4B0R8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lO2UVIfai4JBpK3QdpzWczxrVYpFJqM0Q9cvds3O6yfGh9n4f8G+0+9MwUp/7/m8f
	 pILdSiTdVxeImoUB613n984gQriUW9AYtV+2nDH0Zo/iar1hh1UQQTTejroNVLkaNz
	 q26TK3kf121+9oG0yxj2IERs2TYJ3eqvBSZLGXKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sperbeck <jsperbeck@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 192/389] raw: fix a typo in raw_icmp_error()
Date: Mon, 17 Aug 2026 15:30:31 +0200
Message-ID: <20260817132546.695524301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 97a4d46b1516250d640c1ae0c9e7129d160d6a1c upstream.

I accidentally broke IPv4 traceroute, by swapping iph->saddr
and iph->daddr.

Probably because raw_icmp_error() and raw_v4_input()
use different order for iph->saddr and iph->daddr.

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Reported-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220623193540.2851799-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/raw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -279,7 +279,7 @@ void raw_icmp_error(struct sk_buff *skb,
 	sk_for_each(sk, head) {
 		iph = (const struct iphdr *)skb->data;
 		if (!raw_v4_match(net, sk, iph->protocol,
-				  iph->saddr, iph->daddr, dif, sdif))
+				  iph->daddr, iph->saddr, dif, sdif))
 			continue;
 		raw_err(sk, skb, info);
 	}


