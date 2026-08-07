Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3F22DB7BB;
	Fri,  7 Aug 2026 15:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115290; cv=none; b=hpCiyTzJavk/7RZiW/c1woyrXVBB4ZqsMbTnO0AtM4uHoMFzRVnDtzMV+A/Qn+OfMmEuNI/j9Xaxn5KHi4Z5ayEPIDYLiNynGgX7K941BwBRB/pLfe/INJpmmwTdpc75BUF/rzsIL3PdneQr0I//EYRv38Pm3rasjrnJ6oURnrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115290; c=relaxed/simple;
	bh=Cg5/5PbvGYAkEZlho7D3v9zMVndHcVhtBbbGHsd05Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRG9V7H5Wz9ZW8FgDILx9fwOHxNg+AmnwmPTapWhC17Kqt/vXDUYEAVghhTA/WheXTAPjUA8XQ9FXNTyDZskdxTBiA2RURPy5VuxxxBaEWqXOSzofXN7PrwGclUBBpeVo+RbfkeOOS/u9oOyjCDizy7K3jnY9esV/k+h9skuhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=069MyNrk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="069MyNrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBCB1F000E9;
	Fri,  7 Aug 2026 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115288;
	bh=zoD4uKV77UO5HQorLyjKyJoLWjol7BT4yO93yMhKl+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=069MyNrk1XgwTsUFgH7ZUs4hTV8w8n7ZJytEioH5I8M8I0JZHeMFyvewmtPJnkNbr
	 nzhmYBuSqRQXItc4sG/RMNcUd+XyYZ5zJsRFhX5rlI5vmKjtOfsKgg1QLq0Asnypea
	 xXIDp+oGZstiOwxlWuE+aymgnN4cv9DXY46UYUOs=
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
Subject: [PATCH 6.18 223/396] ipvs: do not propagate one-packet flag to synced conns
Date: Fri,  7 Aug 2026 16:36:23 +0200
Message-ID: <20260807143429.073676200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -599,6 +599,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, s
 	flags = cp->flags;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
+		/* Synced conns are hashed, so they can not get this flag */
+		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
+
 		/* if the connection is not template and is created
 		 * by sync, preserve the activity flag.
 		 */


