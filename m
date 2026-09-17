Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA343CF688;
	Thu, 17 Sep 2026 18:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670761; cv=none; b=N4NcCG5AjyuVNJMpoyGyohsWDxmw3x2GGlfDL10AKRAP8TDXo1fxvIJYPoSkzZAQDybs8VgRE6nKJpnjC7iI5IfXGdUQWCxFEtgNrrtMhFj50D/Dg96pNVygG3FmzTyn9cfGCqe9ovzSRPJnAKJhu89i6rF2Cpup5F2gykuf9K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670761; c=relaxed/simple;
	bh=0/ByBuZLm+hxUCFlveKwKFJCYs9zVkYzol0cUjjlGLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HkEWqODC+MPE2IRe+vRz45tbvGyQdREJMVgtZdVff5g3/9QLm1B2OMmN1JZEkT0D6KEml+Nb7zhJRXDvGeX/hAuTuqActozIeVvrfKKicTu2jEgq+CvMPQZHIcNdgp1nFJAY9yFfv5EKnx5ptFXcFj8M3j7raSwDR+JRyI4uIC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2p8JiVxd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2p8JiVxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD2D11F000FF;
	Thu, 17 Sep 2026 18:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670759;
	bh=gnQmex9B0grDJuy4xn6sG8FISZgw6U9zj8IcoFuS294=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2p8JiVxdCtuo21ID6Oe7TcVj4VScxXI5tmVwvDgaM5Q2+WZUBZn0q5b2IUFyy22Si
	 L+tlRnsR7bV3vKrzTJ2ZsQcIgV0XzjFiKV2GUaqbbqjBujioxYkc5zzNYDxADEsMBI
	 ACYLUd+O7p+O1v1vcvTJGOLRupPWBTx+YycSDmak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0722/1102] af_unix: Return immediately when manage_oob() returns NULL for 0-length buffer.
Date: Thu, 17 Sep 2026 16:11:05 +0100
Message-ID: <20260917151558.479690065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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
index 4f470e142bb7f..6084aa8b65001 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2843,7 +2843,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
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



