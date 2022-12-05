Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C266E15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:21:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB42C433C1;
	Mon,  5 Dec 2022 19:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268065;
	bh=GSyUNZrKoXe5IQ42Cl+JAheERkvgH1EVGuL6gxljoBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6ObfDaVbnhj/PM3mRg9ybanVqLBTZuljmWRDgKedafhgeculEuE5b0dYXSlQUOk/
	 yUMr0kA1bmFFhtKIIiVwspRb1cY7Qa13vpUrC+Pkksi67URVAtrboqJSvOHdlQHLDy
	 DC5vxZx/rN8ZLR+sm+FslSXP/RwrVLVca+n3Zxn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Hai <wanghai38@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 074/105] net/9p: Fix a potential socket leak in p9_socket_open
Date: Mon,  5 Dec 2022 20:09:46 +0100
Message-Id: <20221205190805.665663009@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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
index 6aba06a8261c..e03ff8df1d3f 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -867,8 +867,10 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
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



