Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C463C73F6;
	Sat, 17 Oct 2026 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259428; cv=none; b=WCZgONg5JhtqrIYKOsgpLJaG6WM0KGbL5YorH+XDwRjq/gq5qpqm4QI5+cKRrhvD8MwxBrdVdVrCdCpFqUBXDj4p9jC7aVAPywZX8/VYJHhFVBlz2Zy4Z3R4sulrFyfBaKlMEiMzvwp6TVi7Yieq/XnAsU6e1x9a+PAQpxbtnys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259428; c=relaxed/simple;
	bh=FL8BaCVS1HRI66KAUVkIL3fzIY8rlyF9HfFA/FTTiUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BnBjggDlH/MiAhRJXbkU522zqc7alC32aQ9fCCRp/8Zuaf4rV9eGXsyNHx6tcmcUd+PWpNUp9ar8CbUrLtf3pz75wHm+V2GlEWJ5VprSEfFRDFlsCS1XDaZmax9Fo6+yNCJoK43JcSqJobUqjzZIYocD2q3vjvwtmBjsm6Mh5uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHnZ/so0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHnZ/so0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523FC1F000C4;
	Sat, 17 Oct 2026 17:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259425;
	bh=sxpzCrr0WW9u6dVeNrCGAHxvUFVzwceNCPI3zCIVefQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHnZ/so0CTEizv1D6Nb+KF9kMDaiKPt2N+kWHyT+cPETD/jpVh3AZoF2eskBa5qwA
	 oDtxVPPOJg7SWU30S8Vdv5eKUZvXdgJGXaG4FWHPdNfTUF4LUVRX5lPPBEFOiycQ8+
	 9RngMIeS3saFbxnoOt7sq4o0vHlQ6IS2hZ7raYxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1210/1674] sctp: validate cookie AUTH state before use
Date: Sat, 17 Oct 2026 17:58:02 +0200
Message-ID: <20261017160502.195954455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 3dbb44d88b1e94dd31fe43588af7437b34b44d56 ]

When cookie authentication is disabled, COOKIE_ECHO restores fixed-size
AUTH fields directly from peer-controlled cookie bytes.  A forged RANDOM
length, HMAC list, or CHUNKS list can then reach association consumers
with lengths or identifiers that were never validated against the local
backing arrays.

A forged RANDOM length can cause out-of-bounds reads during key-vector
construction.  A forged HMAC identifier also caused a 32-byte write past
a zero-length AUTH chunk, providing a primitive for a local privilege
escalation chain.

Validate the cookie's RANDOM, HMACS, and CHUNKS parameters at the cookie
trust boundary before copying them into the association.  Reject invalid
types, malformed lengths, unsupported HMAC identifiers, HMAC lists
without SHA1, and forbidden chunk ids.

Fixes: bbd0d59809f9 ("[SCTP]: Implement the receive and verification of AUTH chunk")
Fixes: 1f485649f529 ("[SCTP]: Implement SCTP-AUTH internals")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260804200042.2412009-1-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sctp/auth.h  |  3 ++
 net/sctp/auth.c          | 76 ++++++++++++++++++++++++++++++++++++++++
 net/sctp/sm_make_chunk.c |  3 ++
 3 files changed, 82 insertions(+)

diff --git a/include/net/sctp/auth.h b/include/net/sctp/auth.h
index d4b3b2dcd15b7..c2399fb178890 100644
--- a/include/net/sctp/auth.h
+++ b/include/net/sctp/auth.h
@@ -23,6 +23,7 @@ struct sctp_association;
 struct sctp_authkey;
 struct sctp_hmacalgo;
 struct crypto_shash;
+struct sctp_cookie;
 
 /*
  * Define a generic struct that will hold all the info
@@ -77,6 +78,8 @@ struct sctp_shared_key *sctp_auth_get_shkey(
 int sctp_auth_asoc_copy_shkeys(const struct sctp_endpoint *ep,
 				struct sctp_association *asoc,
 				gfp_t gfp);
+bool sctp_auth_verify_cookie_params(const struct sctp_endpoint *ep,
+				    const struct sctp_cookie *cookie);
 int sctp_auth_init_hmacs(struct sctp_endpoint *ep, gfp_t gfp);
 void sctp_auth_destroy_hmacs(struct crypto_shash *auth_hmacs[]);
 struct sctp_hmac *sctp_auth_get_hmac(__u16 hmac_id);
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 8320764b16b92..5fcfcdce0694d 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -376,6 +376,82 @@ int sctp_auth_asoc_copy_shkeys(const struct sctp_endpoint *ep,
 	return -ENOMEM;
 }
 
+static bool sctp_auth_chunk_id_forbidden(__u8 chunk_id)
+{
+	switch (chunk_id) {
+	case SCTP_CID_INIT:
+	case SCTP_CID_INIT_ACK:
+	case SCTP_CID_SHUTDOWN_COMPLETE:
+	case SCTP_CID_AUTH:
+		return true;
+	default:
+		return false;
+	}
+}
+
+/* Verify AUTH parameters copied from a state cookie before they are restored
+ * into an association.  When cookie authentication is disabled these fields
+ * are peer-controlled, so they must satisfy the same constraints as locally
+ * generated AUTH parameters.
+ */
+bool sctp_auth_verify_cookie_params(const struct sctp_endpoint *ep,
+				    const struct sctp_cookie *cookie)
+{
+	const struct sctp_paramhdr *random;
+	const struct sctp_hmac_algo_param *hmacs;
+	const struct sctp_chunks_param *chunks;
+	u16 hmacs_len, chunks_len;
+	u16 n_hmacs, n_chunks, i;
+	bool has_sha1 = false;
+
+	if (sctp_sk(ep->base.sk)->hmac || !ep->auth_enable)
+		return true;
+
+	random = (const struct sctp_paramhdr *)cookie->auth_random;
+	if (random->type != SCTP_PARAM_RANDOM ||
+	    ntohs(random->length) != sizeof(*random) + SCTP_AUTH_RANDOM_LENGTH)
+		return false;
+
+	hmacs = (const struct sctp_hmac_algo_param *)cookie->auth_hmacs;
+	hmacs_len = ntohs(hmacs->param_hdr.length);
+	if (hmacs->param_hdr.type != SCTP_PARAM_HMAC_ALGO ||
+	    hmacs_len < sizeof(struct sctp_paramhdr) +
+			sizeof(hmacs->hmac_ids[0]) ||
+	    hmacs_len > sizeof(cookie->auth_hmacs) ||
+	    (hmacs_len - sizeof(struct sctp_paramhdr)) %
+			sizeof(hmacs->hmac_ids[0]))
+		return false;
+
+	n_hmacs = (hmacs_len - sizeof(struct sctp_paramhdr)) /
+		  sizeof(hmacs->hmac_ids[0]);
+	for (i = 0; i < n_hmacs; i++) {
+		u16 hmac_id = ntohs(hmacs->hmac_ids[i]);
+
+		if (hmac_id >= SCTP_AUTH_NUM_HMACS ||
+		    !sctp_hmac_list[hmac_id].hmac_name)
+			return false;
+		if (hmac_id == SCTP_AUTH_HMAC_ID_SHA1)
+			has_sha1 = true;
+	}
+	if (!has_sha1)
+		return false;
+
+	chunks = (const struct sctp_chunks_param *)cookie->auth_chunks;
+	chunks_len = ntohs(chunks->param_hdr.length);
+	if (chunks->param_hdr.type != SCTP_PARAM_CHUNKS ||
+	    chunks_len < sizeof(struct sctp_paramhdr) ||
+	    chunks_len > sizeof(cookie->auth_chunks))
+		return false;
+
+	n_chunks = chunks_len - sizeof(struct sctp_paramhdr);
+	for (i = 0; i < n_chunks; i++) {
+		if (sctp_auth_chunk_id_forbidden(chunks->chunks[i]))
+			return false;
+	}
+
+	return true;
+}
+
 
 /* Public interface to create the association shared key.
  * See code above for the algorithm.
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index fd9fa4b651262..4d663210f825f 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1883,6 +1883,9 @@ struct sctp_association *sctp_unpack_cookie(
 	/* Set up our peer's port number.  */
 	retval->peer.port = ntohs(chunk->sctp_hdr->source);
 
+	if (!sctp_auth_verify_cookie_params(ep, bear_cookie))
+		goto malformed;
+
 	/* Populate the association from the cookie.  */
 	memcpy(&retval->c, bear_cookie, sizeof(*bear_cookie));
 
-- 
2.53.0



