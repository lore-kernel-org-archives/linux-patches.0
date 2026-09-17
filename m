Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CCE58F063;
	Thu, 17 Sep 2026 15:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659740; cv=none; b=rFtyRxKDEydxvKwogEE2znfZw/7JKZGq3gkC5TUdgSvVNxt4vgMDwq7f8ZnkLXcI8T/JeAKUa+j09C9Hmw503fqbVumqauHc17FlAfW0EH5i7VOckc1VNHgMD6tdiIZrDkUAuTdpX3fU4Buy5OoWNzZ0JHYvZ3353yAK4/VyZDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659740; c=relaxed/simple;
	bh=S5u3LhmUiwGcw4UuMcT8Uxl0mcgVTxW4TIE/vDzavew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI5CIfW8rHGLSQlhVzNzSvsV5/LmPcLpJywVOIASofyScHRBu5DG5iuR/jP8pJM9H9X8w2b5ywhQ5WCfoblUQ9c7AvE44jMxqsDo+v2g3ajBdpiCY8kfGdFW1li6sD9q8Wyc0rC+HO/44deiRbVZIO5xwSbnx/yIUQi0xdCH7DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FMKXSjKi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FMKXSjKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C431F000FF;
	Thu, 17 Sep 2026 15:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659732;
	bh=EugBY58bszN3asSPxiVmeCKMIaXkITyWGmSItconrp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMKXSjKi80UcXxaAd4fN9g8F3y9nyyvLiNVMyDfbwmJdYHNNKTHzcLVu8FY6Ms5OR
	 anMgRx1YuGoM5/OL8qligOlXLAF3dKneU+/QQoBFa2tvhapcD5EVhENxgY6wZT7Zls
	 Jtw3M6D48orq10tsnw7LUm1VTrhY7KDcPIjg6v/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 355/733] af_unix: Return immediately when manage_oob() returns NULL for 0-length buffer.
Date: Thu, 17 Sep 2026 16:11:03 +0100
Message-ID: <20260917151400.433853315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4eb086992ae5e..c7a03b01119d7 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2969,7 +2969,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
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



