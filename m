Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D7B27466A;
	Fri,  7 Aug 2026 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116199; cv=none; b=OUTsyBAInXeMsS1L/KUueNe277O8VcJnwbCsURaPGXzuCzg+mrSnpdg1EnIoISL0QJlsCxerSxZlx9sDBw0kC0blHIhPSeb3SEiLDNUhZyCYJZ1tcw79zVYik5cX6TLtwtEwYE1XNu8j54ThD5Ng1skmKa0rY+frPcL8IpQ6/RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116199; c=relaxed/simple;
	bh=uoJi/oGDVmy+25rwrm+bNGNc0a5WldAY63EluyGjves=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQUdxJkcHTt+uaLfCaDH4cc/UXNtfT5CKtnf7Ts4envPItQnkXKlXAjnmVEwFheac/LpTEPdufOtvJtAD0wWMQlRhjlxbFgnE51DgpvU5EyrGyDL+98U/rrhVMaubloMgqMFoAMOpZ8dN8+jBskgo5goJvG4g/if2gZpX3Zw2VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amqM2+M/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amqM2+M/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506031F000E9;
	Fri,  7 Aug 2026 15:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116197;
	bh=55FQ8OvibKktslOK9Uxsg1xDJ0UqHq2b+TXwqEK6wqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amqM2+M/wT2v7o7OOELqRn515lYOowsBz3FTijBtvO6ams62Q3mim5mCjSl1lCF1p
	 YfgngjHxVVJANwBZIc9IUC2TlkZH3fmq7GrdR3hrOO90bxc8JvfoO6+UrS+r4fTPfk
	 NnjhSDiwqTbDRtDU5h/aoQp4vIYcZzhJ9B7ul1mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 146/261] sctp: prevent peer transport count overflow
Date: Fri,  7 Aug 2026 16:38:23 +0200
Message-ID: <20260807143418.514573385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


