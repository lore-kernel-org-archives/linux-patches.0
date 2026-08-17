Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45072C1594;
	Mon, 17 Aug 2026 14:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975289; cv=none; b=hdKhqpgK+vhhNYKLeH5HBrqulNrqxr1BMQWdmb0Mjkb+169Dm3W49ouOkqe+XUSVGnzFYVmBTZFw9YXMXTbgtRtIzHthx/L9uUQXjL1qdqHBavnjwjb58+6FydzOz09ADoYtmqepnwtosa/ohViKopK2YuKz7jAwYS5sUWEfb7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975289; c=relaxed/simple;
	bh=V1E5MwEGRizLIdbX4qBwnuoBY7Q+a6PMsBeSvddCfqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncui+YikutrRq0A3nuDV5UTtJbBUbC7lrG5OrYno88Z5HpmCErCJx4fLp3IE5RE7DmmP+zt0lF7tWF3HVClHARrca3oaZRrcRZwxj5KY47PrISoIaI5bZnmwWG5K4vW9amfWLt2EOw9emfsWyup75R83Mn7qsZHtAaK3okI8TVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqVblJPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqVblJPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482FE1F000E9;
	Mon, 17 Aug 2026 14:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975287;
	bh=faEdjReJvKQbjoko70VuCEgdTEJ2xHLpZsqPzip2iUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqVblJPhDH/8OppcTgW+tVN33QH3XTHvd848fHlrAejKdSJQargn6fDdpoY5NNfzN
	 /Cb0p8B+6LzP0Xn8uhMFy1hSG7SAdL/tjzZAouQ8/Avqh10q6abeVcelbmQWsiow/R
	 uRu2uZRX6e9vjGAG3bFoKhbS1dzBcMNM6NHHm+qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Mina Almasry <almasrymina@google.com>,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 200/250] net: devmem: prevent net-iov / page mixing
Date: Mon, 17 Aug 2026 15:32:41 +0200
Message-ID: <20260817132544.726154444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 53a43508ee332d8bffe40590c3d189c92a551f9f upstream.

We should either have net_iov or page backed frags in a single skb,
otherwise it blows up down the stack. Don't allow mixing in
zerocopy_fill_skb_from_devmem().

Fixes: bd61848900bff ("net: devmem: Implement TX path")
Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Bobby Eshleman <bobbyeshleman@meta.com>
Link: https://patch.msgid.link/e3199788c4732545627a4721097ebb71ad737bab.1785150502.git.asml.silence@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/datagram.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index c285c6465923..173b5d97bd40 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -712,6 +712,9 @@ zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
 	size_t virt_addr, size, off;
 	struct net_iov *niov;
 
+	if (i && skb_frags_readable(skb))
+		return -EFAULT;
+
 	/* Devmem filling works by taking an IOVEC from the user where the
 	 * iov_addrs are interpreted as an offset in bytes into the dma-buf to
 	 * send from. We do not support other iter types.
-- 
2.55.0



