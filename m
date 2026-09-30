Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A985221DC;
	Wed, 30 Sep 2026 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790956; cv=none; b=CgY/eAbgX1XuK5Iy6C5G66MTxiBmTAW3QrUtdYCdhsQ/6Ahc0sIpX1QHzpOvb/myMPx7zz8CgwE1X35Cm7j2T5JsCk+glMf3TgLZe7MxiFF8YIj7rTiYBqou/A5aEF3KJAl3BeYK5dtz79c3pUpog/RJXubjJGA4JgzeXibG4DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790956; c=relaxed/simple;
	bh=UUNEdMnZ7XL6sq7O7hi3RhXBKGutCX0hW4ipBpUBg58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L14oonhY5ZSmAGu1eVqM8odL6uOzxicSb+Vfitv06Lz9pulNrCbNCccJFQNAec4HrfZxFYgGjSqtqRHjNR0enfzzLLOSb1uPdubqVOfhjEVEhW5wXJlDLfVpwBul3/u8ltI8bsniOg4hGtXozP6nfQgsntm8r2D1eym8uMPKpvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8oz8a3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8oz8a3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC511F000FF;
	Wed, 30 Sep 2026 17:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790955;
	bh=XGQ1d/Lb0dN54vKv7mnFg8OIJyveh0YHISMgc/29+iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S8oz8a3cs8jew9Z5jlBVIYhWslfTlQru4yK0dFAfTRVl9bDtpaQwku26ys6ZMg3rh
	 mxQqHq0x56sk+W4+Uv5dW3fZ3yY5rYTFwroyKT3YLRXdyWwnXlbLDf3ybA07nEvU7o
	 FZCgi+pVnK+bMTEgx5Rgg7Y625NtwOGE5jJCwW6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 126/752] netfilter: nf_conntrack: use get_unaligned_be32() in tcp_sack()
Date: Wed, 30 Sep 2026 17:19:56 +0200
Message-ID: <20260930152400.906119182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 7c8012f4c8dee..60e3b3217f9ab 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -399,11 +399,11 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
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



