Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B32B2D023;
	Mon, 10 Mar 2025 17:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629348; cv=none; b=trcjvBgS3O1q+HpUVb7iGJykX4NEE70z7KLoqTz0XvkTkqlI1jXAGJ/DSqQel2J9xO4X7IZMo1K9xZUF+HjHg363+7ZZxdZGnDax0X1feoqME8oThSOVCGimq9U0lT8YBPgpRW+mUkvlIsZCaDQ+zHnIKV1sHDK1dxWFzJTa2UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629348; c=relaxed/simple;
	bh=1RhGR5OqQo6extM0cYqR3llZcfEeHAmgEJpKhfVDtok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVHJ91pAiYQhBnoQAZUrTa9jBjX9H4qhu/shGX82ZUB7PcaQGLxNmlOwU8hvecdtCLdZ6sq3lVQveXVQmJVEWqUKu4Mklo5SchZ+nohRoqio04JTPJoJmnuGHRxHIUvlzMczkHY7rid73D+y4flrc4cPc4LhKHlluJMEkM9NqCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tklSLXG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tklSLXG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64F0C4CEE5;
	Mon, 10 Mar 2025 17:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629348;
	bh=1RhGR5OqQo6extM0cYqR3llZcfEeHAmgEJpKhfVDtok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tklSLXG/NjOCzpo06URUARgi6IiDVpNliWiaUWxNrYHbb0Mia1e3fdCpAO2NQXBK4
	 IycJJHhu/8Vyag+e/Nnhyle8TXpP7SngeuBQxhG5zI1VX9fqrEdX8FecxDwlgM5Sn3
	 3dT6IRFNfz4CkbnIU8Zrc5QEgbBsOkTqyJJehDFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 5.15 264/620] Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc
Date: Mon, 10 Mar 2025 18:01:50 +0100
Message-ID: <20250310170556.045939407@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1876,7 +1876,8 @@ static struct sock *l2cap_sock_alloc(str
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
-		sock->sk = NULL;
+		if (sock)
+			sock->sk = NULL;
 		return NULL;
 	}
 


