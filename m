Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D7015C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:31:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8EADC433D6;
	Mon,  5 Dec 2022 19:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268688;
	bh=DKx3DwfW8k1FPiFRJyF7yNoPNIoTMzZ7Ae7alVpltzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lob9BA2Upd5CxEK9iuJI30P5eXCI81KpL54ds2YflaDKQ3kTOI9NyVI/2OofRkEjO
	 M/f98b6j4zQhsso4m8cjJfOz48AGvD5ut9MYZAoT5M88Tr+J+bseJGwnh56kTW7qj8
	 2pHG4OmAk35C8g+LEDlNxaGKTQXbZT+89SR3FZbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 41/92] net/9p: Fix a potential socket leak in p9_socket_open
Date: Mon,  5 Dec 2022 20:09:54 +0100
Message-Id: <20221205190804.828132402@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit dcc14cfd7debe11b825cb077e75d91d2575b4cb8 ]

Both p9_fd_create_tcp() and p9_fd_create_unix() will call
p9_socket_open(). If the creation of p9_trans_fd fails,
p9_fd_create_tcp() and p9_fd_create_unix() will return an
error directly instead of releasing the cscoket, which will
result in a socket leak.

This patch adds sock_release() to fix the leak issue.

Fixes: 6b18662e239a ("9p connect fixes")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
ACKed-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 400219801e63..deb66635f0f3 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -852,8 +852,10 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 	struct file *file;
 
 	p = kzalloc(sizeof(struct p9_trans_fd), GFP_KERNEL);
-	if (!p)
+	if (!p) {
+		sock_release(csocket);
 		return -ENOMEM;
+	}
 
 	csocket->sk->sk_allocation = GFP_NOIO;
 	file = sock_alloc_file(csocket, 0, NULL);
-- 
2.35.1



