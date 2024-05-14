Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF971CFB2;
	Tue, 14 May 2024 10:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684081; cv=none; b=IsepKMUc4ux3EyCgqKX2ei+V7UV3svEhSqXyxmeYyiPjhHIYnehwspD54XXDAFuu8iYSlutUco5ANvPWBtTveJfFGj3haCpsZeQJa9ySQJNEIHKo7GDwojChkpC2RG6S1iovIV9syoSCGekdNy7f0/WL+KLZTPENWsBgWLOeRxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684081; c=relaxed/simple;
	bh=bPalp78YuqGu3+su+mqtYErbv4PUgU5OHI5GPnozLjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jU1M+hA8fH8zVh+MF5fH2WvZv/5P6YqXSAVUUtL4fjjdsSd/Zxzu2eOUuvKlk2EtQ1fbqy9XWcSs5IyiUVlplEB4QSz2NE9E1KSopTiMBfeVkE32InwYibjHOXCk5lFazucexsGuF3vCSueEbv2WEPhYxRvcsMRhwjWhiOzkAjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iWq7c00t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iWq7c00t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089EBC2BD10;
	Tue, 14 May 2024 10:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684081;
	bh=bPalp78YuqGu3+su+mqtYErbv4PUgU5OHI5GPnozLjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWq7c00tvUOV/cGgKc7ZkY/m5Cvze2tPKBmxOYfDp+tyogv8plS/7jCOIJq+KCYzW
	 6dkS+lghPsly5+tbafnJ+JNc9VIzKz6M+5Rr2o7klOdFxcVQirdQBvVdE+9huy4nZe
	 gO9PUW45aNxpFQciXJWpEUm/z2UaWmDJFsI1N9Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=CE=95=CE=9B=CE=95=CE=9D=CE=97=20=CE=A4=CE=96=CE=91=CE=92=CE=95=CE=9B=CE=9B=CE=91?= <helentzavellas@yahoo.gr>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.8 322/336] ksmbd: off ipv6only for both ipv4/ipv6 binding
Date: Tue, 14 May 2024 12:18:46 +0200
Message-ID: <20240514101050.780619621@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit cc00bc83f26eb8f2d8d9f56b949b62fd774d8432 upstream.

ΕΛΕΝΗ reported that ksmbd binds to the IPV6 wildcard (::) by default for
ipv4 and ipv6 binding. So IPV4 connections are successful only when
the Linux system parameter bindv6only is set to 0 [default value].
If this parameter is set to 1, then the ipv6 wildcard only represents
any IPV6 address. Samba creates different sockets for ipv4 and ipv6
by default. This patch off sk_ipv6only to support IPV4/IPV6 connections
without creating two sockets.

Cc: stable@vger.kernel.org
Reported-by: ΕΛΕΝΗ ΤΖΑΒΕΛΛΑ <helentzavellas@yahoo.gr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/transport_tcp.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -448,6 +448,10 @@ static int create_socket(struct interfac
 		sin6.sin6_family = PF_INET6;
 		sin6.sin6_addr = in6addr_any;
 		sin6.sin6_port = htons(server_conf.tcp_port);
+
+		lock_sock(ksmbd_socket->sk);
+		ksmbd_socket->sk->sk_ipv6only = false;
+		release_sock(ksmbd_socket->sk);
 	}
 
 	ksmbd_tcp_nodelay(ksmbd_socket);


