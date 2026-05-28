Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FAF12E7377;
	Thu, 28 May 2026 20:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999830; cv=none; b=Dm2eoDFwixNu4BTEEPiRu5WFTpTy3ETc+iVkIRGpy44OEY75usUQ7CzNLm3KEGd4XIlAczk7DQuegRY7hzsXYIn4vc1WcTJLi70c6d7Mjaois5BF1I4vtRs++Aab6AHadhMYIJEx9UVrIt9kq+3Af1REVgltSQzrffWcKkodYRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999830; c=relaxed/simple;
	bh=sRHshJaA5UK62r7MdnbcGnoecpjJUeYXRKRjFda5Imk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXYNG4GBjurFLIr4ImGjcCSjVWZhRo6PTngj8CGI7dGAZEa/vR3OMrkub0v2BWTUrMpz3aeEtDN5C3EnHQwiFA6k5sfvkRusToD1ENVYOXYAA6cJ/HUpcv4aRmjNKRe3dRgzGf91jWqvVMpWFU0lIGnf+gsltqMn9+vftcChAwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8tTKdhP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8tTKdhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2201F000E9;
	Thu, 28 May 2026 20:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999829;
	bh=osruNj5KGW7GNfb4QiMfLXpQ0UUkFWo+Zr7tmj0nLaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8tTKdhPMKLKeodNZzv8XXeo/GtPSCaTucegkPCZyWmMfrW6lGYqei8aeSUtyxR6g
	 69wX4/99JhynldA8OOdRWoPd11vAe+vj8mMnBXUmL8l30XIcxhglqhpQBxQ5InZtkp
	 yAaOZJUz4ufzxSdxkwyZ5lSyl6+eo36NWR7mO7lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 207/377] tcp: Fix imbalanced icsk_accept_queue count.
Date: Thu, 28 May 2026 21:47:25 +0200
Message-ID: <20260528194644.397197554@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ed773cd488769..c777895a720ee 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1149,7 +1149,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	}
 
 drop:
-	__inet_csk_reqsk_queue_drop(sk_listener, oreq, true);
+	__inet_csk_reqsk_queue_drop(oreq->rsk_listener, oreq, true);
 	reqsk_put(oreq);
 }
 
-- 
2.53.0



