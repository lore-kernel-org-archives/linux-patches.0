Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7A4BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:19:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B355C433EF;
	Tue,  7 Mar 2023 17:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209582;
	bh=Fz33OgIM+kjXSCtgvOTXkpyVaeUSm59C1AzKHfokX94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmuKRAsWAszz/CGhWZO/hI1KMVINf/iZR8EoZo0M9uEfKakTeYW+g/j+MAJDwiwHM
	 X7WF9rVVDoUkNDzfIeoxYD8kK1upTYrmp+d+hcG6I8c9IkMCDWFqvT3J0tmU/2YN+w
	 nrw8umWWwVb5zMhM8rO7xh2GBxXL7In/t81xSelY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pietro Borrello <borrello@diag.uniroma1.it>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0266/1001] tap: tap_open(): correctly initialize socket uid
Date: Tue,  7 Mar 2023 17:50:38 +0100
Message-Id: <20230307170033.279577529@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit 66b2c338adce580dfce2199591e65e2bab889cff ]

sock_init_data() assumes that the `struct socket` passed in input is
contained in a `struct socket_alloc` allocated with sock_alloc().
However, tap_open() passes a `struct socket` embedded in a `struct
tap_queue` allocated with sk_alloc().
This causes a type confusion when issuing a container_of() with
SOCK_INODE() in sock_init_data() which results in assigning a wrong
sk_uid to the `struct sock` in input.
On default configuration, the type confused field overlaps with
padding bytes between `int vnet_hdr_sz` and `struct tap_dev __rcu
*tap` in `struct tap_queue`, which makes the uid of all tap sockets 0,
i.e., the root one.
Fix the assignment by using sock_init_data_uid().

Fixes: 86741ec25462 ("net: core: Add a UID field to struct sock.")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index a2be1994b3894..8941aa199ea33 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -533,7 +533,7 @@ static int tap_open(struct inode *inode, struct file *file)
 	q->sock.state = SS_CONNECTED;
 	q->sock.file = file;
 	q->sock.ops = &tap_socket_ops;
-	sock_init_data(&q->sock, &q->sk);
+	sock_init_data_uid(&q->sock, &q->sk, inode->i_uid);
 	q->sk.sk_write_space = tap_sock_write_space;
 	q->sk.sk_destruct = tap_sock_destruct;
 	q->flags = IFF_VNET_HDR | IFF_NO_PI | IFF_TAP;
-- 
2.39.2



