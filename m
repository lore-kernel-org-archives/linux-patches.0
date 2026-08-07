Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EBC3438B9;
	Fri,  7 Aug 2026 14:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114264; cv=none; b=fYHpsx4SSiTcej0zQ4RpGZEwGMBUrsNfFPoYBvfv/SJqROmHQ8BfU4ySiuj6mVgxqCfUtoyw18Za/l6XfagJIpmQogmaJoPyTjQKBikAXY4QOyBfu11qxlUEiBc2uCAa3zit4iosEY5KgZqAAaUkxD5vwrowwKr8AUMDkC3DkJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114264; c=relaxed/simple;
	bh=2xBGSTMzss1CKorGSD5P1UaTB54u6xi2TqyhqmLS+1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDLPx5ea3QAng366w9YdG+StmTdTiY43RPKY/fA+zCRrHbc4F9tgBzH2jI9vliKOSM48o6JnO7UQSMluVjo1vX+yi769BN0VnwKyUY0NPOSmgWrjYtRX24hfSGJ6dNd9XXjUZW1ccnD2r6Enq+p/tyja07FwSmLIPhaDHwpEDSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9K7nu8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9K7nu8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B541F000E9;
	Fri,  7 Aug 2026 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114257;
	bh=eQ0ozeRwytdzYBoEcA58ImFWevp2TM/CJ5v3dI3cxeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9K7nu8nts+aBMHjirAQSkFA10bwIzNNqxlJLkpPOIIKiqfCpp2ZqIi3Gx3q9Lr/t
	 oC6KZwK2uYgaDvGL/bkfS7+yFuIIsktHcjfsJ2wyzkHvkTN06rQrq9Ht9aNTduTPPu
	 8xyGzmehyFdkSq4+l75PD6P2EK9cwPkoT+RpBrDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 199/337] sctp: prevent peer transport count overflow
Date: Fri,  7 Aug 2026 16:36:42 +0200
Message-ID: <20260807143422.866702458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Asim Viladi Oglu Manizada <manizada@pm.me>

commit bd0e9289e2642f6a5c54faad304ce0f41e926d22 upstream.

sctp_assoc_add_peer() increments the association's 16-bit transport_count
for every new unique peer. Adding the 65,536th transport wraps the count to
zero.

SCTP sock_diag uses transport_count to reserve the INET_DIAG_PEERS payload,
then copies one sockaddr_storage for every entry in transport_addr_list.
After the wrap, a diagnostic dump reserves an empty payload and writes
8 MiB of peer addresses past the skb tail.

Reject a new unique peer when transport_count has reached U16_MAX. Perform
the check after the existing-peer lookup so a duplicate address continues
to return its existing transport at the limit.

Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Cc: stable@vger.kernel.org
Signed-off-by: Asim Viladi Oglu Manizada <manizada@pm.me>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260725032053.521705-1-manizada@pm.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sctp/associola.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -614,6 +614,9 @@ struct sctp_transport *sctp_assoc_add_pe
 		return peer;
 	}
 
+	if (asoc->peer.transport_count == U16_MAX)
+		return NULL;
+
 	peer = sctp_transport_new(asoc->base.net, addr, gfp);
 	if (!peer)
 		return NULL;


