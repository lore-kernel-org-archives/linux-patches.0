Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23A727A476;
	Thu, 28 May 2026 20:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998566; cv=none; b=gjc5Vn9oDuIkH6/xVC42Gj8pc3ubGvjc3lfZLVzZX6A3CveHRZ2Cd2HNdREnIvCzX5UkKJGOy20jT3rLEDMV0FBZvrRY1rFvak8wSMcMZfFqjw0yHqhhUK3FFKNmgmcwza4+ulE21ENBkBACVU6wbDH49oP/AJqsy2yWqZP/NYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998566; c=relaxed/simple;
	bh=WiauIgBi67mwYCq9glkhQ/bd3PQG+4auCxpR/ShrgNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xpj/kzFEjWRNu8VPD0aHL/k7Fc8mQzOvB4O26tc3pgrfJgQXdUZPRX1Ust0rQZtqwD//6QOiq/vk0WigEePaPdZ1wszLO4YqU+hkL12MiLVVVuSq69CPmIU1sA6Ul1NFKO4xOa8fwRyCVFQ259TOX6XH6rH3dOzkCd07rjq9+Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otMFgo7q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otMFgo7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DCED1F000E9;
	Thu, 28 May 2026 20:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998565;
	bh=lS4AlI939tj7wH4NFjkHV3GN+u9q3Z+SQCNNvm4CuME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otMFgo7q1R2Rvs74+Kngp2mFjb5RlKdkypSNYAiorruvxX1N2Knt55wsayVNEbMYd
	 dZNbDBivYzMG3DCjlsnrar8U20DOSI+SrAasfFsYP4U/ytP7L4AQ5fNYDlzywbfyCS
	 f+Yh3McWAZllFGVfu3TjnA0I+B1dlWjGNGnRlBjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 219/461] tcp: Fix imbalanced icsk_accept_queue count.
Date: Thu, 28 May 2026 21:45:48 +0200
Message-ID: <20260528194653.469931447@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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
index bc987a59a0952..f1988fd503540 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1137,7 +1137,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	}
 
 drop:
-	__inet_csk_reqsk_queue_drop(sk_listener, oreq, true);
+	__inet_csk_reqsk_queue_drop(oreq->rsk_listener, oreq, true);
 	reqsk_put(oreq);
 }
 
-- 
2.53.0



