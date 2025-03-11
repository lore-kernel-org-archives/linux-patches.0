Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D207325DD08;
	Tue, 11 Mar 2025 15:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706808; cv=none; b=uHRfXaAnPJTJe3fnLx+iBCVSmxoI04V9gQQsnrKk4erXr0FuLWDfAITE9YjyVbWs2xON9oijSrdC5elISxQyMLXXMVHGo9XzhblxBUqInvfADG9xf+17RLX/0iAA0OWKa4Q7PcPPaZUKqWuV39krT4N06DMBLGsDf1yAnSrfJsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706808; c=relaxed/simple;
	bh=FxAXkT/fBNEetaaG612kn7Mrh52qH3pXZ9WO4HeZxSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kxps9ijUVYYSd6175vrqQZSoGUbUjAEX1u7uKeqnMKLs+0GXYEB/kPNNj8RSHIUo6WYEX29VGmkn3ZQ6BEYEWHum87Rs2mEeG28IkysjTXxwyROFWB6KF1EzcQHNmktg4fRU9L/RAHceJ1AHxTvCqxh68mkE5Jrvi9k3P/iKtxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMxMnSjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMxMnSjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596B0C4CEE9;
	Tue, 11 Mar 2025 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706808;
	bh=FxAXkT/fBNEetaaG612kn7Mrh52qH3pXZ9WO4HeZxSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMxMnSjEEdzfWsIhqGWR9eBTCq5jxrqRAaDJXVuCnAbf5SFEoU7X4U2eYwWZwG8LX
	 Hs43XSFaLvLroEo1vtr8GNNnzKP+EN+QviYHhlKR7QslltqgltCdqWVo2LzlXNmHeL
	 WyddElY+mIIH5iKeWgey6wTPphZMi2D/Fi6hDvLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.10 173/462] Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc
Date: Tue, 11 Mar 2025 15:57:19 +0100
Message-ID: <20250311145805.191063064@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 5f397409f8ee5bc82901eeaf799e1cbc4f8edcf1 upstream.

A NULL sock pointer is passed into l2cap_sock_alloc() when it is called
from l2cap_sock_new_connection_cb() and the error handling paths should
also be aware of it.

Seemingly a more elegant solution would be to swap bt_sock_alloc() and
l2cap_chan_create() calls since they are not interdependent to that moment
but then l2cap_chan_create() adds the soon to be deallocated and still
dummy-initialized channel to the global list accessible by many L2CAP
paths. The channel would be removed from the list in short period of time
but be a bit more straight-forward here and just check for NULL instead of
changing the order of function calls.

Found by Linux Verification Center (linuxtesting.org) with SVACE static
analysis tool.

Fixes: 7c4f78cdb8e7 ("Bluetooth: L2CAP: do not leave dangling sk pointer on error in l2cap_sock_create()")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/l2cap_sock.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1864,7 +1864,8 @@ static struct sock *l2cap_sock_alloc(str
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
-		sock->sk = NULL;
+		if (sock)
+			sock->sk = NULL;
 		return NULL;
 	}
 


