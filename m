Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704618;
	b=nEO9M0DR5noNrY2LuqjlCVgEwqdfHQA+DZDj2IegcFbvT9lQqiJSia5uAftGtitTlfre
	 pNF3IQe04lfHWmRGwS84M8AKwDZoIfSKVayWafVCaGDGytKTS5gVERUVjGJwSmAwmc0jW
	 BFp/m94UFhpjH/NSP7S+wA5BOFC5l1yRpZUVliAoa+Wr0Enq7d2wDPbun0wb2yMuenAzl
	 icchHmKQMvdqBJN4KnLxGS+p//KRYnvrtZe9eSL5+7TVv66lHRWC8il8Tdcsir8hRdSXP
	 hh5WN4e8j3Z5T6fL1iLaaEKFxWdpU27VOTOU6ohuJkpYnFw16ExQeDJx1KkAOXZ1vbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1OQCTN7dM5vNtwzJOqVs3Cot4XbHD41/o99Jm1uif+w=;
	b=36rRVdKMEk5j7x5bYKoqNFiNeVUvQQr5Uyh4C34COW+dX/C2Pf9puIa6g/L2hXHixWBf
	 7utxgNNwlgm5GrlUCLZixyIz1FjNhBDyxdDfgIye/p/DXMq5ZT4d6kkKIjsESlvgwKp4T
	 VD0yIEUe5fwUlwkKoXDJ0WjWJ7g7661wYI8QI6ElWgtnFArmEKGsz12h3l7ExHheZpQxN
	 cQA5Sh62S5gW0apckambm8j1XKIB0xsxXH2Cz2CKm8XKFtjiEa1LRS72YUKilCOyb5efH
	 i6oBwhBXOhc4s/05dN3gIp2ElUF2Lej1pO3aG+TrEzPlndIabejtwzBOwwEtRLTsWwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0/SLoPMQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4C606A31C;
	Thu, 26 Nov 2026 14:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0/SLoPMQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C611F000C4;
	Thu, 26 Nov 2026 14:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704617;
	bh=1OQCTN7dM5vNtwzJOqVs3Cot4XbHD41/o99Jm1uif+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/SLoPMQtO8t0HJopNE/mls8Ul9I2f8wTp4J6eST7UJ6R6rUT3tq83qAmVGCXvWN0
	 HRue0y8PEMKLOIlP41908/uMbYKgcABPohv6l5Le+ISW/j6YUGLGkwAd3uU8HAlaAe
	 nSqyqj4g/pZZ57mZ5KHVO3RdI0drQgHwsxpl2oeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 5.10 184/265] sctp: fix ASCONF address change on single-homed hosts
Date: Thu, 26 Nov 2026 15:38:34 +0100
Message-ID: <20261126143618.077743528@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Misiurov <andrey.misyrov@gmail.com>

commit 5175b2fb34c77cf2cd56a290affa45412cb3a228 upstream.

Commit 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in
DEL-IP processing") refuses a DEL-IP of the transport the ASCONF was
located by, so that a later wildcard DEL-IP cannot use it after free.

This also breaks the single-homed address change (RFC 5061 5.3.2). The
host sends [Address Parameter L] [ADD-IP S] [DEL-IP L], the association
is located by L, and DEL-IP L is now refused. The sender never gets an
all-success ASCONF-ACK, keeps src_out_of_asoc_ok set and stops sending
data, so the association stalls.

Fix the wildcard DEL-IP instead: look up the transport of the packet
source rather than reusing asconf->transport. Both DEL-IP paths can
now free asconf->transport, and chunks bundled after the ASCONF still
use it, so point it at a surviving transport: the packet source for the
wildcard delete, the primary path for a plain one.

Found by manual code inspection while reviewing a backport of commit
9b2854f86f0b; reproduced on a two-namespace single-homed renumber.

Fixes: 9b2854f86f0b ("sctp: don't free the ASCONF's own transport in DEL-IP processing")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Misiurov <andrey.misyrov@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3135,9 +3135,12 @@ static __be16 sctp_process_asconf_param(
 		 * packet MUST be deleted.
 		 */
 		if (af->is_any(&addr)) {
-			sctp_assoc_set_primary(asoc, asconf->transport);
-			sctp_assoc_del_nonprimary_peers(asoc,
-							asconf->transport);
+			peer = sctp_assoc_lookup_paddr(asoc, &asconf->source);
+			if (!peer)
+				return SCTP_ERROR_REQ_REFUSED;
+			sctp_assoc_set_primary(asoc, peer);
+			sctp_assoc_del_nonprimary_peers(asoc, peer);
+			asconf->transport = peer;
 			return SCTP_ERROR_NO_ERROR;
 		}
 
@@ -3150,13 +3153,9 @@ static __be16 sctp_process_asconf_param(
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;
 
-		/* Don't free asconf->transport; a later wildcard DEL-IP
-		 * parameter reuses it.
-		 */
-		if (peer == asconf->transport)
-			return SCTP_ERROR_REQ_REFUSED;
-
 		sctp_assoc_rm_peer(asoc, peer);
+		if (asconf->transport == peer)
+			asconf->transport = asoc->peer.primary_path;
 		break;
 	case SCTP_PARAM_SET_PRIMARY:
 		/* ADDIP Section 4.2.4


