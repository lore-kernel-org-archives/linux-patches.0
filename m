Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE46C3F3265;
	Mon, 17 Aug 2026 14:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976243; cv=none; b=uqmNWgW8Q6Hh0w+fwEltv756RQ4P8vEHlhKjq8kXqF3Q8NrEAK/lnmzj5/yBFJRwQPUepwTzkwgE1m3YWWApmxjj1iu4J/++IPr1iNABHWjruccNgjkHIBN9OZRXzH+Gx36mroDKJHmdNA057vNZGtCLtstsEhU74FvZhUuPT1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976243; c=relaxed/simple;
	bh=zpXLiNGU1at2buVwAs5GXJ1aTLLvLzJT6IC/5vUa8qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qt7L76wHtToawpFIZAuCQe1iRJBBk3khvMqGuKpOYkageUZ45rZ1Embp2KJgsDQZVAaSMLnCVkmrjiERC1u1GTspL3/+4fRFtXq9FR+7bpkRGnuDeXt1qOefwpHJTbPO8MZgpQcmXF/564xGyyYYXKK6bI5JrdPVP/6EGz6s1/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pu62aaM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pu62aaM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BA51F000E9;
	Mon, 17 Aug 2026 14:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976241;
	bh=wvR5tFYXh4fRrghl3+s13IPXX3DSkf5W+v4Dfv++GJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pu62aaM71O3Ow86cqCsBIZf+UPuT3XLmdyw6mfraje8/0HcvD0UnwtYsAad5W7e49
	 gGUZTIR/UHvVvht9zrsg62s5LZyvZPAnLGT5EbDvOXe8u8YiFZ0/jgF56P+kaSd57I
	 224imBomZEEtTaIaaSsTkYDG6wP2zg3fWyAfzGVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 279/389] sctp: prevent peer transport count overflow
Date: Mon, 17 Aug 2026 15:31:58 +0200
Message-ID: <20260817132550.026235696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -613,6 +613,9 @@ struct sctp_transport *sctp_assoc_add_pe
 		return peer;
 	}
 
+	if (asoc->peer.transport_count == U16_MAX)
+		return NULL;
+
 	peer = sctp_transport_new(asoc->base.net, addr, gfp);
 	if (!peer)
 		return NULL;


