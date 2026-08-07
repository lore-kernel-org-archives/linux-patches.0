Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2B42D12ED;
	Fri,  7 Aug 2026 15:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116128; cv=none; b=MLihGes045Hd5bUd9RlqEUSmW6I4z8WVDI72XoDFVAQL13YtRSYbIwi0pN6mB2wvKV4ArkiO3stXJ6rCEeVm1mPoXR3VpkwZ0bM0wuYErOIVnfDTy8UKBS6AW6Pk6j5OrH6Za5V6qU8nk9UeYmd6VubxoNv2ePoQfMaumH2AeGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116128; c=relaxed/simple;
	bh=OHS+t1R6clLAk1dGlU/CdlAZVAr+C0tiOtnHrgeAmbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJxWUvNtG7j+eugOzKbTLdExObbvEE+9m+JX9d9epQhm7NFQzPjyFScUE0CP/W32/GqTgGncz/zDZyY1VejaB8cr4ghPOQPhsnBGuKeXrpzhXZJChmRLYiwuD3vKctQW6FSgqYSy8mGi5WR3B8Un0cFPy+pNkHQ5TX7eMWLfxis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGMUKwvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGMUKwvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE161F000E9;
	Fri,  7 Aug 2026 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116127;
	bh=wEtE0tcj1EGlA4N9ZzbvmGQDzeJdYSHmpL9E62tr/oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bGMUKwvthbMlperZnL+dlhKwqiMuGW1JWdUzd6dyrV9Wa8IWiue+Sxs3XC+1rLFC9
	 IAKG77pNZB2fFcroSE9qXoEpjSgw6jX+C6pV6gsS+AeTIpKjSPXrtttP/dtvhtrKA5
	 fs1eKjKuXcge1yKAtHpouOSX9pie6SYhPzyZ2V+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Julian Anastasov <ja@ssi.bg>,
	Zhiling Zou <roxy520tt@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 123/261] ipvs: do not propagate one-packet flag to synced conns
Date: Fri,  7 Aug 2026 16:38:00 +0200
Message-ID: <20260807143418.023875431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <roxy520tt@gmail.com>

commit a63d2dbaeb50a85d4c976b15a36e6b0c7113db5b upstream.

Synced connections can be created before their destination exists. When
the destination is later added, ip_vs_bind_dest() copies connection flags
from the destination into cp->flags.

IP_VS_CONN_F_ONE_PACKET connections are not synced. If a synced
connection inherits IP_VS_CONN_F_ONE_PACKET while it is already hashed,
expiry can treat it as a one-packet connection and skip unlinking the
existing conn_tab node, leaving stale hash nodes pointing at a freed
struct ip_vs_conn.

Drop IP_VS_CONN_F_ONE_PACKET from destination flags when binding synced
connections.

Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_conn.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -598,6 +598,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, s
 	flags = cp->flags;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
+		/* Synced conns are hashed, so they can not get this flag */
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
+
 		/* if the connection is not template and is created
 		 * by sync, preserve the activity flag.
 		 */


