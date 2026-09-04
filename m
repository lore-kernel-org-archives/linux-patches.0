Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC193D6664;
	Fri,  4 Sep 2026 05:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499738; cv=none; b=aJXHvzowNxLrsLCUp5pMbZrGcNPvC5cOjQiO7WrPASU84nCy3D5dmb0l/Aob3iYeYNpEItkgHlJzoRADcrg126wiTJmjOA/vk8iXTcDz7/SZyCCqfIOVxnyU9Ci0SGvUDlud7ZHQ0DaFanjF3r+ZvfY4CXEM5b/cWP6KnoGyGcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499738; c=relaxed/simple;
	bh=GvHwOBf8hUHhAF1kN5wEFMrlfJqJEtdM6c5flP839hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKzJ/4Ojts5XdyuqzPe4QrkNaVa7TiCC3IhSBHpfw0l280vuxbBymdiviihw71kLRd3MQws/YL9N7uWgOvl9FOVrQwftObKkmmpZ7RPUUtX0jl1YkH/4YFDQkycGQlFkM3AxLQ8af2xtl/gpRWD2U6dxO2m7JpAnkJCXGZ9TT5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXGB1q/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXGB1q/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2601F00A3D;
	Fri,  4 Sep 2026 05:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499737;
	bh=1oQU4XNPIKomyIZJGJjerWizZxPU/WmOvJmMBMOX6is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXGB1q/5AK49NZ4DeEUentHo91zraxteeEfMVcjixC6ZbAN25Ei11PrJ3A1wz0GL3
	 9yv9uMXMDovPd4QGciVsNyy1WHD7KFPGBOxoSDgK1ch9J6bkErxQPEFrfFUYFGqxAP
	 ywVPxmqBlYLdDZU7ztou1maec2+zM41Q2IS/fn4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Simon Horman <horms@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jun Yang <junvyyang@tencent.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 496/713] sctp: distinguish sequence zero from wildcard in reconf lookup
Date: Fri,  4 Sep 2026 06:57:44 +0200
Message-ID: <20260904045814.943037451@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
 


