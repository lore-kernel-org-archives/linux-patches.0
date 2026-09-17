Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6794EB865;
	Thu, 17 Sep 2026 16:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664361; cv=none; b=KZTHqE3chEd8x7fnTpEfWaU8QjMee7YLW4PAPW8IQsErAxb3s4hy3o/bH7jjRFUge3RrkNhR4HsZS4B/+gOOBAW0XuyZmNMGqAW3Ry8th/egKBG7jwbB80y1DQQsoEz5vUZcgOmOtd629FKZ1Fq6MMtsMHsXoXAMR/XGFdcsD10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664361; c=relaxed/simple;
	bh=fgmHvYsuGDb977rThYl4yTLpdJRXh0MAjlf0pcZ1De4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpS1UwvffYoSXH/pAib6zzcSU1s6QmKBCqjQXsrnb8Zawo8RNXWclZQ+IecABR5R4SvxE1rTPnnJLDWpbOy6yucHEMERiLno+Jg53TwffbDq2jUplzjjqhzrn2igFdA9Ljlir2wyoHsylU5dFpWOEuxvN/PEPiZRzULHqKsYL1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mH0jpC1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mH0jpC1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2781F000FF;
	Thu, 17 Sep 2026 16:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664359;
	bh=UIxmZl70LBfeDmNdPf0V+A3/YT5+U+abMiDrDuJKzOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mH0jpC1rQqhGBZHw3c0vDWhKY2pDMpxUbT4NFpD98FIvMHUsOZSrMCWN4OEHMlRhR
	 f9oIO3YohuvqYyekOGICf+sQB9Zd+E+r89OzRKnZEHmKv3lsw4kFyoqERoR1WssC0V
	 qojQMyeRd72nsTLZncZELhCqqNuZOTnHrGIcUmVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0347/1250] netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()
Date: Thu, 17 Sep 2026 16:02:22 +0100
Message-ID: <20260917151601.477393354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit d3bf9eae486490832bd08fd62ab0ac601f346bd4 ]

The timestamp-only fast path dereferences the option stream as
*(__be32 *)ptr, which assumes 4-byte alignment that the TCP option
stream does not guarantee. Use get_unaligned_be32() instead, which
reads the value safely and already returns host byte order, so the
htonl() on the comparison constant can be dropped.

This matches the existing get_unaligned_be32() use later in the same
function.

Assisted-by: Claude:Opus-4.7
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index c289bec0c7c72..91da35e2b0d8d 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -405,11 +405,11 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 		return;
 
 	/* Fast path for timestamp-only option */
-	if (length == TCPOLEN_TSTAMP_ALIGNED
-	    && *(__be32 *)ptr == htonl((TCPOPT_NOP << 24)
-				       | (TCPOPT_NOP << 16)
-				       | (TCPOPT_TIMESTAMP << 8)
-				       | TCPOLEN_TIMESTAMP))
+	if (length == TCPOLEN_TSTAMP_ALIGNED &&
+	    get_unaligned_be32(ptr) == ((TCPOPT_NOP << 24) |
+					(TCPOPT_NOP << 16) |
+					(TCPOPT_TIMESTAMP << 8) |
+					TCPOLEN_TIMESTAMP))
 		return;
 
 	while (length > 0) {
-- 
2.53.0



