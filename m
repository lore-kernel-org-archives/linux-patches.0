Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9559B3BBFD2;
	Wed, 30 Sep 2026 19:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796866; cv=none; b=ks9gMvsNbfaOHoE5EDxcZa4P1q8khy+DpK+QjxZqch4f99vgJVmERfnX40AFrDL4f2R9tUWlAPQPnRgVnsHokbpzlpHBZZLv+XJzgKZxdB6hK1me3CNDp2/YwOF6Wcia8opFYLdG1IqA5IWZ/MMB9hG1RWqqvO5RuG+hgFTBIpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796866; c=relaxed/simple;
	bh=9rXMMVSVHLzAonguI7pNoTUNzQQcj16S1GVVhV1Ng74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dA44ZiADMQTFJBkvoGsx3/rndSkaiVBH13NX/cQv+S7ReBe0itJNQ1ps4955ZiZTvzR3GpEJO8tbRWe2yLG/0MhzTm+NrLG8zXeeITw0u5BfDyyPVXRjLW3pLU0E6zWoIRSc7FmmjS/hy0w1k92Z6dnjp0I1K8q0W2//PF5NwXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hGTnoLSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hGTnoLSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DB81F000FF;
	Wed, 30 Sep 2026 19:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796865;
	bh=D2PvQcMvVq5N/wOPy6Dc/NKSSqNLJmw4KFutxWLN/aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGTnoLSNLMjPHYR9MS87OFEKIxyVfnkVA62MWRZOqy6AYgl4gVSNCWOsNS390U4QV
	 e3LrgehDBGurfekQFKQafPsrJSflOy/4qbzwomyuhn9bxjTwJNhl90SVLGVZSpvlNJ
	 UT6sgYXBvaHbSmj4Qw+EF7VqBc1m+YTdrpGUeUNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1047/1193] nfc: llcp: fix -ENOMEM on connect with zero-length service name
Date: Wed, 30 Sep 2026 17:28:51 +0200
Message-ID: <20260930152457.481576360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 685800e6c36fc..168092326357a 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -759,12 +759,16 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr *_addr,
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



