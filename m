Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E5C47253F;
	Tue, 21 Jul 2026 20:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665574; cv=none; b=Hf5Pnl26t45S86XJj/A/9T+P43kHEyG6hMfhH/utYoPx/296poHpBI2hw1yIFFnaUZUoVj+Bx3zAVYrdOENtCLJHGjh3GvzPM31R+ts01m7hkH+kPooJucnvvw93nonObw33ZhzyfSk2KI9iLv8F93f/1X3pRXkL6QQk8ldvBMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665574; c=relaxed/simple;
	bh=ZjyE3y4cSfNEbboxdDvHTf4EiLE0qfoJJcPx5KP0aPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9hARTzrJHa2z5+x7sy15YBvXU4jM44tztIb9DkOUuYpedankWjOvYfupYQhm0xHRuJ8W5ItoBkRGdTCGIyGsQjnmVG4eNdn6PHND8qHYMq9ordZPI9oCOYOalW6DgPLVKKIu0LPdmnigOlrwNpuYOLsea8gNoR62KFvHvxkQ6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHPUyIXY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHPUyIXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFA01F00A3A;
	Tue, 21 Jul 2026 20:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665570;
	bh=mvgnU2y8eklDVf9C6wDEPPIqAObgT7XSOeJpWej+kLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHPUyIXY7exYtV1C1Y0nIdZqUAiVkyVtlyAXk+dWSePi7e08yllhRabMMYcwXF/OQ
	 YOSf6pizXEz8K3saxK2jnT1HGGrGtGv3QWqG2xkNebfiIomaKA+jx/SeNiGYzwbZoD
	 9M6MSh4c0ZVJDpebv5TTV6V2C1LIn68ZcCiewXFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0353/1266] rxrpc: Fix leak of released call in recvmsg(MSG_PEEK)
Date: Tue, 21 Jul 2026 17:13:10 +0200
Message-ID: <20260721152449.731491038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 4bdb9e471f5b1ac9cbe4add5de7ff085a0ec303c upstream.

Fix rxrpc_recvmsg() to also drop the ref it holds on an already-released
call if MSG_PEEK is in force (the function holds a ref on the call
irrespective of whether MSG_PEEK is specified or not).

Fixes: 962fb1f651c2 ("rxrpc: Fix recv-recv race of completed call")
Link: https://sashiko.dev/#/patchset/20260616155749.2125907-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Jeffrey Altman <jaltman@auristor.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20260624163819.3017002-11-dhowells@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -429,8 +429,7 @@ try_again:
 	if (test_bit(RXRPC_CALL_RELEASED, &call->flags)) {
 		rxrpc_see_call(call, rxrpc_call_see_already_released);
 		mutex_unlock(&call->user_mutex);
-		if (!(flags & MSG_PEEK))
-			rxrpc_put_call(call, rxrpc_call_put_recvmsg);
+		rxrpc_put_call(call, rxrpc_call_put_recvmsg);
 		goto try_again;
 	}
 


