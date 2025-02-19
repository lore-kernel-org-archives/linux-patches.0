Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EC728629E;
	Wed, 19 Feb 2025 09:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957035; cv=none; b=GmPlcmaa70J1BkhEvTI/JqGnk5dviivpxGK+TUAKdHst5KIoJYO9V9ZtRMGIG7dEVBUUMznqGkfrv03umDWm4xoRdK674G8QAcwdTYarhjKDes5gp2nbHcuokoa36LX7II4uHKUH2LvDjF7aWbCGjbza+TEqqYHcUYOPdS43hdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957035; c=relaxed/simple;
	bh=XLWALA2u6SG7harMb6EltYnM3geXn/NvgvzJu+18DXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iV0YLX5zmPEM9V57QZXXX3ylwAdi1lXw8J2lQncsHqzU8geAxaLuu3SO1aB3mgerESnqkMRKTa4AxE+3aK/CRDPPsG4ss0z+PRZq9sAdRW3x7TLei4WXBfD+Gy2TTIK7xtdTyVkSTyxjbV5p2TN/v/GvZoL4IqXSTzi9CaQ3n7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i41HLHan; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i41HLHan"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919BAC4CEE6;
	Wed, 19 Feb 2025 09:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957034;
	bh=XLWALA2u6SG7harMb6EltYnM3geXn/NvgvzJu+18DXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i41HLHanGZ9bnqWMc3IL4/Kj3YyDUm6ovbOHnie+W6SAw9itqILCvl8Xy5JfPJ/aq
	 i8FF8slUoYTwMg5IIBPTi2nJjEyCyJWe28nGUN+KvXDrJyDAsPzv3g3BQziFLeSs2L
	 P+pzZv6pZ9yN6oCKnEXJaC87sjC6G7qB4ZGNtwYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 354/578] Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc
Date: Wed, 19 Feb 2025 09:25:58 +0100
Message-ID: <20250219082706.948535392@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1920,7 +1920,8 @@ static struct sock *l2cap_sock_alloc(str
 	chan = l2cap_chan_create();
 	if (!chan) {
 		sk_free(sk);
-		sock->sk = NULL;
+		if (sock)
+			sock->sk = NULL;
 		return NULL;
 	}
 


