Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DFB3F65E5;
	Tue, 17 Mar 2026 17:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767438; cv=none; b=RSyaiElVL7GOtaU3lT/2VcPU8Q4AdGhD2LW3XF+dd2m3m/N6cha1x7jMOvbqB94bVngAd2cq/NmihvYb1tQogCerk9A/66Fo5F3KpQpIkj4i3bYITBNJ1ksZoW+NvnByV0FUYHgJ7LKHMBa+8Vn3BIDUGQXUTSB6KvThKj1YKXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767438; c=relaxed/simple;
	bh=ONtQ2kIzZ4SPTF3g76/VG/7V7sls+HQvrTIPmQirrtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nr4p0PW2Q+xCSo1UrdEX7y96gRSYNcZ15wnWuoSAV/IxGz0yM09V0PNEPoFFcmOXP7so5UY1sLAXl/zEF4m0fDf8v38oG9PjegUgU9uJsOSKgenRIwun+ZTmUxVH6cdbaB7wQ2M3RXeby9tDTTndXZr4bDYfP24pBKrfRgH01Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G2xnkC/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G2xnkC/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E69DC4CEF7;
	Tue, 17 Mar 2026 17:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767438;
	bh=ONtQ2kIzZ4SPTF3g76/VG/7V7sls+HQvrTIPmQirrtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2xnkC/YFbW0+01gDZ7PD/hI5nt9mQxg8XSj03laF3dxSU/Q5AcI0irMfqIb7sjVy
	 jwBGKeq/saT29qoIXF0q3dTi673UpMW94n7iUHa/OmRjP2zg5wuyJCzEPvhQIpS27w
	 nw+5ELElXt5gcy+KaPw3/RrNCuZox6Zv0eyoQ4Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Dull <monderasdor@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/333] netfilter: x_tables: guard option walkers against 1-byte tail reads
Date: Tue, 17 Mar 2026 17:31:38 +0100
Message-ID: <20260317163001.936563276@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: David Dull <monderasdor@gmail.com>

[ Upstream commit cfe770220ac2dbd3e104c6b45094037455da81d4 ]

When the last byte of options is a non-single-byte option kind, walkers
that advance with i += op[i + 1] ? : 1 can read op[i + 1] past the end
of the option area.

Add an explicit i == optlen - 1 check before dereferencing op[i + 1]
in xt_tcpudp and xt_dccp option walkers.

Fixes: 2e4e6a17af35 ("[NETFILTER] x_tables: Abstraction layer for {ip,ip6,arp}_tables")
Signed-off-by: David Dull <monderasdor@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_dccp.c   | 4 ++--
 net/netfilter/xt_tcpudp.c | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index e5a13ecbe67a0..037ab93e25d0a 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -62,10 +62,10 @@ dccp_find_option(u_int8_t option,
 			return true;
 		}
 
-		if (op[i] < 2)
+		if (op[i] < 2 || i == optlen - 1)
 			i++;
 		else
-			i += op[i+1]?:1;
+			i += op[i + 1] ? : 1;
 	}
 
 	spin_unlock_bh(&dccp_buflock);
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index e8991130a3de0..f76cf18f1a244 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -59,8 +59,10 @@ tcp_find_option(u_int8_t option,
 
 	for (i = 0; i < optlen; ) {
 		if (op[i] == option) return !invert;
-		if (op[i] < 2) i++;
-		else i += op[i+1]?:1;
+		if (op[i] < 2 || i == optlen - 1)
+			i++;
+		else
+			i += op[i + 1] ? : 1;
 	}
 
 	return invert;
-- 
2.51.0



