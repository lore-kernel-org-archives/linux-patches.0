Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC7440FDB9;
	Mon, 17 Aug 2026 14:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977063; cv=none; b=fFHFY+ZwN4xa4ybUdY3QkOkuk79H4Vmi8sheV0kFSpZCuUNKxEyH0f0gPml0dr9PfL/IZS8jI9xEjhIPTGAu1Tf6tZaIgec/eDjetMn+Q9AnwnRtlXydXKWj2Bf5wISoPzloVj0wiRo/JJVX+HLaimVF+O4Z+UfrvfEY0YPIV0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977063; c=relaxed/simple;
	bh=k+1kl77GU+GVYqtHzOF7jUmYSHBUar+DEz1R1TlH8lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Si+rLAjotDalIqlA69W0UAX1GU8yiF6gJLieDwamgHjJFzeI4/Bi5BOo5uSOR48N+vhqLEqF4B6gSVjq60v0ibfkovER8saO4d+9GV0g6DJNc6ydmUz8b/HZjyi7QC2eGitsLbARW1gBIHqTRiIDibVV5QSujSyeWdUugwrt9aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jUCPQABK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jUCPQABK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7DC1F000E9;
	Mon, 17 Aug 2026 14:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977062;
	bh=F4M+pTgW+d0xoTpCwIC9vDmm5ZUyRwGBY7ik0wkC510=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUCPQABKJrBtBPMilVYwlvlKbTKBD+/LPK5Eerg0Kz68XRRLMK+Fgu2XM8WKLUE9W
	 b3Jjs1opYoq0mhFnbx8XIzgvbk9xBOz9cBsWkWjomf4oOwtEEgc+V2eBJ9INqC/h5D
	 lXi1zLz/Z2DDFGh0e6T2iXVelyPTTNKiBeDo3eWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jun Yang <junvyyang@tencent.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 200/456] sctp: dont free the ASCONFs own transport in DEL-IP processing
Date: Mon, 17 Aug 2026 15:29:50 +0200
Message-ID: <20260817132547.941398461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

commit 9b2854f86f0b56e9027d68e7a3fc909d1a9b566f upstream.

sctp_process_asconf() caches the transport the ASCONF chunk is processed
against in asconf->transport (== chunk->transport, set once in sctp_rcv()).
For an ASCONF located through its Address Parameter by
__sctp_rcv_asconf_lookup(), that cached transport corresponds to the
Address Parameter, which need not be the packet's source address.

sctp_process_asconf_param() rejects a DEL-IP for the packet source address
(ADDIP D8, SCTP_ERROR_DEL_SRC_IP), but nothing protects asconf->transport.
A single ASCONF can therefore carry, in order:

    [Address Parameter L] [DEL-IP L] [DEL-IP 0.0.0.0]

where L differs from the source. The DEL-IP for L passes the D8 check and
calls sctp_assoc_rm_peer() on the transport that asconf->transport still
points at, freeing it (RCU-deferred). The following wildcard DEL-IP then
reuses the now-dangling asconf->transport in sctp_assoc_set_primary() and
sctp_assoc_del_nonprimary_peers(): set_primary() dereferences the freed
transport (->ipaddr, ->state) and plants the dangling pointer into
asoc->peer.primary_path / active_path, and del_nonprimary_peers(), keeping
only the pointer that is no longer on the list, removes every real
transport, leaving the association with a transport_count of 0 and
primary_path/active_path pointing at freed memory.

Reject a DEL-IP that targets the transport the ASCONF is being processed
against, mirroring the existing source-address guard, so the wildcard
branch can never reuse a freed transport.

Fixes: 42e30bf3463c ("[SCTP]: Handle the wildcard ADD-IP Address parameter")
Cc: stable@kernel.org
Signed-off-by: Jun Yang <junvyyang@tencent.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/tencent_73762ED1DF08CC9D5F5F61954B01350CFE0A@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/sm_make_chunk.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -3179,6 +3179,12 @@ static __be16 sctp_process_asconf_param(
 		if (!peer)
 			return SCTP_ERROR_DNS_FAILED;
 
+		/* Don't free asconf->transport; a later wildcard DEL-IP
+		 * parameter reuses it.
+		 */
+		if (peer == asconf->transport)
+			return SCTP_ERROR_REQ_REFUSED;
+
 		sctp_assoc_rm_peer(asoc, peer);
 		break;
 	case SCTP_PARAM_SET_PRIMARY:


