Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAABD44AB61;
	Tue, 21 Jul 2026 21:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669120; cv=none; b=SMzAml3f56fF06VTfFH090WfXGTFCqJ3hJ+9XYaP4bVm/c+5XsenXG+JSFS73KbtP+HcWF3VIQwGC2vX0bp6PFFtBtDWH1sY4GmGCz+BMz6icCcmvcfupCVXXaP9X6Fm653px6EZdcQGP2PT7ukFVRPt1JaMJCszQWb1s/KuLEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669120; c=relaxed/simple;
	bh=g3rJ+82NldUbM2CD1iKkwIB0KFVpRJc3unXlkgwV9pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMwOrES5lPYlRKeJI9Y8RA0kJyUk/v4THpFJtmz1i3zcUFG2u/NSgJMX4M9nVjQikpFAvuXKrn7gAyCcWtH2qqYkgbaSb55TK03yRXkanvgmYOAsSBjzO40mHGAM9Z3I4ob/IcuFj1mfcEgvt/w+J8Yb2Hy+l9Nf067lC8XaJ38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rTO+3wqN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rTO+3wqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1ED1F000E9;
	Tue, 21 Jul 2026 21:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669118;
	bh=x0YpwzPJRKNyUCC9wKKlF3vVGyMHF1gSap/2/kZFMiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rTO+3wqNHqw5zl0kuAJf724OrR37EesFZbOr0c3ipo0bmch0lnc8UWqhKghoY9EHX
	 RtfXR35aqMusv+vOKx3fY5i87o82PS8YbKB+S91khcF+osq9GkdhgN+1RGZWVAATb4
	 JjoI4/fBoLPS1CYQ5FqXV+gXJcxFYvXHUDA3IEnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0435/1067] sctp: validate embedded address parameter length
Date: Tue, 21 Jul 2026 17:17:16 +0200
Message-ID: <20260721152434.346822808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 088764ba47a173..3089d5e577584f 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2670,6 +2670,9 @@ static int sctp_process_param(struct sctp_association *asoc,
 			goto fall_through;
 
 		addr_param = param.v + sizeof(struct sctp_addip_param);
+		if (ntohs(addr_param->p.length) >
+		    ntohs(param.p->length) - sizeof(struct sctp_addip_param))
+			break;
 
 		af = sctp_get_af_specific(param_type2af(addr_param->p.type));
 		if (!af)
@@ -3068,13 +3071,16 @@ static __be16 sctp_process_asconf_param(struct sctp_association *asoc,
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



