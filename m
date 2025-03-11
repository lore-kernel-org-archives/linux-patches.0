Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D375825E805;
	Tue, 11 Mar 2025 15:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705754; cv=none; b=n3nkGs/98/O6/cGWyMZd5IS6hsBoupFEXwBz4XGKQk0iUBkYzHHUOy+DO4a/l/aY3Z0Ndwy6g3Li0Y7p9Ps5LmR8utNg63bVLZB8KLTjcD8jOnOVS/76x22IKsxjZeKI/uq4JGbgFyh7dW+dIHUIWK4XN/qcY1jdg5bunNZVrXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705754; c=relaxed/simple;
	bh=sCSfXoptDpTTxVJhdBxHdRh3Mf4Jckz6kPBtW4p8jrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crtdCOTqY9EsEs9NXWfWE/YnyWnEjflYkBlgCXfXhxvRxm6hy/Zrdmgvh07Np0eJV93jxUNuLWTwTTx+L7zLux/LtaOsYEtgRY7uinooYxcye9erp1abugQn+C+CidcI7BMD+NKduLNDHvLoS0I88qWFJfXdqwiV9aoo9T8Uzg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnJmjpe/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnJmjpe/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5958BC4CEEA;
	Tue, 11 Mar 2025 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705754;
	bh=sCSfXoptDpTTxVJhdBxHdRh3Mf4Jckz6kPBtW4p8jrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cnJmjpe/wvHo7G9jgqXDhcw9seFQNJp1LUL4chq4MdvpRJs6i73SgPHA6G/kNDwyD
	 zMcrneJOhUYAgJBnvM1Wf2Fvswtwqnsg7Xej7FRc3yeWeEybhNVDH43Sifgwx//Vsp
	 JpqhN4BUC3r1wDDrOkiGe2zZ2BeprXjadvialSc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.4 126/328] Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc
Date: Tue, 11 Mar 2025 15:58:16 +0100
Message-ID: <20250311145719.905442254@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1678,7 +1678,8 @@ static struct sock *l2cap_sock_alloc(str
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
-		sock->sk = NULL;
+		if (sock)
+			sock->sk = NULL;
 		return NULL;
 	}
 


