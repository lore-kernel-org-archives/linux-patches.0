Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8978F13AA50;
	Tue, 27 Feb 2024 13:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042366; cv=none; b=X8hbrxd9vbNs9PC1c6R5oKNFO4HSlu4ZAUHVM7jbRNokzju+ryyfnIiw7C+czKcDAXoFrFyiyB7IVXp8mSa9DpxB9ajJZNRQP0DTocn78zHXoy7B/5iB5KRCUwoMkSraXc0mHTHBOiX0FPyYZ898UraCjI/tVZAwZAwJIdmdDI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042366; c=relaxed/simple;
	bh=piaMy1mgF9R7hcsBK8a3F0xMdl7BYb2zL0n5wq4tfPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka3cdNXXsYyXtnXoiBWWCLymf9gHZsaEmMjuOj8Gfa91gNqehO68WbkOt7dHQ8Xz3v7pE14n7IiWsOKN5rK8J4ysTOsuc6My0SOxc1UdlE5ClG11JbDZIifLcKLyz1JzaXW1myCzvBmLQO5RicqzMEDxP0C8rXWiOKl/Y5VpYto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2pZQHFZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2pZQHFZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3201C433F1;
	Tue, 27 Feb 2024 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042366;
	bh=piaMy1mgF9R7hcsBK8a3F0xMdl7BYb2zL0n5wq4tfPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pZQHFZXG+IJSY9BjIsi0f7nCeVZjzJuPPVGriTGgolPv/G2oJHpZM5WcNbBg3B2U
	 nqWdwze5jfqSflTXUlKHYFwFBBCGqYeIiIUY+not/ta1CrcvyM9PW26PZnfWUl+Ll/
	 HCbTyh71RoUbW1hSOxq9cDXZdmfkK6/2Lgc9k9G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 269/299] tls: stop recv() if initial process_rx_list gave us non-DATA
Date: Tue, 27 Feb 2024 14:26:20 +0100
Message-ID: <20240227131634.341203243@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit fdfbaec5923d9359698cbb286bc0deadbb717504 ]

If we have a non-DATA record on the rx_list and another record of the
same type still on the queue, we will end up merging them:
 - process_rx_list copies the non-DATA record
 - we start the loop and process the first available record since it's
   of the same type
 - we break out of the loop since the record was not DATA

Just check the record type and jump to the end in case process_rx_list
did some work.

Fixes: 692d7b5d1f91 ("tls: Fix recvmsg() to be able to peek across multiple records")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/bd31449e43bd4b6ff546f5c51cf958c31c511deb.1708007371.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 67c8323b7cd11..a83b6119f3826 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1971,7 +1971,7 @@ int tls_sw_recvmsg(struct sock *sk,
 		goto end;
 
 	copied = err;
-	if (len <= copied)
+	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA))
 		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-- 
2.43.0



