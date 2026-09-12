Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B08538F64D;
	Sat, 12 Sep 2026 18:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236893; cv=none; b=s16m/QUrYkVG36Eu6xjHQWkfHZljpNYfnl0NFF71VJN+k5BlKURR6g7GhB2Pv4X+PqsYcznZPfGeUd96McA3VyyhWBV2UZjnEFyxLzcgtvUbeWAqrM56mJxpyimxtSb12wM403UtVfmDk6wgttiL33ZvkO/7i6/3lrHehb9oZ2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236893; c=relaxed/simple;
	bh=UQ89HjdULC45PRO+UJ7FbilsrQdBhDx7qQwH/FoXGd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0ufNvL8+11z546MKCbfHK2O+6Bofi745vQgQ4VkQmiAiNAAbp1H4asCropXZXiZlZ7Z0dHgRGoB5105IfqMfpmMJ6DqA531sBvmqkfniIlO3eJU7zUtC7Noa03rXBALM9ynMjliKRet5ya4yLhx1FX5/7MonNyvuosYZLy378E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=euRcbzCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="euRcbzCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE401F000FF;
	Sat, 12 Sep 2026 18:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236892;
	bh=FeoPdUOOYbM64hF3NRCpTHxp9JaENQouLZlY6iBXrQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=euRcbzCzvqsFuo1SnE68gMC+ivISQLgMl6kg667kL5Khnq/c3/yViN0ceHjyAQR4u
	 ABViy39j6A0hpsN9XsJt2Yveonq+HGumkI7DB9XxmUPxOvbskT9yiLjLbM7oFNGP0Q
	 cOMYUZxyzNv5XWn0qmy/GPRUOrECf4PKR6g6U8wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Simon Horman <horms@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jun Yang <junvyyang@tencent.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 148/935] sctp: distinguish sequence zero from wildcard in reconf lookup
Date: Sat, 12 Sep 2026 08:52:58 +0200
Message-ID: <20260912065530.216395960@linuxfoundation.org>
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

commit 63f44178f0a0f86060c9b576d6efab8a3ffa403e upstream.

Zero is a valid response sequence after strreset_outseq wraps, but
sctp_chunk_lookup_strreset_param() currently treats it as a wildcard.

Add match_seq so response lookups match zero exactly while the one
type-only lookup can still ignore the sequence.

Fixes: 50a41591f110 ("sctp: implement receiver-side procedures for the Add Outgoing Streams Request Parameter")
Cc: stable@kernel.org
Suggested-by: Simon Horman <horms@kernel.org>
Acked-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Link: https://patch.msgid.link/20260824081832.98717-2-juny24602@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/stream.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -482,7 +482,7 @@ out:
 
 static struct sctp_paramhdr *sctp_chunk_lookup_strreset_param(
 			struct sctp_association *asoc, __be32 resp_seq,
-			__be16 type)
+			__be16 type, bool match_seq)
 {
 	struct sctp_chunk *chunk = asoc->strreset_chunk;
 	struct sctp_reconf_chunk *hdr;
@@ -499,7 +499,7 @@ static struct sctp_paramhdr *sctp_chunk_
 		 */
 		struct sctp_strreset_tsnreq *req = param.v;
 
-		if ((!resp_seq || req->request_seq == resp_seq) &&
+		if ((!match_seq || req->request_seq == resp_seq) &&
 		    (!type || type == req->param_hdr.type))
 			return param.v;
 	}
@@ -564,7 +564,7 @@ struct sctp_chunk *sctp_process_strreset
 	if (asoc->strreset_chunk) {
 		if (!sctp_chunk_lookup_strreset_param(
 				asoc, outreq->response_seq,
-				SCTP_PARAM_RESET_IN_REQUEST)) {
+				SCTP_PARAM_RESET_IN_REQUEST, true)) {
 			/* same process with outstanding isn't 0 */
 			result = SCTP_STRRESET_ERR_IN_PROGRESS;
 			goto out;
@@ -816,7 +816,7 @@ struct sctp_chunk *sctp_process_strreset
 
 	if (asoc->strreset_chunk) {
 		if (!sctp_chunk_lookup_strreset_param(
-			asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS)) {
+			asoc, 0, SCTP_PARAM_RESET_ADD_IN_STREAMS, false)) {
 			/* same process with outstanding isn't 0 */
 			result = SCTP_STRRESET_ERR_IN_PROGRESS;
 			goto out;
@@ -927,7 +927,8 @@ struct sctp_chunk *sctp_process_strreset
 	struct sctp_paramhdr *req;
 	__u32 result;
 
-	req = sctp_chunk_lookup_strreset_param(asoc, resp->response_seq, 0);
+	req = sctp_chunk_lookup_strreset_param(asoc, resp->response_seq, 0,
+					       true);
 	if (!req)
 		return NULL;
 


