Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C897C31159C;
	Thu, 28 May 2026 20:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001421; cv=none; b=Mi+2HR890GBzRNebm9dZlKhjr0FOOMzeKl1BDO9rs0djbQD+s/9O0//caePLZdvq1MYj0MnFwJI/tp7p9G9Z5z4zfIz5GZZ+/RS/LQO40X39XONBwNWeG6lrvm2dXWznKemQZthZDrgJVJ4BatwwFosPEivu8d5R4PfvX/uPXUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001421; c=relaxed/simple;
	bh=TTtrM22bNDWHrcvDZ7zr3H2I2AauPNzWxJ/b+rifeVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZacDc79riWfxjiS2p/8ePA8/bUNE0wCNA5DzyXyy6JQU/ci2Lu9o3VxZZ/iL+cUoXlZcbtCT9hp3E39BxZZYAbEHRSxIaiaaAG0FTa7fikTymqJQShW81X7QGTVcYFZxn2u1A6ubRKzpNqTgNPcmdqT67VbNFhelf3XRsCOfWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+Cbi5dZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+Cbi5dZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D781F000E9;
	Thu, 28 May 2026 20:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001420;
	bh=Ti+6pWcdoQMB0M8XS7wD5W3cZrgeb/805yljlJb97Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e+Cbi5dZ2DwgSZmQ3bJ9vB3bXzbhyZIKKgBrZzFfd4fWaPWsIatA5htsSlOq59HEB
	 VCMSlfbwATCgfX5D0goeznNs/KOYYmsE8Tmx4xN2wRhEH5A8uIS6IrPRZNOySgmLe5
	 X9e/UeYyzVUB8t9+TR0UpazUH/zX6SbblwNZNTV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/186] tcp: Fix imbalanced icsk_accept_queue count.
Date: Thu, 28 May 2026 21:50:02 +0200
Message-ID: <20260528194932.237701238@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 7eca3292cac7c26dad4c236f51ba225c39a0523f ]

When TCP socket migration happens in reqsk_timer_handler(),
@sk_listener will be updated with the new listener.

When we call __inet_csk_reqsk_queue_drop(), the listener must
be the one stored in req->rsk_listener.

The cited commit accidentally replaced oreq->rsk_listener with
sk_listener, leading to imbalanced icsk_accept_queue count.

Let's pass the correct listener to __inet_csk_reqsk_queue_drop().

Fixes: e8c526f2bdf1 ("tcp/dccp: Don't use timer_pending() in reqsk_queue_unlink().")
Reported-by: Damiano Melotti <melotti@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260506035954.1563147-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index a6f9192b4e53c..c7a1f763e464e 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1115,7 +1115,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	}
 
 drop:
-	__inet_csk_reqsk_queue_drop(sk_listener, oreq, true);
+	__inet_csk_reqsk_queue_drop(oreq->rsk_listener, oreq, true);
 	reqsk_put(oreq);
 }
 
-- 
2.53.0



