Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3AA9347515;
	Wed, 20 May 2026 18:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301287; cv=none; b=ikgXHN/SNc14wEeTC5DHoFFStbVavNih/1ReF/xdEl78neKK7Y1zge5S6HZ8033qzqXcf65k5blKzfLyBrZK/0duNg6WfZLUiz5mNR847KanhwStkneKVANblOnN1rXSksdOKI/QZ76cYppnRQe6NCvpkwE34mCyH3Qk04uSWZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301287; c=relaxed/simple;
	bh=fYvk+2UZKFwQbZRFi8QvQCE0TMFX18We0SEY2rx8Pt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzII1gW9IQs4uKIi/9y5snWWhSPsllIu8DcJjgfd2Ix8fZcgK6cA//THXavWPloqX6rpG+huUvl4kpmxXKjCmd/JKe41H0Vhg3XjJ+z/QReI3lvCxTy7snAd0b+JAvit/ygkC1RFAk8EV+zD83dIn/dP0aFkJyrTh1xp5lXu8Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hxBIjZBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hxBIjZBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E5A1F000E9;
	Wed, 20 May 2026 18:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301285;
	bh=56FA9mq7aN0jOoAoS53xrXFyT+ZNTyeqok61J0BRiFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxBIjZBq7R6QkqO5GlCS3X8O96PQwtrgG9cvdYXxtwQPPbEC2r3wgryyBd05wN+Yr
	 /rDvQXGEKal+KP6P65TvmrS+r8meLUMoBybyHTX32C0UkNGvPCg0RSvwMzv+E2hRpo
	 j7GOZcGrfZfnDc3+ypFmKIogwPmEFkVHgHILicxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Lee Jones <lee@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 497/666] tipc: fix double-free in tipc_buf_append()
Date: Wed, 20 May 2026 18:21:48 +0200
Message-ID: <20260520162122.033824039@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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



