Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FAB47886E;
	Fri,  7 Aug 2026 15:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117320; cv=none; b=nv44aqLXoqfzVq5TNM9btW8Wo/i4Xol8NlB567zXP2PqIBtlSrtiNjdH20ntdHNMQn5EFR8WPizwPpY1Cpk3TbTH9y6n5h7l7W7V4hot72lQib+iDj4vYvg5TyCvRDvt9ocjAFqqzT7rU2X9cfGTBkfxE5k7gY6MDJTyKph0FNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117320; c=relaxed/simple;
	bh=K02KKlirxBbCOE4KU1o9RBKKcXgNC2Xfw/onBSZkoDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2mYhyaQyHrgtPb7F0SRfFdvcbnNS/44LfxZXYhmwurX2/W6OSonihQmUCO+uIoT8t896k/wmRDv6r/jyaFUBmYlzEg6h6Tq5nDILSW501e0chl++FXfC7XZZo+VPjHmGUOYajygqkTmJTfZb6HgFyI09hz43E4ZIV38Yc2dqXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCz4XY9/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCz4XY9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABC51F000E9;
	Fri,  7 Aug 2026 15:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117318;
	bh=xOzvAp419Pyac5X1nTlOpir/yITfbF0CoYyGSa/B/IM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCz4XY9/DDRnWeVZml471bRMP/7a0brc9EIea4imOHE5LK+AKZRRxGeXCR5VANl6n
	 n7gtYH1psrMDM8UpIg0rqXJ994tpW62RtUJMrgTIxuylh1wDxCvLbHOTWvAHEXnLMA
	 LAnDUTd31tZ7cvQQEhf1kjOpSfHo1mE1m+icF/Cg=
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
Subject: [PATCH 7.1 277/438] ipvs: do not propagate one-packet flag to synced conns
Date: Fri,  7 Aug 2026 16:37:53 +0200
Message-ID: <20260807143433.887751640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1110,6 +1110,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, s
 	flags = cp->flags;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
+		/* Synced conns are hashed, so they can not get this flag */
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
+
 		/* if the connection is not template and is created
 		 * by sync, preserve the activity flag.
 		 */


