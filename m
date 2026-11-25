Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625851;
	b=w+Gvt+x66s7bzKfoeyIg/ZnVIrLI9Vqb9T4AtKB/ZEswejbbtfNpDNPpkApgMKn8gW8K
	 eCTyzaxmppP8qx8Meug14wN+9aY7rGi1ZomjR+h8S+09YfdY+Ag41GxY9HO9kcR3oIcpl
	 0vD0lmWzfajrkYysP1jnps4hqz/9GplU3wwBCHduc7X3uICnDUE0T28tQibmJTh/fzgnb
	 O1TdcjCWhmrFTy1pr51nrNBtd8qkod4SKAkO5Aie3azuqAWUNOden6vTwoODuqjy07t6E
	 xbhVa3eGOO29EtL9AdVqWU/924oOlrhLfkR7Ool0q2SYOTklHfGdJm64rqxwiyie1Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9NsGECueXBOIrUVhx3jSxMCSJNHd+LB+JYGdQwfiKCU=;
	b=OP9ZBQwm/8aUsrTtKVcx7zvsUpqKCC1QYMCJ3soQITq7r4d8KJgoLWlWmUGHE3e3WyFu
	 /COI7qegLyKXkhHcRbZUhRwVBg/sk84bkI/2XDjdjui9JUyK8mheevhw4fWTcCwRDiWLV
	 o+ZGIS2FikL92vG86wEYqBhWmcp0retswAexQdiNeq2RnfeNsx+PwwmVa8V4eqj9pnfy2
	 9OqOZbyE3aS3KvOqzB4NubDG6MmwsqyryTN/FBWSS08TMarXf1t7QkUHw20AbaBIfcJ4l
	 +ZSYhodB9qoT8OK3Z7Dy4Ve/i6WsNbkaFSUWblF7p2Do3Y3L1ac2rdmBN8f/VGIfgBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5yWYX79;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31905606A31E;
	Wed, 25 Nov 2026 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5yWYX79
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C8E1F000D2;
	Wed, 25 Nov 2026 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625851;
	bh=9NsGECueXBOIrUVhx3jSxMCSJNHd+LB+JYGdQwfiKCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5yWYX79kUUxC0tx1qGF6561z8hEqtxrw+snFAkXbh/vc/UQGboLJ2BcNC2mBupsJ
	 Frv4JrmtsgrzXRIfKGWoWkUE8Ypmx65pS8q+G+uBwhoXNICX5JB/Cq81lFKXXwxiTP
	 xiyrNxaFqqKsyXn8lnJIk7w2ukMDmdu3nnD6ybt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 6.12 649/816] sctp: fix ASCONF address change on single-homed hosts
Date: Wed, 25 Nov 2026 15:36:37 +0100
Message-ID: <20261125143904.205480794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3191,9 +3191,12 @@ static __be16 sctp_process_asconf_param(
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
 
@@ -3206,13 +3209,9 @@ static __be16 sctp_process_asconf_param(
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


