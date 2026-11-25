Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623367;
	b=bgjnMAly3QneAYUr35qySpvM9KbAprU/HMVKmEYJGyRIzxPhgcpZHTIwwzYjZTAAxkbt
	 /yepthcnmijXvcBWzjUIryon5ab0feGMXixaNVfWWuXw4I61SsxQjZ5vqUvGqsNrUnRKA
	 GSXvSP25aHqlEGcF5f7IJD5JGwiq4kPkdprz/QNM9WDxqasDNXvFSaQavMEnvClcdoF2E
	 SD3tiK7C55WCJEbdRT+qLsrOwoDZoOPPkRTfBbkyybWWimNl2ASKnJx9N7m0O2go3e0Mt
	 EKcCfINd0YSTiN/KQxnL/Fp32O9zLr3HukYGXq1VrqlObXaMAf6l9aVDQGM7kZAM6cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W4cXJnxGAFTGsR18op68l+6zrLWn7CQNFLrVea+hmfw=;
	b=e9RNXJreh1esa+u+Y5ViSBsCAZiPeEK1IjiMbNCpEaYeXIynevaRKqyJyDmfCZDk0viz
	 F/8puBWwfKCH0Vqs2QcLWkn8Zu/uF3BMbQVXu6VP8bXPnr2v1M8h++SwLKGJq2OhOXWyf
	 Zz5EsAWr9Fs6hXisVTML5mxLTWMzjxqTyDXyCoT8y8jE+NM8p+l0Sr0nsIQSGbb92n4ge
	 t9Sarua/C6f5tH7md8g4mrJKu5J7iFWmyure2K5YFXG61Ceh+jOZnhY4SiLdsFuvHOA6O
	 k5t0rKQRyCMUTpK3HrrVUj6kxseTqplIQC4hpII5BStIu9jMENlRby/WE0DugThhXtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yHUH7OjQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE51606A323;
	Wed, 25 Nov 2026 16:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yHUH7OjQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C961F000C4;
	Wed, 25 Nov 2026 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623367;
	bh=W4cXJnxGAFTGsR18op68l+6zrLWn7CQNFLrVea+hmfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yHUH7OjQX/UAIxkLFfaTNAWB5tcIop+FFT+s8IYUQVGv+knhbLoCNGomUGHIM1eiU
	 UmjlR1I+soQr907daVUXp+ea/Y8O5NlkfLr6+L3x3g+t2AjJzQHZTssdOeqdxj3Ulv
	 1DtFFatT+rMxt1hX1siNa1zsjbzESBdsuxNaZE9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 6.18 791/990] sctp: fix ASCONF address change on single-homed hosts
Date: Wed, 25 Nov 2026 15:35:58 +0100
Message-ID: <20261125143840.573065605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3157,9 +3157,12 @@ static __be16 sctp_process_asconf_param(
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
 
@@ -3172,13 +3175,9 @@ static __be16 sctp_process_asconf_param(
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


