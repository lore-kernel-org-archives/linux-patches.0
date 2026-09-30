Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E78251CF6E;
	Wed, 30 Sep 2026 18:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793145; cv=none; b=DCUE5Y0g1qKlvszQJk1Wb/xZXrZHNVYyLDJTTfSV9QyXfyLymquHKwac2qVp6tL/IAnIwa1GC4FUBA7/hZS8SZodIMwiWi0j99EMFwe7pBsR0+H5u1gffvM2X0aKW4o/+ChIvqP42Fd8nCvjMZHtNRDDRxplg2vdEZigfCejigY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793145; c=relaxed/simple;
	bh=YYLgh8fYgYDzo/jIpq3+lnu64yCvJVaI+sXeVu9VQ4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5Nod1ICqUvL6cZzXUr7cf2PKgYiBNL77RpIc8O8hFy8yEYbmarv5/YFnjTginAu7FZIIzqrK6NTpDL9X3jWVTWQ2dEdnC9VIsXB5Ixos8wnjcH5lVFKrw/nKDO4j01cqymQJQzWe0mS1tVr3FqSoHeGCTVmvoT/Q5y8pe25isE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u//2yn4B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u//2yn4B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34A11F000FF;
	Wed, 30 Sep 2026 18:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793144;
	bh=00CRPyUKB/raSJayaVbTMIGKBNbqMBzPRy/TP7tQRYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u//2yn4BBdzReirrF/TjR3p63IA1XZ4GaESvr5J/4kgazwAMkDAbDNjdqcKb/ja1Q
	 ruK1xWDvk9rwEuBIcMnhE/uOo5bQtTibuazsxXZ05uU+wvyyUf0oKLYldF05fXlHHx
	 Vm7YBH+vwU5l+kWGsvRFqWpXqO8eMJpobForKxfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/395] nfc: llcp: fix -ENOMEM on connect with zero-length service name
Date: Wed, 30 Sep 2026 17:26:53 +0200
Message-ID: <20260930152343.919329481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f9d35711eb9a7..0601ddb4304aa 100644
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



