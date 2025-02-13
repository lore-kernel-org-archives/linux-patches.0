Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE7226B09E;
	Thu, 13 Feb 2025 15:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459177; cv=none; b=eGVLJc6mFSMMRsBhPXMYJdEdjykqY+0LltToPHaZrkA7RPkAXccioRnG+4iJoze7d/eUkYowFpVJbd1RY2xJim048wx/E2sb17JNP9OltRQw7bmQdx37/iRq/vOi6GofPn3aSvCav+u6OVUerOA/q3M3eqtvPV2DjMroaP6LcZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459177; c=relaxed/simple;
	bh=ls+KgVfWpn1jaLwEks6M+iblKbU8/WUsQ0VYpcwJnl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uM9rEAMekI9RFyvP35yjxSMXCOwJLUX1yHQd9DFeMe+58VyMOf1+CoahodepkEr2jWkehOIhSt0qn+oP3cjGDcUT1VAamfnModVebpKrzzfO487MHXqoFF+K+GLDbH03GVLoU3Xxp/tthEpGQPURXjnZdtsSROytH0a5LeRJvik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CF1XZ9k/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CF1XZ9k/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78ADBC4CED1;
	Thu, 13 Feb 2025 15:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459177;
	bh=ls+KgVfWpn1jaLwEks6M+iblKbU8/WUsQ0VYpcwJnl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CF1XZ9k/EkbDmVEHlWV0qAuzK4cg/3kZt8LibFQf0Poo2PspS42gXBMG6QG4Yj3+6
	 I4ezrT/gL5GIO0TMeizP0+IXlpuiC/bzYxrneINnrGv3DXUkqgK5OC8iEmg3u6ihl4
	 O1zC8iG5QaIDQ/9gh7FCv8M2QPDhj8MR6EHkR0IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.13 189/443] Bluetooth: L2CAP: handle NULL sock pointer in l2cap_sock_alloc
Date: Thu, 13 Feb 2025 15:25:54 +0100
Message-ID: <20250213142447.906928949@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
 


