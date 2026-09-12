Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFEC38F64D;
	Sat, 12 Sep 2026 18:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236898; cv=none; b=JsjggKYoIEXdGfe7I4UYtPDP5XjabR2K3NnTlZgLV8bjwRboWUtrSe/bn1Zjy5rX+Rsl67TJZlhVIMRz1E7Y5KtjrYEFYrHncVae0+wzp+9f5e9RG8oKCqfSUI7C3Q3Qa9sqpHyWtTZ7FoPZyruSh920i5vJINL0cNO2p4IWAdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236898; c=relaxed/simple;
	bh=h1C4STcwvguESs7sAHX4YIrGZJlc8rvqtJT01w5jgyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHIZ01q4UJqQC7GN/QtHG9rdi4NihSOqd07T/NsG7cBpJa22CTTQZ2iob29h7tYiNipVyx/1AA52/4N/tKFHbXX0oIE8nry7cwNSox1I5uE5F4p7uScsYaw+OEFsRUj0Kavj2bwefmwFNKirF0ehr3dXJqSx5xHIcmitQIYb8ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCnimkwk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCnimkwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3371F000FF;
	Sat, 12 Sep 2026 18:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236896;
	bh=KomUsEWjVXGoo8pmlWdgEzVujsp+rXyzpvgFBc6a+OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCnimkwk+7+gGFU9cKF/kDga2mPQfP6CSZUwKyw5YIHCnZ4GBaX/TG4js2IJn6TnX
	 QvXe16GiLd57Ek26SwKAaevgdTkf6JQPzWZip0CUI82SSFNpYa3HxBaVclh7ujMGdL
	 ST/evXDY6MMQ1Puv7Pdz1xNGsfZ7maqJBl8XjCvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	TencentOS Corvus AI <corvus@tencent.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jun Yang <junvyyang@tencent.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 149/935] sctp: fix stream->outcnt underflow on duplicate RECONF responses
Date: Sat, 12 Sep 2026 08:52:59 +0200
Message-ID: <20260912065530.239572808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jun Yang <junvyyang@tencent.com>

commit 3faf13aff243ca9f78d08b1a2956ef5a6fc77b6e upstream.

A cached RECONF chunk may contain more than one request parameter.  A
duplicate response can therefore find and process the same ADD_OUT request
again while another parameter is still outstanding, rolling back outcnt
twice and possibly underflowing it.

Track outstanding request types as bits and clear each bit after its first
response.  Later responses for the same request are then ignored.

Fixes: 11ae76e67a17 ("sctp: implement receiver-side procedures for the Reconf Response Parameter")
Cc: stable@kernel.org
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Link: https://lore.kernel.org/netdev/20260730110225.37371-1-juny24602@gmail.com/
Suggested-by: Xin Long <lucien.xin@gmail.com>
Assisted-by: tencentos-corvus-ai:kimi-k3
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Link: https://patch.msgid.link/20260824081832.98717-3-juny24602@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sctp/structs.h |    2 +-
 net/sctp/stream.c          |   39 ++++++++++++++++++++++++++++-----------
 2 files changed, 29 insertions(+), 12 deletions(-)

--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -2091,7 +2091,7 @@ struct sctp_association {
 	     force_delay:1;
 
 	__u8 strreset_enable;
-	__u8 strreset_outstanding; /* request param count on the fly */
+	__u8 strreset_outstanding; /* request param bitmask on the fly */
 
 	__u32 strreset_outseq; /* Update after receiving response */
 	__u32 strreset_inseq; /* Update after receiving request */
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -22,6 +22,15 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
+#define SCTP_STRRESET_MASK(type) \
+	BIT(ntohs(type) - ntohs(SCTP_PARAM_RESET_OUT_REQUEST))
+#define SCTP_STRRESET_TEST(asoc, type) \
+	((asoc)->strreset_outstanding & SCTP_STRRESET_MASK(type))
+#define SCTP_STRRESET_SET(asoc, type) \
+	((asoc)->strreset_outstanding |= SCTP_STRRESET_MASK(type))
+#define SCTP_STRRESET_CLEAR(asoc, type) \
+	((asoc)->strreset_outstanding &= ~SCTP_STRRESET_MASK(type))
+
 static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 {
 	struct sctp_association *asoc;
@@ -372,7 +381,10 @@ int sctp_send_reset_streams(struct sctp_
 		goto out;
 	}
 
-	asoc->strreset_outstanding = out + in;
+	if (out)
+		SCTP_STRRESET_SET(asoc, SCTP_PARAM_RESET_OUT_REQUEST);
+	if (in)
+		SCTP_STRRESET_SET(asoc, SCTP_PARAM_RESET_IN_REQUEST);
 
 out:
 	return retval;
@@ -417,7 +429,7 @@ int sctp_send_reset_assoc(struct sctp_as
 		return retval;
 	}
 
-	asoc->strreset_outstanding = 1;
+	SCTP_STRRESET_SET(asoc, SCTP_PARAM_RESET_TSN_REQUEST);
 
 	return 0;
 }
@@ -474,7 +486,10 @@ int sctp_send_add_streams(struct sctp_as
 		goto out;
 	}
 
-	asoc->strreset_outstanding = !!out + !!in;
+	if (out)
+		SCTP_STRRESET_SET(asoc, SCTP_PARAM_RESET_ADD_OUT_STREAMS);
+	if (in)
+		SCTP_STRRESET_SET(asoc, SCTP_PARAM_RESET_ADD_IN_STREAMS);
 
 out:
 	return retval;
@@ -564,13 +579,14 @@ struct sctp_chunk *sctp_process_strreset
 	if (asoc->strreset_chunk) {
 		if (!sctp_chunk_lookup_strreset_param(
 				asoc, outreq->response_seq,
-				SCTP_PARAM_RESET_IN_REQUEST, true)) {
+				SCTP_PARAM_RESET_IN_REQUEST, true) ||
+		    !SCTP_STRRESET_TEST(asoc, SCTP_PARAM_RESET_IN_REQUEST)) {
 			/* same process with outstanding isn't 0 */
 			result = SCTP_STRRESET_ERR_IN_PROGRESS;
 			goto out;
 		}
 
-		asoc->strreset_outstanding--;
+		SCTP_STRRESET_CLEAR(asoc, SCTP_PARAM_RESET_IN_REQUEST);
 		asoc->strreset_outseq++;
 
 		if (!asoc->strreset_outstanding) {
@@ -669,7 +685,7 @@ struct sctp_chunk *sctp_process_strreset
 			SCTP_SO(stream, i)->state = SCTP_STREAM_CLOSED;
 
 	asoc->strreset_chunk = chunk;
-	asoc->strreset_outstanding = 1;
+	SCTP_STRRESET_SET(asoc, SCTP_PARAM_RESET_OUT_REQUEST);
 	sctp_chunk_hold(asoc->strreset_chunk);
 
 	result = SCTP_STRRESET_PERFORMED;
@@ -816,13 +832,14 @@ struct sctp_chunk *sctp_process_strreset
 
 	if (asoc->strreset_chunk) {
 		if (!sctp_chunk_lookup_strreset_param(
-			asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false)) {
+			asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false) ||
+		    !SCTP_STRRESET_TEST(asoc, SCTP_PARAM_RESET_ADD_IN_STREAMS)) {
 			/* same process with outstanding isn't 0 */
 			result = SCTP_STRRESET_ERR_IN_PROGRESS;
 			goto out;
 		}
 
-		asoc->strreset_outstanding--;
+		SCTP_STRRESET_CLEAR(asoc, SCTP_PARAM_RESET_ADD_IN_STREAMS);
 		asoc->strreset_outseq++;
 
 		if (!asoc->strreset_outstanding) {
@@ -899,7 +916,7 @@ struct sctp_chunk *sctp_process_strreset
 		goto out;
 
 	asoc->strreset_chunk = chunk;
-	asoc->strreset_outstanding = 1;
+	SCTP_STRRESET_SET(asoc, SCTP_PARAM_RESET_ADD_OUT_STREAMS);
 	sctp_chunk_hold(asoc->strreset_chunk);
 
 	stream->outcnt = outcnt;
@@ -929,7 +946,7 @@ struct sctp_chunk *sctp_process_strreset
 
 	req = sctp_chunk_lookup_strreset_param(asoc, resp->response_seq, 0,
 					       true);
-	if (!req)
+	if (!req || !SCTP_STRRESET_TEST(asoc, req->type))
 		return NULL;
 
 	result = ntohl(resp->result);
@@ -1079,7 +1096,7 @@ struct sctp_chunk *sctp_process_strreset
 			nums, 0, GFP_ATOMIC);
 	}
 
-	asoc->strreset_outstanding--;
+	SCTP_STRRESET_CLEAR(asoc, req->type);
 	asoc->strreset_outseq++;
 
 	/* remove everything for this reconf request */


