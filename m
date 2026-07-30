Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F50544C664;
	Thu, 30 Jul 2026 15:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424887; cv=none; b=uZqTKpXIqtGC1hCHq9jLJiOC5u8R4U3a5LMHWTZtX8bOKnt4zvCYa/gfVO6TflZQHTLYvLkoqUYRGMdH4IoMoetvufb1Z7T3AVsPcPZplWFJrzBCKIijjLYF+T0XvdgvNXWV5XmMO4zso2uTgMUhAqRT0fQTMlyZD+OvtdlXPpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424887; c=relaxed/simple;
	bh=DC7soECBdomiz9+PhFj62ncTNCrD2Hwz0o8mA/o3MeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmAIDDUdpWKTDfV/jgsX5CmLUzzA0JVm5Xl6Cb1zFF4LpFzSgPiNhT9PEERPdoyxX85Hq2CUuVOqkro1Efn2dUaYM+MaHGjW6YmfSSu/S3ek/mbOt06AO/DOyaEnysslN78CO60VX3tCl8nOLBA2AonZ2kyZd2uSXePWL9fPttU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aH28zi+J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aH28zi+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641861F00ACA;
	Thu, 30 Jul 2026 15:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424885;
	bh=ZnmKzo++Yj0uEfdfm6t4BMuUskUynwHRjkt9tHVUn0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aH28zi+Jyt3izVNachPrVfvczDN5y7mYZu/HbwxNX+BX813qpn+v2hlCIp1AWrlXO
	 vCzNGC0wcCrTPGDO1RjU2JseZBHSqIiEMjOjfSQu1FmULD9PXTS3dWiWjnkLWNOSaZ
	 NQKvTsC6+fl8zUT5O5qPLky3E2GZFYNbFwKabV8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jun Yang <junvyyang@tencent.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 507/675] sctp: dont free the ASCONFs own transport in DEL-IP processing
Date: Thu, 30 Jul 2026 16:13:57 +0200
Message-ID: <20260730141455.905631219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Jun Yang <junvyyang@tencent.com>

commit 9b2854f86f0b56e9027d68e7a3fc909d1a9b566f upstream.

sctp_process_asconf() caches the transport the ASCONF chunk is processed
against in asconf->transport (== chunk->transport, set once in sctp_rcv()).
For an ASCONF located through its Address Parameter by
__sctp_rcv_asconf_lookup(), that cached transport corresponds to the
Address Parameter, which need not be the packet's source address.

sctp_process_asconf_param() rejects a DEL-IP for the packet source address
(ADDIP D8, SCTP_ERROR_DEL_SRC_IP), but nothing protects asconf->transport.
A single ASCONF can therefore carry, in order:

    [Address Parameter L] [DEL-IP L] [DEL-IP 0.0.0.0]

where L differs from the source. The DEL-IP for L passes the D8 check and
calls sctp_assoc_rm_peer() on the transport that asconf->transport still
points at, freeing it (RCU-deferred). The following wildcard DEL-IP then
reuses the now-dangling asconf->transport in sctp_assoc_set_primary() and
sctp_assoc_del_nonprimary_peers(): set_primary() dereferences the freed
transport (->ipaddr, ->state) and plants the dangling pointer into
asoc->peer.primary_path / active_path, and del_nonprimary_peers(), keeping
only the pointer that is no longer on the list, removes every real
transport, leaving the association with a transport_count of 0 and
primary_path/active_path pointing at freed memory.

Reject a DEL-IP that targets the transport the ASCONF is being processed
against, mirroring the existing source-address guard, so the wildcard
branch can never reuse a freed transport.

Fixes: 42e30bf3463c ("[SCTP]: Handle the wildcard ADD-IP Address parameter")
Cc: stable@kernel.org
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3153,6 +3153,12 @@ static __be16 sctp_process_asconf_param(
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;
 
+		/* Don't free asconf->transport; a later wildcard DEL-IP
+		 * parameter reuses it.
+		 */
+		if (peer == asconf->transport)
+			return SCTP_ERROR_REQ_REFUSED;
+
 		sctp_assoc_rm_peer(asoc, peer);
 		break;
 	case SCTP_PARAM_SET_PRIMARY:


