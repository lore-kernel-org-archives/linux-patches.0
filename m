Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32664281349;
	Thu, 13 Feb 2025 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457638; cv=none; b=RsBm3e5r9Mn2NX7uTfRN3fi+DXMdUqniHBsQmve9Sj5SBzpcUmZon1ZJ9eIm/TVL6RzZ4MnlVXdiv/4c/V82B8HeNVK/4XqeHOu6pgvEysRJ8Yrtq63/0Tr3H9CIGm/IMuIFPzXlYBujzzbe+hU9fRdLsDiiXar0jcc+rOpQ6zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457638; c=relaxed/simple;
	bh=lbBu58Yt9/ylhylbkwUrccUF1bWAS9BbUln15PlF9aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HinVEllh+AhQyxqzfh913+a1+BzaQigBbz6vLcAyhrLPgWkpstZn6oPX2qtW8ZV7YXLHmWlzn+Vda3PJXpIsUqKg+IHQpH6rgSFXlzxw17Ovvvcgpvv2/iMxxj5gx8xVb6Ybc3KSziHG/k4scOZB+/q0GI7VxpevZdRVdNMR6+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T4RTKN5q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T4RTKN5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CF5C4CEE4;
	Thu, 13 Feb 2025 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457638;
	bh=lbBu58Yt9/ylhylbkwUrccUF1bWAS9BbUln15PlF9aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T4RTKN5q7yRC7VqEsvTcHDjSAZYxLDauKSJL5z3NAvfamRnHGC1hcvoZ7p3ptfo0d
	 8gawd+M0O/KOjPOHz1ci+sJCIp87wl92G49EXqAsgFej9hpn/staORrnSTkO1k7xKO
	 hfnfU03VJTOq8xJ4oIsDoz8ldi/6yf/kAMRnJZEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 170/422] Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc
Date: Thu, 13 Feb 2025 15:25:19 +0100
Message-ID: <20250213142443.104750688@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1888,7 +1888,8 @@ static struct sock *l2cap_sock_alloc(str
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
-		sock->sk = NULL;
+		if (sock)
+			sock->sk = NULL;
 		return NULL;
 	}
 


