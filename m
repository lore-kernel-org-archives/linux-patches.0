Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3387A174CA;
	Wed,  9 Aug 2023 11:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80A9C433C8;
	Wed,  9 Aug 2023 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578809;
	bh=YUYDitf/Z523izm81gCjRH4eEjq8XoUSL/2dUowb/gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGghoCrxb5rfZKsOmDKfUrgcYDcD5mkjHjf9c7fRhKoHIb6WeSbHlrJQIBQ8PdaBH
	 Y5snOaBrEnLHrlEgqohKuNuG2OGADA8tjtKMru2zQUkXBv7S9pwIT8nwyoK41ty+Vg
	 CrL2MOJWomuIqeB4yFZYfZQjXhAA/BoO8Ma5oraE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Colitti <lorenzo@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	netdev@vger.kernel.org,
	Laszlo Ersek <lersek@redhat.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 65/92] net: tun_chr_open(): set sk_uid from current_fsuid()
Date: Wed,  9 Aug 2023 12:41:41 +0200
Message-ID: <20230809103635.837589732@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Laszlo Ersek <lersek@redhat.com>

commit 9bc3047374d5bec163e83e743709e23753376f0c upstream.

Commit a096ccca6e50 initializes the "sk_uid" field in the protocol socket
(struct sock) from the "/dev/net/tun" device node's owner UID. Per
original commit 86741ec25462 ("net: core: Add a UID field to struct
sock.", 2016-11-04), that's wrong: the idea is to cache the UID of the
userspace process that creates the socket. Commit 86741ec25462 mentions
socket() and accept(); with "tun", the action that creates the socket is
open("/dev/net/tun").

Therefore the device node's owner UID is irrelevant. In most cases,
"/dev/net/tun" will be owned by root, so in practice, commit a096ccca6e50
has no observable effect:

- before, "sk_uid" would be zero, due to undefined behavior
  (CVE-2023-1076),

- after, "sk_uid" would be zero, due to "/dev/net/tun" being owned by root.

What matters is the (fs)UID of the process performing the open(), so cache
that in "sk_uid".

Cc: Eric Dumazet <edumazet@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pietro Borrello <borrello@diag.uniroma1.it>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Fixes: a096ccca6e50 ("tun: tun_chr_open(): correctly initialize socket uid")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2173435
Signed-off-by: Laszlo Ersek <lersek@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3411,7 +3411,7 @@ static int tun_chr_open(struct inode *in
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
 
-	sock_init_data_uid(&tfile->socket, &tfile->sk, inode->i_uid);
+	sock_init_data_uid(&tfile->socket, &tfile->sk, current_fsuid());
 
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;


