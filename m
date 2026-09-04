Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C2B3242BD;
	Fri,  4 Sep 2026 05:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501306; cv=none; b=kDEmM93Zk8XoBvyriJi5jb4mPRFvoraqHHrJUbVCqdqBcEXuawybtnvWr7bSdctxI25b7FLXdwsYzTfH1Pn2WhbVPJU43MP5hlHBtbM4c/C6kfmoq/qkflMbp5/VmcfLE8kFgoBWqE+f5JK1IhLMaYvLIo49JYYfZruy8+Ytcoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501306; c=relaxed/simple;
	bh=fJvRMI4E07GtKPxZA3WdusZJz45XwgQHKBXtwomlciw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6P6tY7TOpLPHFfSF5BQzfcN/YgKmZWBXQqcB8kmNERqK3t9uG3jwOBZ6d/k3q0MK5UHAh8UhAUlJf7oFjBInR/Ffbe/dyrHvgAeJO7gH4Ftw8suGZX1/nn+7zKJmvXXkSlonJHKcTfzHxka8Bh4M2TZetr01flkb90hClBWIG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dUjdqQ6W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dUjdqQ6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05E91F00A3D;
	Fri,  4 Sep 2026 05:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501305;
	bh=aFdoIeDxQqxjazQBmoyRnvT5jsm/VDpl6JfA9ZRf4v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUjdqQ6W1YW0WuKH2o3lUdicuLp9QHnkBuN2IduWDPCfd6No5WmvFo4lmYOffiy35
	 S1cCKyxvVDuxcDbe2e3FREpPDkSLCfnXN+khqR5/ACVUpfRHeDinOATlbxKDybrGpk
	 7lmrBle+vm/nMdgZwAjlgau/+MzCOe7cY1gMc+Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Simon Horman <horms@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jun Yang <junvyyang@tencent.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 364/552] sctp: distinguish sequence zero from wildcard in reconf lookup
Date: Fri,  4 Sep 2026 06:58:41 +0200
Message-ID: <20260904045758.484155198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
 


