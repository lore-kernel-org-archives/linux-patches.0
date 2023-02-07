Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CF62C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:09:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D40C433EF;
	Tue,  7 Feb 2023 13:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775379;
	bh=3RCrKyJy5WdVa4IYowNk45o88UE8n1a+5mKrjjOy9eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aXI+Fak/mdACmD5yVuB10C9LEHzVUbM0O28RnhCaZYk1pHjVUlMvpjKJcJuLyOaBd
	 I8i9/33MThE9uMKslhcuhv6OczQuF1SQ895sUL2UC6HyRhaK4Z9gHbuf2gGhwO7o0N
	 AXdtIhaOnbiQJZd1WrFeu2NOGxxiTgttefOJV9Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/120] fix "direction" argument of iov_iter_kvec()
Date: Tue,  7 Feb 2023 13:56:32 +0100
Message-Id: <20230207125619.677585068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit fc02f33787d8dd227b54f263eba983d5b249c032 ]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/pvcalls-back.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
index b47fd8435061..e18df9aea531 100644
--- a/drivers/xen/pvcalls-back.c
+++ b/drivers/xen/pvcalls-back.c
@@ -129,13 +129,13 @@ static bool pvcalls_conn_back_read(void *opaque)
 	if (masked_prod < masked_cons) {
 		vec[0].iov_base = data->in + masked_prod;
 		vec[0].iov_len = wanted;
-		iov_iter_kvec(&msg.msg_iter, WRITE, vec, 1, wanted);
+		iov_iter_kvec(&msg.msg_iter, READ, vec, 1, wanted);
 	} else {
 		vec[0].iov_base = data->in + masked_prod;
 		vec[0].iov_len = array_size - masked_prod;
 		vec[1].iov_base = data->in;
 		vec[1].iov_len = wanted - vec[0].iov_len;
-		iov_iter_kvec(&msg.msg_iter, WRITE, vec, 2, wanted);
+		iov_iter_kvec(&msg.msg_iter, READ, vec, 2, wanted);
 	}
 
 	atomic_set(&map->read, 0);
@@ -188,13 +188,13 @@ static bool pvcalls_conn_back_write(struct sock_mapping *map)
 	if (pvcalls_mask(prod, array_size) > pvcalls_mask(cons, array_size)) {
 		vec[0].iov_base = data->out + pvcalls_mask(cons, array_size);
 		vec[0].iov_len = size;
-		iov_iter_kvec(&msg.msg_iter, READ, vec, 1, size);
+		iov_iter_kvec(&msg.msg_iter, WRITE, vec, 1, size);
 	} else {
 		vec[0].iov_base = data->out + pvcalls_mask(cons, array_size);
 		vec[0].iov_len = array_size - pvcalls_mask(cons, array_size);
 		vec[1].iov_base = data->out;
 		vec[1].iov_len = size - vec[0].iov_len;
-		iov_iter_kvec(&msg.msg_iter, READ, vec, 2, size);
+		iov_iter_kvec(&msg.msg_iter, WRITE, vec, 2, size);
 	}
 
 	atomic_set(&map->write, 0);
-- 
2.39.0



