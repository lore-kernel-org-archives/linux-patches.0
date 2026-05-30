Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C553161A3;
	Sat, 30 May 2026 17:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161767; cv=none; b=gNYWp+5yl6tfWPZClxpSRH5Jvqr62BFxwfecOpnJLJOEBoR7r8Bse4EqitFKXPFxQsWe+GYZFvBPb7Hb/UdDgULQOZhmxtS8ixCzRKJqViY8nkeKJcz1abWBVWJCrcNMB6hXc0gpXFeMgEyvqseXiAUTVlIKUtrNO8VKyZ9Aa3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161767; c=relaxed/simple;
	bh=5LWKTSfpDDvTunAj5vgUPKWWktivGeOlLwrd5ZhSIik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNOcoG7cPx246F7JFdxDrXvpgYTC5rZKV/dIDXKjx5rdMvQQ7yD/FK21gri/OIwkI9LrnCf2TEuZmrHVSnBjJG0btuqme2W3FuWcgbbwfLoIS+iwCuFY2tdy9iFI1xc8r0v3CvItzzPVDSmh6NISBOl/NwJR1mK/HNSgEE8qcps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MbWhjNwc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MbWhjNwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69631F00893;
	Sat, 30 May 2026 17:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161766;
	bh=g0EHwQ+r95DHrZKU04Em0f0pXB1mngC/duZTAWpFDkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MbWhjNwcdRu6Ac68Nw9WwD58cCLajasMtDjH8pDTH4HOgE8yydHGnnKm0U6u57GYA
	 IiB2Gv/f5NDzhFEecI6CgZJLBLyeo4iv5qgdCXqEUXWXDwb2yPcKSmbR8nONj8n49t
	 HNGfCpKvSpzk5uSD2bUKWelE4VGSl4TaVaZfI0hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Lee Jones <lee@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 720/969] tipc: fix double-free in tipc_buf_append()
Date: Sat, 30 May 2026 18:04:04 +0200
Message-ID: <20260530160320.419978243@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit d293ca716e7d5dffdaecaf6b9b2f857a33dc3d3a ]

tipc_msg_validate() can potentially reallocate the skb it is validating,
freeing the old one.  In tipc_buf_append(), it was being called with a
pointer to a local variable which was a copy of the caller's skb
pointer.

If the skb was reallocated and validation subsequently failed, the error
handling path would free the original skb pointer, which had already
been freed, leading to double-free.

Fix this by checking if head now points to a newly allocated reassembled
skb.  If it does, reassign *headbuf for later freeing operations.

Fixes: d618d09a68e4 ("tipc: enforce valid ratio between skb truesize and contents")
Suggested-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/msg.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 76284fc538ebd..b0bba0feef564 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -177,8 +177,20 @@ int tipc_buf_append(struct sk_buff **headbuf, struct sk_buff **buf)
 
 	if (fragid == LAST_FRAGMENT) {
 		TIPC_SKB_CB(head)->validated = 0;
-		if (unlikely(!tipc_msg_validate(&head)))
+
+		/* If the reassembled skb has been freed in
+		 * tipc_msg_validate() because of an invalid truesize,
+		 * then head will point to a newly allocated reassembled
+		 * skb, while *headbuf points to freed reassembled skb.
+		 * In such cases, correct *headbuf for freeing the newly
+		 * allocated reassembled skb later.
+		 */
+		if (unlikely(!tipc_msg_validate(&head))) {
+			if (head != *headbuf)
+				*headbuf = head;
 			goto err;
+		}
+
 		*buf = head;
 		TIPC_SKB_CB(head)->tail = NULL;
 		*headbuf = NULL;
-- 
2.53.0



