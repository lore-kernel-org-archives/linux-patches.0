Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17444E01E3;
	Wed, 30 Sep 2026 15:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783813; cv=none; b=tKo7HTHxb5C8mL9Nk4y8CP9yR7yrFVy2MmeBdfxhHMc9sDbLLm63EBP0OxkY2PTRuDArPe6z95daKMedAZJ7zoiF7EB+oE8xafd8FTfTKkFgn3bO+eaWfGsNbMCBNcl1DGiZ+AWGHiK87qEKSE0Gbrps5bsp0cK0tYJmyBVtoxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783813; c=relaxed/simple;
	bh=lv5wVOaSyArh79Mtssty9L4u6Na0Z3ketPBcUjS43NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pJyOZjxhGGdQ7mDRJfDbIbxD6k8rFfyQ5T5ANnjJ0UI4sTx9mO+sjdCAOELqwbGhtzEXDCoCQOgJh56z6RVBGnfVIC2b4sYHbHkTWTenfwkaSfERPiy/U7TI50l4X58q4+KdbHJFqGDN77Q2RqaokurD8BXxltFZ4r2EzLzW11g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEX++CE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEX++CE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84ED11F000FF;
	Wed, 30 Sep 2026 15:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783807;
	bh=ylEO38s0+SaPc1sUDBRmIkt0SK2G5wjmRPr31zQ802E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEX++CE2WyiEDlHDQwDFDp9zfsCKf71I9M49RzM1qKchQSVXUO+x85fKVBvlVpswH
	 NvgsNhl5b8Y2V7CubyIBRnHkKdDN+sTq5usru+hoOh+o+Z5RCfHjjcMZquH5k7mFmi
	 0CgIzZcsxXhTVe77TU65uZnj88I3cTv3eji9Q8yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 528/595] nfc: llcp: fix -ENOMEM on connect with zero-length service name
Date: Wed, 30 Sep 2026 17:27:01 +0200
Message-ID: <20260930152359.061482132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ömer Mete Kaya <omermetekaya0@gmail.com>

[ Upstream commit c04981e42d94f39c1dba965cc462a046e946a6c5 ]

When service_name_len is 0, kmemdup() returns ZERO_SIZE_PTR which
passes the NULL check, causing nfc_llcp_send_connect() to attempt
building a zero-length service name TLV and fail with -ENOMEM.

Fix by setting service_name to NULL directly when service_name_len is 0.

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Signed-off-by: Ömer Mete Kaya <omermetekaya0@gmail.com>
Link: https://patch.msgid.link/20260909122029.34081-1-omermetekaya0@gmail.com
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_sock.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 5affde14e5908..f0e722933c1ea 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -761,12 +761,16 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
 	llcp_sock->service_name_len = min_t(unsigned int,
 					    addr->service_name_len,
 					    NFC_LLCP_MAX_SERVICE_NAME);
-	llcp_sock->service_name = kmemdup(addr->service_name,
-					  llcp_sock->service_name_len,
-					  GFP_KERNEL);
-	if (!llcp_sock->service_name) {
-		ret = -ENOMEM;
-		goto sock_llcp_release;
+	if (llcp_sock->service_name_len == 0) {
+		llcp_sock->service_name = NULL;
+	} else {
+		llcp_sock->service_name = kmemdup(addr->service_name,
+						  llcp_sock->service_name_len,
+						  GFP_KERNEL);
+		if (!llcp_sock->service_name) {
+			ret = -ENOMEM;
+			goto sock_llcp_release;
+		}
 	}
 
 	nfc_llcp_sock_link(&local->connecting_sockets, sk);
-- 
2.53.0



