Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC20BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A98C433D2;
	Tue,  7 Mar 2023 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215045;
	bh=ZIpNuULzftL8Fdon/rh2CxpefKTdPD1QcyxzP8E5EXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0q/WFfC38uH/c2Yh7YI8VxZInD3JnyHd+HYTt8oUQOvMHAt9Aq/6Dabg0n7uoeQV
	 6FtLPvlCGJx2EOj/LnXbpHJXBEzt14RdisAW45TecLAyM5bTSmoW7HNzM/jHcvB0qq
	 imt/0+1ALc5c/5IvKEr+ZnTjNI5PKS5uRLSeYCRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/567] tun: tun_chr_open(): correctly initialize socket uid
Date: Tue,  7 Mar 2023 17:57:50 +0100
Message-Id: <20230307165911.708313331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pietro Borrello <borrello@diag.uniroma1.it>

[ Upstream commit a096ccca6e503a5c575717ff8a36ace27510ab0a ]

sock_init_data() assumes that the `struct socket` passed in input is
contained in a `struct socket_alloc` allocated with sock_alloc().
However, tun_chr_open() passes a `struct socket` embedded in a `struct
tun_file` allocated with sk_alloc().
This causes a type confusion when issuing a container_of() with
SOCK_INODE() in sock_init_data() which results in assigning a wrong
sk_uid to the `struct sock` in input.
On default configuration, the type confused field overlaps with the
high 4 bytes of `struct tun_struct __rcu *tun` of `struct tun_file`,
NULL at the time of call, which makes the uid of all tun sockets 0,
i.e., the root one.
Fix the assignment by using sock_init_data_uid().

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a1dda57c812dd..30eea8270c9b2 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3411,7 +3411,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
 
-	sock_init_data(&tfile->socket, &tfile->sk);
+	sock_init_data_uid(&tfile->socket, &tfile->sk, inode->i_uid);
 
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;
-- 
2.39.2



