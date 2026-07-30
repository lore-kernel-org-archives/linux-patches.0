Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1455C408615;
	Thu, 30 Jul 2026 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426342; cv=none; b=WVvQp3qPNUsysl4jNPyzc3Gi4GwY4M4ckOzEwP7Ay/5rYs6p9feiCWLasmc1DKGZnauF8C+wp3QH8xPYKhxyC2ZmFIkF6jkNoyJ1o8hspscd1iEqJ7DeS+GqeKDJEIP77OpOBXOGX3yinwWDmeqXz8EAT+XKM6nrW2jsAEsofII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426342; c=relaxed/simple;
	bh=d57+Q/3CHxnFhXOUV1rr3X+BegMIdlX6On/79RAB9+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dMYM7lbMHrxZJEbBJmdxuf5Azz5o5WgTEeqF9JjhSRPAr6PbeRqGcpCiE6zGB1N6xx71s8cPkjL2Oc6BYybnC9ANXcmdCgAbo0HhMekhlGeT/KkFVLLEc5KkmGR0ADT78k8whjTyFKwgLyG67t9RYBrnKU5CeqG3AOCRRK/3cAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNF9Xnub; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNF9Xnub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3681B1F000E9;
	Thu, 30 Jul 2026 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426340;
	bh=h/E1G8dJitZNp+vnb3slqYQ+YQEz53DMLHFvC1RtyAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNF9Xnubs8g/YHN5GB1oaM6kFf6eXIufexd6WgImcmU2mg+8XBAA18KbE4k9oLK6S
	 Z+VFmGEigFYXnbYqOdFxfpUmPZEulgw7iMfQlHk+G4vBU5PMLySbW3QniACBHnGR+f
	 3AW9YcVTNi+pL6xmS7i8TA7wxMMYuAqYH6f3J5gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jun Yang <junvyyang@tencent.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 386/602] sctp: dont free the ASCONFs own transport in DEL-IP processing
Date: Thu, 30 Jul 2026 16:12:58 +0200
Message-ID: <20260730141444.070020855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
@@ -3171,6 +3171,12 @@ static __be16 sctp_process_asconf_param(
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


