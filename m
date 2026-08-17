Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F7F43231F;
	Mon, 17 Aug 2026 15:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980024; cv=none; b=CxK1hPyKW0cSTBDetphyplqyt8qLTR7BFijwh2IoijTB5BKWIVW1QjLU13x+rjmGQ7o41hKKe9/KFTKuSO6MfMPIv7It0URDlB9q2oy3S+9UZ0Yumz7WLQ0OWzbzccmmUCnfiqR6xoqljWS9hQPtrqW2taaaSsZN3AKQCQjflRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980024; c=relaxed/simple;
	bh=E2f9ckRkUX9TMhvjipjSyITz4iNwLy+0eY5eFmtg5Ww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLjpLiFk9751NySHRrbtfnpCN0NevttoZhb9fELXG0YhSXx3IqMYra0xyk1aWPN4TwWewGy4qqMvDCoG+bW+Eq45vB+OFqCbf40cLtnMQ/1NGPFN5EHzxMjQD1I2xtKvwNA0ayIlFmotM2bRPxRB5QY38nlbWTBIiLgNyNArYh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FotPRcTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FotPRcTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C5F1F000E9;
	Mon, 17 Aug 2026 15:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980022;
	bh=YhkVWhbbXA0F9ie7dPGadC38kkJkSzSpotcdX6dCicg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FotPRcTVVzDzH10SSxZ+xlViD86YyCkJBpck+YsiPLdOCZmM6vFWNh1KyGszdQDtH
	 aUjNAtj8h2fE//P4OGeDCOwRj/SytFjLzjvdzxKK/vnnXLpdgoBg+SL6DCc24RkPtb
	 Bs7RxGNB0CXNLH8SJV4bQUmvSyOH+O92fwoeIUs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asim Viladi Oglu Manizada <manizada@pm.me>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 429/609] sctp: prevent peer transport count overflow
Date: Mon, 17 Aug 2026 15:32:05 +0200
Message-ID: <20260817132558.445642616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
@@ -616,6 +616,9 @@ struct sctp_transport *sctp_assoc_add_pe
 		return peer;
 	}
 
+	if (asoc->peer.transport_count == U16_MAX)
+		return NULL;
+
 	peer = sctp_transport_new(asoc->base.net, addr, gfp);
 	if (!peer)
 		return NULL;


