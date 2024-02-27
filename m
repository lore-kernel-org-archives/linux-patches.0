Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235D513B2B3;
	Tue, 27 Feb 2024 13:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041342; cv=none; b=g/tI0TPzJiiEkR2zZL6+XV3OeYP7UIQAeeZzcSiUkjzaLwDhK0uUaqh39xw7rj/0MQl3c/NTj13ou0/ijQSE/6Ll9xn7jf2Y1k9PFpLMK4sOXuBobL/ZnUyWPj9EDTOMEZD/Bsl6Lraq3297s0AdcaHWOEFq3faqTPyVaje1jUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041342; c=relaxed/simple;
	bh=P8nJUmojs0abh3eBkhGFa3TbR+Sw4Hi0RwilH3ea8aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DX6njI3DyIaIfSDukn1aglBGcdTXJsVUd5q+nwYYy3bXvh6mPs1EEQYixWJI8g9gEiTGjVBo2ICHzNDkwAJdkKH1DFYQ3TY+VdrBJZRd0WNTlelAUaJPiZoU4M1kC3+RzWLonkTriZDF/SgCSaLs5JUFSt1Lhb2Vktk3Pp6/eBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0AK5KJ5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0AK5KJ5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C37C433F1;
	Tue, 27 Feb 2024 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041342;
	bh=P8nJUmojs0abh3eBkhGFa3TbR+Sw4Hi0RwilH3ea8aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0AK5KJ5bV1YcDpUYDQrLgdDSKkjQb6OZAa02Ykx17FRcSmSVfP3AJpwlgnAori1nK
	 LByPNwsPqcuTlXAIc5MzK6YGKokwUldpC/5I/QNrRxj9lpj7x1H2wMEk8NPMyMVPLv
	 rMV/UJjzx+Wul3kJx5NJt7mOJIVqVa/avyQ4aGs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 304/334] tls: stop recv() if initial process_rx_list gave us non-DATA
Date: Tue, 27 Feb 2024 14:22:42 +0100
Message-ID: <20240227131640.864842832@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 78aedfc682ba8..43dd0d82b6ed7 100644
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



