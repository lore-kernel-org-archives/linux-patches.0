Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82473F44CD;
	Wed, 20 May 2026 17:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296599; cv=none; b=aU8uIDxh8OG915BlAPEbN3iMMescRPqHo8Ki1lVWbgJ/G2sm2vByePgTUQjDuQ2Ix6IC1xT1mka3vczo1Vj4DWwcLe3AXf7eb+Cwe/yxztYj7IM/BbfHdOUxFmfjWGPo4nV4y9Y74yz1ASond/1KjPWG/AzdVuswDQ96V0i17Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296599; c=relaxed/simple;
	bh=QVkxKqt2r6rXyT6GNSyMAsOJfCW9QP/11Pq/dZ/SLUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QpJiVXWv4pPOz0o3TetxvNRjlb4pKH/SfS4yVpCu2XnK/Xre8eoxHVWKRJhW/fG0wwpYJtyCGjOxqfELtJBJWsJWsz6il3k+RCih/s2GOEnc4WuAVxicvPUz5OXhF+FWujbEIfqzitzE+jwdZwE8wE9VZJ+VdLgK4etJRwRrb+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GkiUaci7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GkiUaci7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F9A1F00893;
	Wed, 20 May 2026 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296598;
	bh=H5yrrVKiv7DROouxisnXSOp5W5qpjzG9Vm3JMRgqkBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GkiUaci7aHHR32Mg24GamO2ZvpmSpKPGBOXfaBOrkzIJoPXtCCEKHKlCLXs8bE9hl
	 Ik16vg4AGGFlD1YedaBAJIom3g/LN8HCR95J0A/cyrI6Gz+Pr+pbTAdoa0mzZh0Pop
	 h8yzid5SfFACwojRJ9HFh4yueGhSY/5CD/48jIyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Lee Jones <lee@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0859/1146] tipc: fix double-free in tipc_buf_append()
Date: Wed, 20 May 2026 18:18:29 +0200
Message-ID: <20260520162207.679324914@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



