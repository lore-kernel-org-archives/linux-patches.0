Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64DE367B8F;
	Fri,  9 Oct 2026 14:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556255; cv=none; b=l5PopKbCvtUR3srHQLPAZG6BbxXGWhHM/hkLsuMqJL/g7TL5DJxFXMJhIyhBAyw+VeivhZ/xFykt7f6Z/RofXUWk3VYvc4i67ipfGU8725nuo/CKDRLd3EHSLZWM2eB4tnwlSdcveWLBbDMKpHef/psy2ulNo8TkfU7QP4PfxPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556255; c=relaxed/simple;
	bh=9Jex7Q94or0XuuAsN/ASBwjqPcdwyOKy+awJWUhXoz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FbcWouOW83rX9Lf4MJAoj7u3y7l3NF7rh4/vAFk9YRGAP4Erl6qbrV3IqmqEQoKEENkeVL0vgH0xdXJbUuL8pgFQ6fIlPgwWOA0l9fVG/vcu3fDB89k67cQnqY0IJUSuzPkqkHS9xTGQtrlKWgz5O+UI54yLKAGvw0bdyqo2Ph8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1QTRCue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1QTRCue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423291F000FF;
	Fri,  9 Oct 2026 14:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556254;
	bh=hZqUkVgorlzjf7fNtHjGRegmsLGKJK4JxVxmkeE/SF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O1QTRCuezqmaHR95DNu6AjtPeLO2W2j4VHvcM28StKRKNYsO+bu5vNf0a50UrZzcY
	 nLqj3/Jt02UrZ5vpDfcmDmCtK4+4NlWQbCcdyS1kWB1irJfboxuqearPCIYoaAy1S9
	 ffKoLEG8npSqI9/XtbBoKlMlECTVuEbKGfTF6rlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 147/428] ipvs: do not create invisible templates
Date: Fri,  9 Oct 2026 16:08:04 +0200
Message-ID: <20261009140949.399275069@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 616cf5c06934364ab1002b420ebe975850b4b208 ]

The IP_VS_CONN_F_ONE_PACKET flag was implemented for normal
connections. When conn template inherits this flag from
dest->conn_flags it will not be hashed. As result, we will
create new template for every new normal connection.

Fix it to allow one template to be used by many normal
connections.

Fixes: 26ec037f9841 ("IPVS: one-packet scheduling")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260916231652.127456-1-pablo%40netfilter.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 6fa3e1dc534c3..cb009208826f0 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1102,6 +1102,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	if (cp->protocol != IPPROTO_UDP)
 		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	flags = cp->flags;
+	/* Only visible templates can control multiple connections */
+	if (flags & IP_VS_CONN_F_TEMPLATE)
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
 		/* Synced conns are hashed, so they can not get this flag */
-- 
2.53.0



