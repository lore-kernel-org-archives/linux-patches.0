Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829073;
	b=WQPAxsm+B3uIbIIdjpjlAaiqFfG7Nm+Xk5N6jvDdm4x7nBk/SsHMgkRGAOiqVWqYzQ/3
	 96l38mX1JnlswRt6Y9KM4bckpxiR3NNVctPluT4mGU4ia1ha4Zah8Msdg0i0yReHMmBxh
	 tA+ZEWUaG5X4qKinrF29XRoOOUdcOSCpuHAOsNRXjNRlVMMBGTTgshVb+B3wyBnmh8VLA
	 MJvqBpUAZ3AxPzTX65YRadhmXM+njXLQE28aA7lgNzvbJB3QvGbABRbyJ2Uu0QipFer8H
	 hlBbAF7F4NWUjbV+fCeDB21BtZWcuqT0r+H8cY3X4ynyeMKDL9z0UbiJCDOXibiFdMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DmFmoS/es2u02206wZfJwyfqlCqKX0cCsmRzFT3BTOI=;
	b=Krb7/JPRPxA7J1cCE18lu60CgqH4lMSvuq9EZX2W0cX8NGegsK7N7qnwX3OOw+ksL45o
	 ekP+BeNuisMEu4US551sSqU2y9b43eMTDYDUO4BZzxgQXvwRpPIBM5rGLvwVhYlFJUmyZ
	 vRgveBB3bGiXR5ChjuRoZdtG9piayshgW6Qu++8XwEGMW0K6yX7BiNk1xuPEJcBERx9hL
	 mQ7Xzlpctw8vW49V3c+9OoVdVWA7jDDp9EceSZFmQKu7sydjiIgjgQf7Ql/REv+lqjl/q
	 wT95dGKuWQ36GPqZu84oeUzjodjXjV0HxZ1snhGEUhQFrF3iD7nmBKHXKa3xYI26S3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSHCa7OK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D8360820A3;
	Wed,  4 Nov 2026 21:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSHCa7OK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988B51F00A16;
	Wed,  4 Nov 2026 21:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829072;
	bh=DmFmoS/es2u02206wZfJwyfqlCqKX0cCsmRzFT3BTOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSHCa7OK0SFIqP0KIVi/haBxJCJFuiqqVnBn34YQqGFabyC3sZWQ6bFmo7ZrRE5CL
	 lraM/vESYxl52V+GL1F1SNysFVqk+NQbeyXBWNSmHA+zmCP/5CcwEgkI385F1hj0fD
	 +6FTIzStcikUJnq5zdGJ2Oe6PZMlPOJCabJ5l61Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	"Mayank Jangid (OpenSec Intelligence)" <mayank.jangid.moon@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 426/547] nfsd: preflight SEQUENCE replies before accepting a slot
Date: Wed,  4 Nov 2026 16:10:10 -0500
Message-ID: <20261104211050.446634802@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 35ff1a7a7e3835c3e974bc5c45d335897564ceae upstream.

nfsd4_sequence() narrows the reply buffer to the session's cached
reply limit before it accepts the slot seqid. A client may negotiate
ca_maxresponsesize_cached down to NFSD_MIN_HDR_SEQ_SZ, and
nfsd4_alloc_slot() then gives every slot a zero-length sl_data[]. A
COMPOUND tag can fill that narrowed buffer until it holds the
SEQUENCE opcode but not the status word that follows.
nfsd4_encode_operation() returns without running
nfsd4_encode_sequence(), so cstate.data_offset stays zero. It leaves
op->status at nfs_ok as well, so the COMPOUND is treated as having
succeeded.

nfsd4_store_cache_entry() declines to cache a lone SEQUENCE that
returned an error. That test reads the status the operation
reported, so it passes here. The copy starts at offset zero and
takes the whole reply, RPC and COMPOUND headers included, into the
zero-length sl_data[]. The COMPOUND tag is copied along with it, so
the client picks most of the bytes written past the end of the slot:

  BUG: KASAN: slab-out-of-bounds in read_bytes_from_xdr_buf+0x1bc/0x390
  Write of size 80 at addr ffff888003a549cd by task kunit_try_catch/24
   __asan_memcpy+0x38/0x60
   read_bytes_from_xdr_buf+0x1bc/0x390
   nfsd4_sequence_done+0x5b0/0x810
   nfs4svc_encode_compoundres+0x1bf/0x240

Check that the fixed-size SEQUENCE result, plus room for a following
operation's error status, fits the negotiated limit before narrowing
the buffer and consuming the slot seqid. The slot and its reply
cache are left unchanged, as RFC 8881 Section 2.10.6.1.2 requires of
an error returned from SEQUENCE.

Fixes: 47ee52986472 ("nfsd4: adjust buflen to session channel limit")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Tested-by: Mayank Jangid (OpenSec Intelligence) <mayank.jangid.moon@gmail.com>
Link: https://patch.msgid.link/20260817-jean-v1-1-9e356596ab85@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5048,6 +5048,7 @@ __be32
 nfsd4_sequence(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		union nfsd4_op_u *u)
 {
+	struct nfsd4_compoundargs *args = rqstp->rq_argp;
 	struct nfsd4_sequence *seq = &u->sequence;
 	struct nfsd4_compoundres *resp = rqstp->rq_resp;
 	struct xdr_stream *xdr = resp->xdr;
@@ -5057,6 +5058,7 @@ nfsd4_sequence(struct svc_rqst *rqstp, s
 	struct nfsd4_conn *conn;
 	__be32 status;
 	int buflen;
+	u32 maxlen, respsize;
 	struct net *net = SVC_NET(rqstp);
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
@@ -5134,7 +5136,22 @@ nfsd4_sequence(struct svc_rqst *rqstp, s
 			session->se_fchannel.maxresp_sz;
 	status = (seq->cachethis) ? nfserr_rep_too_big_to_cache :
 				    nfserr_rep_too_big;
-	if (xdr_restrict_buflen(xdr, buflen - rqstp->rq_auth_slack))
+	if (buflen < rqstp->rq_auth_slack)
+		goto out_put_session;
+	maxlen = buflen - rqstp->rq_auth_slack;
+
+	/*
+	 * A SEQUENCE result too large for maxlen never reaches
+	 * nfsd4_encode_sequence(), so cstate.data_offset stays zero and
+	 * the reply cache overruns the slot.
+	 */
+	respsize = nfsd4_max_reply(rqstp, &args->ops[0]);
+	if (!nfsd4_last_compound_op(rqstp))
+		respsize += COMPOUND_ERR_SLACK_SPACE;
+	if (xdr->buf->len + respsize > maxlen)
+		goto out_put_session;
+
+	if (xdr_restrict_buflen(xdr, maxlen))
 		goto out_put_session;
 	svc_reserve_auth(rqstp, buflen);
 


