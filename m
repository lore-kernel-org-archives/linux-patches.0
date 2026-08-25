Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC23286415;
	Tue, 25 Aug 2026 14:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666489; cv=none; b=usKksTnrJ9MzQTO+VSrIvxtDlL7sMBt1MrauY+xNXRF5dzYHFouNYx5GKWK6g1xlsNJRW3ezL3g1VElMDnlZXvECXjjA75ie9L0vVdC02FepKQshZ627Ak36U27OowQaCc/Kv+DTeZkSgeRCXHBQGg03SDkdvR4R3BeqJbj/pGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666489; c=relaxed/simple;
	bh=O/H1eMxuxgCkNDTU8WxGfmgMEUcSPatAhKJ6ex4GFCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQ4YmcNE2kcAXO93k5BfpYWVXCJYvEtPTXElbwBODPChPEZjdj7BDI0KCByCpVhYDjAWLfXzmfm/MRfxN6rTFIiW5TrpH64Wnu/Li1QgBOFB09KnEgF4Un5mjxhOdYfYFPJL9Ddrwc0/kIXOH5iwJZc08q6XTOsRosD26pdN4Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4yOKz9h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4yOKz9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87EA31F000E9;
	Tue, 25 Aug 2026 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666488;
	bh=tqEwS7Uve7IIG5QPnXR1GyN50rmL6M35MNb2tcWHX70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4yOKz9hCL/V6eLZ7Rb3vcTrc12F2i8RqfWNZfanHfvdzAlUpAybXWJ/LFraOVhfu
	 HMrhtPPFvrc5Uwz+JKrXD5RsiTK+c7y30MCHqmHuI9z4+IFEnmo/nESqBMLOOmLbVO
	 f9DMG/C4sZzG8RYYgeoUDITQU2zgDHTSvw8g5bow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 24/57] inet: frags: publish queues before arming timer
Date: Tue, 25 Aug 2026 15:26:46 +0200
Message-ID: <20260825132542.247712343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 net/ipv4/inet_fragment.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -308,16 +308,18 @@ static struct inet_frag_queue *inet_frag
 		*prev = ERR_PTR(-ENOMEM);
 		return NULL;
 	}
-	mod_timer(&q->timer, jiffies + fqdir->timeout);
 
+	spin_lock_bh(&q->lock);
 	*prev = rhashtable_lookup_get_insert_key(&fqdir->rhashtable, &q->key,
 						 &q->node, f->rhash_params);
 	if (*prev) {
 		q->flags |= INET_FRAG_COMPLETE;
-		inet_frag_kill(q);
+		spin_unlock_bh(&q->lock);
 		inet_frag_destroy(q);
 		return NULL;
 	}
+	mod_timer(&q->timer, jiffies + fqdir->timeout);
+	spin_unlock_bh(&q->lock);
 	return q;
 }
 


