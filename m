Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86D13624BF;
	Wed, 30 Sep 2026 16:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787287; cv=none; b=GITkUiTLWsNI8Q2PZGgqHA2jZawKhtixvF0ZwvPUy6eaPh+glfg4oVyuF3TlSOUBvWjlgNeea1WTP5SOnKoCW18Adk5roR1usa+LP9SEXJ4tz30ycYE2rqSQjL0/xq99DCJ3ClPJc8dyKuzcbNemlqYc+Ez8lOAHb5ToEtHs2pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787287; c=relaxed/simple;
	bh=Y7zZwaaFSXjlK0SnJqXMvL1XtafDWXrMQvwCUyU9RRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LrW4T/31Tl/bcJPuRVMFlIVLKwbmfsRG746rsBwvRNGBOuBaWw1XbmisUbsBDHP1GGwJH0iAp2SkkNnAnxwpnoLUbqKl6GAKkRds94aIhni34o5tTPUo70kWnymTDnWvt8dNaeGnAFKLE23J1T0oFRhU2ECHuMmq5OFI9XpYc/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcGHOVzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcGHOVzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5056A1F000FF;
	Wed, 30 Sep 2026 16:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787285;
	bh=CmLQNK6O9DDiEXU2PbKcNQQ9MrVNlBo3kFMA5AwcEpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vcGHOVzXSJOJebYtnsTsqL0acswu94B2m2w4UX0QBjQo25a+kmMBPuikiWFAs0oVP
	 IwFpOVqrlWcCYOrx4mtJc7eSzmDRjGqfq7RTBlHLvj4BUxjJEUCoM0U/X3Z5e9Qvq+
	 Emgo/5c+NGunhgEntN9to++9WlNVZGyD8nU5msPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=96mer=20Mete=20Kaya?= <omermetekaya0@gmail.com>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 177/457] nfc: llcp: fix -ENOMEM on connect with zero-length service name
Date: Wed, 30 Sep 2026 17:24:42 +0200
Message-ID: <20260930152349.875314905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index ce6875eb58fbc..1e5ee4bcde684 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -759,12 +759,16 @@ static int llcp_sock_connect(struct socket *sock, struct sockaddr_unsized *_addr
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



