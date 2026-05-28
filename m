Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA80932AAD6;
	Thu, 28 May 2026 20:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000809; cv=none; b=UCdEuWGeXs4vAVptK3Nr4WDJWazyvkyrCkxkoPkDJJSQKp4JnsLomck+st69NC1fnblQvjY/Ayy89Mh/ht0onaK2TS9CrFpjEqEymgI7MELGDgWwLXV0vi1HaEfu7IwVBKuEfL9IrO8vCR8QX6I5T9QKwl/Zm58OGGDzfJwBKyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000809; c=relaxed/simple;
	bh=oDdAkUtY1mh/QCtR9/mY5gUvnXCOK1Bp1k68KSgNePU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtJ0ZYcpUB+FijjhgTZY53zpGuUAYZ2lgx7AOLaMroC7Snhu8jzUpUzSw1He7KoHbDh/VU5bY+ZEdVvRUuFvbmZNUbfEdvFihTb8kIAr3dZjxEjbBQB1Bb7bz5ky3cZe6sXTOS9gcuSKZHwJUwLSJA/3GX8KyuqOO0waWejGZLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07SuO69V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07SuO69V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F6A1F00A3C;
	Thu, 28 May 2026 20:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000808;
	bh=x9+WgMN1YiGV2D2w5b0Lhq7/ofrak+2J4gbHghfSQaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07SuO69Vh9I839Iy9Ow2I+CYeW00UcJJmFfJ+wEVikvZGgaPfyC8rX8sOIGhrSBjf
	 nJ8TBxzBc8ZHARdQ9n0gNt6qrySVUyXMBItGRBNfq/7duIayHrqWEQG1Hnjwseb07F
	 owMZAORu296UX30jiRFiKJplnTYzgANsLroVEWOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damiano Melotti <melotti@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/272] tcp: Fix imbalanced icsk_accept_queue count.
Date: Thu, 28 May 2026 21:49:11 +0200
Message-ID: <20260528194634.262413839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
index bf4e5f49030b7..dd39cabb39001 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1172,7 +1172,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	}
 
 drop:
-	__inet_csk_reqsk_queue_drop(sk_listener, oreq, true);
+	__inet_csk_reqsk_queue_drop(oreq->rsk_listener, oreq, true);
 	reqsk_put(oreq);
 }
 
-- 
2.53.0



