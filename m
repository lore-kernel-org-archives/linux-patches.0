Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705649;
	b=JZdrvERx5Nevggi4ZOXf63FZbCSDZw2uoGiM8dktlsUr6U8Q1TNmuyQj91xrTX5fztEL
	 uxzMQYzC8sDxHdxyrgB5T/VJmqCzKrvUA9tK4N5xFSx7nAJvGzEyWKN9WBDzKCE5sfXWn
	 Ebk67lYbjJNYCeOUkbshc0n3y4/ZKKoMbV9OU76YjTs0jD7B/B/UgI4szE1b3/ZLVn4il
	 9Uml2ygFn9cu/WIAJ/YloTFHpuzt05vI40WHIduaXTds+QJ7MvYEectKIwBdRVg768KSK
	 51s85twPQTaffBqNXcHtUF9Vy3o1GCQuCbPqGsMeBAAXbU3ERTgxP3JFvQFk/hm+tqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rWpgK7VT4Vc3VmqoPkGuPLj66nGPYfxuABxNdIR66hk=;
	b=lJd5ftS44GcHtQhT6wBIDe5lDeQi97sWW3Pr/62pneyRtUbCPgUtYEmnfex5D4jK+8oS
	 pnJKSycA4FcAX1vytmv03tlwmUc7IyztMx8dTmn+XhlMUnQEuvtd7UCjWKrztJu9YFcs8
	 yDt0v5uPBV21+XYVPeLxTLtXkykLW0nLy2qk8KcrpkJIB2D29e3H9YFcyMtVRVkvcHhgS
	 7H03Uy6w4Gg4k5imTNu51BpcI5s3V0MH8kcJ6mWFd0NywffoVa8u8GxMXoiw115n7WScR
	 FvcDQCQ+DM2KrBNbYV+1lxCCiExqQCjHRlarKQUmwupBvMbrIWGrHbDrKfIwR9+9+aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7saaFoa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509CA606A31E;
	Thu, 26 Nov 2026 15:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7saaFoa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AA11F000C0;
	Thu, 26 Nov 2026 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705649;
	bh=rWpgK7VT4Vc3VmqoPkGuPLj66nGPYfxuABxNdIR66hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7saaFoavBVA+zO4LdXlKDnoeApnlPI1+AEPNB1j1sZgRyjx5nGSx5dh9HKaoghEl
	 ssaEjqQBPXWnXLbSC8YKnM+qc9SrZM48GX3whsYKW3CseSr5tt4cHoMLYaqef0uMs7
	 351tMuqscrJc0AQPKEBSfmw3k63jzXkg8vGEkWLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Misiurov <andrey.misyrov@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Subject: [PATCH 5.15 224/319] sctp: fix ASCONF address change on single-homed hosts
Date: Thu, 26 Nov 2026 15:39:52 +0100
Message-ID: <20261126144011.804629793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3181,9 +3181,12 @@ static __be16 sctp_process_asconf_param(
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
 
@@ -3196,13 +3199,9 @@ static __be16 sctp_process_asconf_param(
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


