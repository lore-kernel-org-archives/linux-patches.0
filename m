Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB2F1468E5;
	Tue, 27 Feb 2024 14:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044242; cv=none; b=jgfqZyxUQa/LQKVB6co230vQSgBVuIJ8EdZ7CAHd2FKOBKyoovdqFd3Um8PA0ji1HMeDbnLz/FEAz2v3k7gJ1Qg4Wcdw7alvrq8leXOuotBLEe/Jh8ki+gHHNYee9e39VFrSh3HBcH9koDsYXmlEauxehR+NX7xWUwpFYuT8L14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044242; c=relaxed/simple;
	bh=+JsjHQ7Ztu7XkysDY4jsHOPPO/niDzKJtQbgM6vXb7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FC+cHQlYbKJl7s8/X4wBWl95cZnXTWEIhmZvdfKNqbXs+zrU18X+sn2P8sfcQPTUnfx5TYYSia/ku24tici00IpNPolL6oRZUpWOxwCRxt1GvQg9ldTQ7u1+pzxByLIFmfaoFYmJhkxlm8lXDXdU6z+OW4qWxeeJ0/CTuN78+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCFFTyKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCFFTyKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3D1C433C7;
	Tue, 27 Feb 2024 14:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044241;
	bh=+JsjHQ7Ztu7XkysDY4jsHOPPO/niDzKJtQbgM6vXb7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCFFTyKoWAcCll8UDVg1W3IUWXjJlOZIrQMBqFU6Kw3sBKovT6w1jutpxGIMvo6tP
	 Y3ppRlVVDyZVsVP/X9+XuYSk9KYIWyzf7IPz29MLOrhg3ksNWdVuGDYf+ijOEbx0wy
	 gJ35Qlfw5crBByXaAxQ0Tma7S83NRriBTfxiVW5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/122] tls: stop recv() if initial process_rx_list gave us non-DATA
Date: Tue, 27 Feb 2024 14:27:55 +0100
Message-ID: <20240227131602.433947198@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 732f96b7bafc8..46f1c19f7c60b 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1786,7 +1786,7 @@ int tls_sw_recvmsg(struct sock *sk,
 	}
 
 	copied = err;
-	if (len <= copied)
+	if (len <= copied || (copied && control != TLS_RECORD_TYPE_DATA))
 		goto end;
 
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-- 
2.43.0



