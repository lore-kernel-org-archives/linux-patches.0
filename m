Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFACB4ED1BF;
	Thu, 17 Sep 2026 18:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668620; cv=none; b=COhvAcPpzgp83LN6dekB+5BT/Tj0l/ml/ieAxWeWguB83QNngyHffxluBBguO7dyyJXnBEPDH6+et6/wEA64jLR7j7hPgA0/jL0I//ENIDK8yecB6tcrFIYlupTrWyiamKiJtzEHzxU+9u8fEnySBAmmiRGfrwi6K8jjvFeLPfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668620; c=relaxed/simple;
	bh=wOemmE+o/gPyuM07hY/35fY28mQGc1P1eZ9CnJpE92g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSjwYGotrxhvLzCT4o/tqpsoIIrXH0kRTlTt8gBHrBIjIWmnuJh7ih8ouyjfmwLbIzBfxzxIxtr5ry1WD20NnP0dtjsPSrdWI+3OuPgUe9YXzuI37BtrieUzSV7eAmmf2Ory32C9RM3d4M10l8EHwnkzwAdy3sIHUt+VZ4fwPGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XM/SCGLR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XM/SCGLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024951F000FF;
	Thu, 17 Sep 2026 18:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668618;
	bh=YqsLGB+HYC+YmVbTOWnuGNyBeZlsSX1C6eMg76C41Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XM/SCGLRkTfZmHOpLdhAi+RgQtwdf7levTS+6pdESvp7Al4A5FW4PO0GSYdcFYPe9
	 hk/H3UiktbHX12at2e+N8vbWSyBeAAFsmVrMT6YAM4p7pMrTeYyCt6n1UxliKrEjSO
	 FA9WXzUYfQHUzZAc5nFr6hQXFYzDrfRxe5Q6CHrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Xin Long <lucien.xin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0485/1102] sctp: fix err_chunk memory leaks in INIT handling
Date: Thu, 17 Sep 2026 16:07:08 +0100
Message-ID: <20260917151551.875791284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

[ Upstream commit 9f58a0a4d6c2ed5d341bba64f058f15d1b0c36f2 ]

When sctp_verify_init() encounters unrecognized parameters, it allocates an
err_chunk to report them. However, this chunk is leaked in several code
paths:

1. In sctp_sf_do_5_1B_init(), if security_sctp_assoc_request() fails after
   sctp_verify_init() has populated err_chunk, the function returns
   immediately without freeing it.

2. In sctp_sf_do_unexpected_init(), the same leak occurs on the
   security_sctp_assoc_request() failure path.

3. In sctp_sf_do_unexpected_init(), on the success path after copying
   unrecognized parameters to the INIT-ACK, the function returns without
   freeing err_chunk, unlike sctp_sf_do_5_1B_init() which properly frees
   it.

Fix all three leaks by adding sctp_chunk_free(err_chunk) calls before
returning in the error paths and on the success path in
sctp_sf_do_unexpected_init().

Fixes: c081d53f97a1 ("security: pass asoc to sctp_assoc_request and sctp_sk_clone")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/0656704f1b0158287c98aec09ba36c83e4a537ab.1781970534.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b9c7d06544c17..5be54b119c39c 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -416,6 +416,8 @@ enum sctp_disposition sctp_sf_do_5_1B_init(struct net *net,
 	/* Update socket peer label if first association. */
 	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
 		sctp_association_free(new_asoc);
+		if (err_chunk)
+			sctp_chunk_free(err_chunk);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
@@ -1607,6 +1609,8 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 	/* Update socket peer label if first association. */
 	if (security_sctp_assoc_request(new_asoc, chunk->skb)) {
 		sctp_association_free(new_asoc);
+		if (err_chunk)
+			sctp_chunk_free(err_chunk);
 		return sctp_sf_pdiscard(net, ep, asoc, type, arg, commands);
 	}
 
@@ -1672,6 +1676,7 @@ static enum sctp_disposition sctp_sf_do_unexpected_init(
 		 * parameter type.
 		 */
 		sctp_addto_chunk(repl, len, unk_param);
+		sctp_chunk_free(err_chunk);
 	}
 
 	sctp_add_cmd_sf(commands, SCTP_CMD_NEW_ASOC, SCTP_ASOC(new_asoc));
-- 
2.53.0



