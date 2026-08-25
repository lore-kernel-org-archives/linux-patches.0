Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773D840243B;
	Tue, 25 Aug 2026 13:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665453; cv=none; b=e25irxLlILzPAgDikVaVGUAyf+GJ606ke7J0Lfds5ZbuTdgNvvH68/bEFyr6p6dVqt6i0VkzL6hL8dHDt9bDEeGSJVuZvXGgaUPXqCqJxmTpRNZQ2xcoNAGCd2lNK20nJVYql/0bt3tjmw3FNDGZi6sEg22F34lFHMjUJK9WFTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665453; c=relaxed/simple;
	bh=5z3e/VM/R7cd7lQjvLcUMgNXiw7lF2Lw3plyRxPdjNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEYYVaGSlbqthBvONJyyyGM9JZh1Bc0Dw2fj7zGz4a2GU7WVxYYioJ1nz4VExl1ViYknZZMqh9EM+4RmR6bQl861dmug79MUj9gxEagY5PgH3DSONWUjvU3nZ1FdeK+/7lnKJq5Rl0AUCsGp2szmYZkTTpa1S7AZXMbKlLsX4hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LG5QZ59N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LG5QZ59N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2C11F000E9;
	Tue, 25 Aug 2026 13:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665452;
	bh=CrRHwyRcJ9UPlF0sVOscYjqM8qtW3lT0ZmhVUacnMgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LG5QZ59NVDm/Q5vvPkbwI8JIYU0l3JkClCA1OrakXNS12N1ItbkynTA8xjh2ispjX
	 jFbxHk/Cy5XVdh29k3SN325TqpfFldCQtokds6OwJ9XVOe+nm0UbmX+IB6yYKhofFf
	 tHwIL2Y1iPOhdzZKOkcA48Bc3sDdCKYP4o5kh6Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 13/77] inet: frags: publish queues before arming timer
Date: Tue, 25 Aug 2026 15:25:35 +0200
Message-ID: <20260825132542.072325637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 653d7ddf6cba867777a3d14c4f83ace008c5ad13 ]

inet_frag_create() arms the fragment queue timer before inserting the
queue into the fqdir rhashtable. If the namespace fragment timeout is
zero or negative, the timer can run before the queue is published.

The timer callback then marks the queue complete, tries to remove a node
that is not in the hash table yet, and drops the anticipated hash
reference. Creation can subsequently publish the completed queue without
restoring that reference, leaving a stale hash node after the caller drops
the remaining reference.

Publish the queue first and arm the timer while holding the queue lock.
This makes timer expiry wait until the queue is visible in the hash table,
so inet_frag_kill() can remove the node and balance the hash reference.

Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Link: https://patch.msgid.link/bf66785e7c0c139d7a1900e2f01faeeab344b960.1784948849.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_fragment.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -393,8 +393,8 @@ static struct inet_frag_queue *inet_frag
 		*prev = ERR_PTR(-ENOMEM);
 		return NULL;
 	}
-	mod_timer(&q->timer, jiffies + fqdir->timeout);
 
+	spin_lock_bh(&q->lock);
 	*prev = rhashtable_lookup_get_insert_key(&fqdir->rhashtable, &q->key,
 						 &q->node, f->rhash_params);
 	if (*prev) {
@@ -402,13 +402,13 @@ static struct inet_frag_queue *inet_frag
 		 * we need to cancel what inet_frag_alloc()
 		 * anticipated.
 		 */
-		int refs = 1;
-
 		q->flags |= INET_FRAG_COMPLETE;
-		inet_frag_kill(q, &refs);
-		inet_frag_putn(q, refs);
+		spin_unlock_bh(&q->lock);
+		inet_frag_putn(q, 2);
 		return NULL;
 	}
+	mod_timer(&q->timer, jiffies + fqdir->timeout);
+	spin_unlock_bh(&q->lock);
 	return q;
 }
 


