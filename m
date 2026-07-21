Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893F346EF84;
	Tue, 21 Jul 2026 19:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662149; cv=none; b=EtOOXBE9xqP2Y2yo6IgZ+dRG/JCFwSr/170j0OOaUpLlETN2KnIBktzq4TTn4kwpoTNXqUc1m/L9Aoz9NI96W5upAH2EI4grdD5tUhT9H3DiQe3ft55Px7nVF5bcW3aestbx+JomSK2r4RskDCnCbEx1u1mEFyyiVPbeTZNqAjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662149; c=relaxed/simple;
	bh=imrsBozzmiNKn3pAK1rIZA7oQpOclVL2kRTsME70HMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugPDQDrhF5852y2wFSa6zT5Q9wFsLyIdKaoAMg7Q3LjcRnynBwZxE1fS91+z8dokNscu50RhRtwsRnuAnQiJ6zOJJsS7jMVv/gsL8Zm33mcxfCRtHZ4+RrnNpw9COt+A5DYeoHgEScEjvoXHBnegRw+Q5OjuuYFxGsbnUbMh0kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAxjgXUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAxjgXUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEC21F000E9;
	Tue, 21 Jul 2026 19:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662148;
	bh=qYGr//bRvFrhyCMMHAk/v5dh6LCRjjIaIBRzN8sC1u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hAxjgXUTUvTUGxQYsWlGM/h4rAmfDYX6qV2D5GcJuOjnhmgi/3JqVBPjuCRrZBdH2
	 b3KLou9Kub2UlrDnnf9RB4lNxuow4O641hPFoUNEqiacKsHyhYkO9AVjbxgBteNt3N
	 bkiN0lVxzdqFERoZQT2rOhQ59tRPZCBUBvzuOKaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0336/1276] sctp: validate embedded address parameter length
Date: Tue, 21 Jul 2026 17:12:59 +0200
Message-ID: <20260721152453.622593472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit e9361d0ca55c4af12aac09e2572852fa91046229 ]

sctp_verify_asconf() and sctp_verify_param() only validate ADD_IP, DEL_IP,
and SET_PRIMARY parameters against a fixed minimum size of sizeof(struct
sctp_addip_param) + sizeof(struct sctp_paramhdr). This ensures the outer
parameter is large enough to contain an embedded address parameter header,
but does not verify that the embedded address parameter's declared length
fits within the bounds of the outer parameter.

Later, sctp_process_param() and sctp_process_asconf_param() extract the
embedded address parameter and pass it to af->from_addr_param(), which uses
the address parameter length to parse the variable-length address payload.
A malformed peer can therefore advertise an embedded address parameter
length that exceeds the remaining bytes in the enclosing parameter.

Validate that addr_param->p.length does not exceed the space available
after the sctp_addip_param header before processing the embedded address
parameter. Reject malformed parameters when the embedded address length
extends beyond the enclosing parameter bounds.

This prevents out-of-bounds reads when parsing malformed parameters carried
in INIT or ASCONF processing paths.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: sashiko <sashiko-bot@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/7838b86b69f52add28808fb59034c8f992e97b2d.1781043268.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_make_chunk.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index 96ca400120e608..b812d5e9c2ddfb 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2662,6 +2662,9 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		addr_param = param.v + sizeof(struct sctp_addip_param);
+		if (ntohs(addr_param->p.length) >
+		    ntohs(param.p->length) - sizeof(struct sctp_addip_param))
+			break;
 
 		af = sctp_get_af_specific(param_type2af(addr_param->p.type));
 		if (!af)
@@ -3060,13 +3063,16 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
 	union sctp_addr	addr;
 	struct sctp_af *af;
 
-	addr_param = (void *)asconf_param + sizeof(*asconf_param);
-
 	if (asconf_param->param_hdr.type != SCTP_PARAM_ADD_IP &&
 	    asconf_param->param_hdr.type != SCTP_PARAM_DEL_IP &&
 	    asconf_param->param_hdr.type != SCTP_PARAM_SET_PRIMARY)
 		return SCTP_ERROR_UNKNOWN_PARAM;
 
+	addr_param = (void *)asconf_param + sizeof(*asconf_param);
+	if (ntohs(addr_param->p.length) >
+	    ntohs(asconf_param->param_hdr.length) - sizeof(*asconf_param))
+		return SCTP_ERROR_PROTO_VIOLATION;
+
 	switch (addr_param->p.type) {
 	case SCTP_PARAM_IPV6_ADDRESS:
 		if (!asoc->peer.ipv6_address)
-- 
2.53.0



