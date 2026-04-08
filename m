Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7523624B0;
	Wed,  8 Apr 2026 18:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673678; cv=none; b=PGAl6X24jodsvTyAPNin9/i3CCvoduvqCItOp9/2zZiVHKGqGlYFaBtY2sTL4GXqUC+A/lPKTEhIHe7dfatYt2TAJcoCcQopmlo1C6ObL51/oCD2Wuvu7J6f1bnXq1NMSuiQIYOE2KrRbX7oJoVb4Vudq+rCSTXFsasT12TmAVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673678; c=relaxed/simple;
	bh=bDAZWNXD40VU5JBzeUITB98NAoVvRM/s6sj9wG94ttY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mn64uAW5swBDXE3APm5/dkONmk+kvUK1OkzN5qVpuSf+VcpeadexjKfrdVZqwGaVx5W39cgc06pQc/+Zrm0i5c/hxZ+WuR+dXLeHZJ8PEyxmej+g2Z/ZrFG5POBmUn9SmBvfKVeoAmUyHnfIr4Tbss6liUoE50sBqGj3Oynjui0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Afa1620c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Afa1620c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7C8C19421;
	Wed,  8 Apr 2026 18:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673678;
	bh=bDAZWNXD40VU5JBzeUITB98NAoVvRM/s6sj9wG94ttY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Afa1620c5wNf6FyXwTLiKZEwNS20gyeOllKJPxos8ClNzCid5PIX69VcqDeT8XYvd
	 glGsGcanqEuU+ddTt6ADxT5KNN8j4cygRVpEoGdDAHK2KP/rgA5qICWfvKNqzlPKZe
	 j3ttqePKvjtJzt+XFRN7+Ymm0b7XZU5eWT1T6pfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Justin Iurman <justin.iurman@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/242] net/ipv6: ioam6: prevent schema length wraparound in trace fill
Date: Wed,  8 Apr 2026 20:01:28 +0200
Message-ID: <20260408175928.869770551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5e67ba9bb531e1ec6599a82a065dea9040b9ce50 ]

ioam6_fill_trace_data() stores the schema contribution to the trace
length in a u8. With bit 22 enabled and the largest schema payload,
sclen becomes 1 + 1020 / 4, wraps from 256 to 0, and bypasses the
remaining-space check. __ioam6_fill_trace_data() then positions the
write cursor without reserving the schema area but still copies the
4-byte schema header and the full schema payload, overrunning the trace
buffer.

Keep sclen in an unsigned int so the remaining-space check and the write
cursor calculation both see the full schema length.

Fixes: 8c6f6fa67726 ("ipv6: ioam: IOAM Generic Netlink API")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ioam6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ioam6.c b/net/ipv6/ioam6.c
index b6ed67d7027c1..868a25c57b924 100644
--- a/net/ipv6/ioam6.c
+++ b/net/ipv6/ioam6.c
@@ -712,7 +712,7 @@ static void __ioam6_fill_trace_data(struct sk_buff *skb,
 				    struct ioam6_namespace *ns,
 				    struct ioam6_trace_hdr *trace,
 				    struct ioam6_schema *sc,
-				    u8 sclen, bool is_input)
+				    unsigned int sclen, bool is_input)
 {
 	struct timespec64 ts;
 	ktime_t tstamp;
@@ -942,7 +942,7 @@ void ioam6_fill_trace_data(struct sk_buff *skb,
 			   bool is_input)
 {
 	struct ioam6_schema *sc;
-	u8 sclen = 0;
+	unsigned int sclen = 0;
 
 	/* Skip if Overflow flag is set
 	 */
-- 
2.53.0



