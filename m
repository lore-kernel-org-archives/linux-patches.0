Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5324D178D;
	Thu, 17 Sep 2026 17:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666033; cv=none; b=dbWW+bf4YQVkfK4wVTRbM0cybkmyKRcQhQnIgFgsAZX0cVdaAC7GzQxjZXe37ucQTx1bqFkaCTXgj/CvV88orXaFnI7gFHzvJAXxhkBG5Vs8hr9B0ThP5rmk+7CUhqX+iPeMtMEBZ1TR5oHkRkByZEZw6YQQuXz3C0ioA4Ic2c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666033; c=relaxed/simple;
	bh=pOuScnVqDvysm8kiafMjImoksbVe3hMsbwJBYTmPcFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIb7hXT0PsPEf0VC3MjKC81bDLmOAPWLcCZF2Pew8LIHTG9YvDvv4dperCcFcq+zlXodMjGz+tvJ+vf4PToCYq/IW9a6JyKQ/+7+mZuEpIrPeHeSWZhg1QWuS4Mf9gbLzGXGO4y8dJpBei5lqHs/sbpbx6O/UlnIs7/nGCJPm0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ebB3XoZw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ebB3XoZw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA9F1F000FF;
	Thu, 17 Sep 2026 17:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666031;
	bh=XziEISDYjqHMI23OW3tmU/JF9Cxr9W3ba80p6XDhfPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ebB3XoZwGJRDbO29W8Yi5C7HLCTJS83VtBsfUf2czeTgmD4OfzjnCAWTscyOCVtJc
	 gETyA9onnZW9Ht8rKsyFsxtYeEFJ3VReT9VePqE5FurwJzQRmj1gCeAw8zh96a8be7
	 WnxFQtgIyJgx4ayL6SrIKSUhsQWrDmaY0k41EgxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0863/1250] af_unix: Return immediately when manage_oob() returns NULL for 0-length buffer.
Date: Thu, 17 Sep 2026 16:10:58 +0100
Message-ID: <20260917151615.361257215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

[ Upstream commit 6e5ee08eb5858d175da6768d75d163817b6a9d4a ]

Fahad Alharbi reported that recv(0, MSG_PEEK) triggers busy-wait
in unix_stream_read_generic() if recv() is blocking and the last
skb in the queue is MSG_OOB skb.

In such a situation, TCP returns 0 immediately regardless of
blocking or non-blocking.

Let's follow the behaviour.

Fixes: 314001f0bf92 ("af_unix: Add OOB support")
Reported-by: Fahad Alharbi <fahad@codepure.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260902202202.892676-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f2e35746f0d30..a1e832e531bf3 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2995,7 +2995,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (skb) {
 			skb = manage_oob(skb, &last, sk, flags, copied);
-			if (!skb && copied) {
+			if (!skb && (copied || !state->size)) {
 				unix_state_unlock(sk);
 				break;
 			}
-- 
2.53.0



