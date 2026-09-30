Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEBA503BEE;
	Wed, 30 Sep 2026 15:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782622; cv=none; b=XW77f5pfYrzQLCizJQottduH4jQUCTZRuy77zb5aD9EbdxDRZ2J/NPpzSs/bskjl4/NIqdQxQkpN270S2KGAhhhNCioOJrrh35Ys8eVx/42tiT1ENI09AhcxzuO1ypALpINh6+2S0/i8Gk9WfW0eeJ2XIoqBSwK/jwvnjf7S1XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782622; c=relaxed/simple;
	bh=QBMrjs5Y9sn3RuEjOGOJO8pgV5avWVbv2QhTvZMyp04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWqaAzBt+oPgsq8y50cYNAOnY4YhgV9a+ftyUyJbFk1ugOoiPROCF2DfDvu9qQbFppeUbrPcue9MStNVUUQdZygT922ZLh/VbKqMMxcOnm+oydX6BClJ7YxIvktveYXm5TmuE/+ieXJAXqOkKJ7o+CjWy2FgbZ0huvBVfFBBZZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mYgJ47D/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mYgJ47D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E342A1F00899;
	Wed, 30 Sep 2026 15:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782615;
	bh=Qhf9eBjX97zPvYFXZlE4cDNbKCc7etb+JbBwVPm5j7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYgJ47D/KB6PLIeg0hTDfZ4NAuwSduIbdtM+iadjuJZpLeNDNRHkA7kARNi9jeFL4
	 18idXqrlStcQM+jCvH9mkEk8U4WukGNDpiDElAGTED0XTFTraFjmnATsN6E1FYVZ4H
	 ZuI7pexi3Gga274mcB7zxlsFZZ/xerQVpu1w4XQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/595] netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()
Date: Wed, 30 Sep 2026 17:20:00 +0200
Message-ID: <20260930152350.039209816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 133e17715bbc2..7ddc751f979eb 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -411,11 +411,11 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 	BUG_ON(ptr == NULL);
 
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



