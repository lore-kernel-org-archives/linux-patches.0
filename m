Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460599446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9326C433C8;
	Sun, 13 Aug 2023 21:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962635;
	bh=46w7XvagkqAvvT8qpNnWNWgOhOLhGxBE3mt6pa2arKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xZtsUUsGtPZDmYlGqUsTRPY2Cup2x5CV2LOBeNuTi6lXYA7HdiJROgOLkxTVypCAG
	 eSoEFF+EMUFn371psPtFUoFAqT+2DF+3mZHFZPkOY/70tqstIKsJh8qCXU4t+V8xnE
	 /xtdow8As0edIm7hWIfKl+sgRci44BYQDhJ6fHkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8ada0057e69293a05fd4@syzkaller.appspotmail.com,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Martin KaFai Lau <martin.lau@kernel.org>
Subject: [PATCH 6.1 093/149] xsk: fix refcount underflow in error path
Date: Sun, 13 Aug 2023 23:18:58 +0200
Message-ID: <20230813211721.577590306@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Magnus Karlsson <magnus.karlsson@intel.com>

commit 85c2c79a07302fe68a1ad5cc449458cc559e314d upstream.

Fix a refcount underflow problem reported by syzbot that can happen
when a system is running out of memory. If xp_alloc_tx_descs() fails,
and it can only fail due to not having enough memory, then the error
path is triggered. In this error path, the refcount of the pool is
decremented as it has incremented before. However, the reference to
the pool in the socket was not nulled. This means that when the socket
is closed later, the socket teardown logic will think that there is a
pool attached to the socket and try to decrease the refcount again,
leading to a refcount underflow.

I chose this fix as it involved adding just a single line. Another
option would have been to move xp_get_pool() and the assignment of
xs->pool to after the if-statement and using xs_umem->pool instead of
xs->pool in the whole if-statement resulting in somewhat simpler code,
but this would have led to much more churn in the code base perhaps
making it harder to backport.

Fixes: ba3beec2ec1d ("xsk: Fix possible crash when multiple sockets are created")
Reported-by: syzbot+8ada0057e69293a05fd4@syzkaller.appspotmail.com
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Link: https://lore.kernel.org/r/20230809142843.13944-1-magnus.karlsson@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/xdp/xsk.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -994,6 +994,7 @@ static int xsk_bind(struct socket *sock,
 				err = xp_alloc_tx_descs(xs->pool, xs);
 				if (err) {
 					xp_put_pool(xs->pool);
+					xs->pool = NULL;
 					sockfd_put(sock);
 					goto out_unlock;
 				}


