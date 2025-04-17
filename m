Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620202571BA;
	Thu, 17 Apr 2025 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914052; cv=none; b=chhMzjBfTT/6nn9oTQ7e5qH9LdixyWudQNKyRn5/8zpAUYjSbtWVuDHXRVbaEbuVTlGk8WnBhQZVOYUU1y9SFX2sMoaCdOT0oy+wRXZxTrH3YaZZ/+9Xc6IhguwjcclMo6UykbspaTrpdO8CLjqp2GUo7G9ytLGrjbMHuWFP96g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914052; c=relaxed/simple;
	bh=ZgNh3j4MPJt9WGEH6NI7+mcdUtJ42g/V7lk7B0Ep0GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6W4A+SWVHjch10eXMi4c4MCJMAojDedW5+3eQ3asyDYNmD/Fyb1aFm24xn6fm+e0RS/Pu5UjzTXORiYzXJ848sMVYU/XHysAaPwD8KXMK4lOhHQQ60eEQZNdNJmyZtINOdpMUVt8EaXchgfKT2FoaduaEIsFLaWfJKVde/TF9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiY4B3Xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiY4B3Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6F9C4CEEA;
	Thu, 17 Apr 2025 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914051;
	bh=ZgNh3j4MPJt9WGEH6NI7+mcdUtJ42g/V7lk7B0Ep0GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiY4B3Xmn1LhSXd/0qscCQhGyOQ0TE28zAqqPZEwtKLJWtfDiwOtn6uiOx3CIUL1/
	 1QG9k4OccbBP+XeG4NgfV2YOwk/kU9X7S4vVbbhMgiGSBNsWrh00CJh7X2tuhmK39b
	 bLZUtgpaM3p43KGN1T3L0lt5X/W90yFBvWaZDRLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Wei <dw@davidwei.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 090/414] net: page_pool: dont cast mp param to devmem
Date: Thu, 17 Apr 2025 19:47:28 +0200
Message-ID: <20250417175115.061500882@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 8d522566ae9cb3f0609ddb2a6ce3f4f39988043c ]

page_pool_check_memory_provider() is a generic path and shouldn't assume
anything about the actual type of the memory provider argument. It's
fine while devmem is the only provider, but cast away the devmem
specific binding types to avoid confusion.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
Link: https://patch.msgid.link/20250204215622.695511-2-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
index 6677e0c2e2565..d5e214c30c310 100644
--- a/net/core/page_pool_user.c
+++ b/net/core/page_pool_user.c
@@ -356,7 +356,7 @@ void page_pool_unlist(struct page_pool *pool)
 int page_pool_check_memory_provider(struct net_device *dev,
 				    struct netdev_rx_queue *rxq)
 {
-	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
+	void *binding = rxq->mp_params.mp_priv;
 	struct page_pool *pool;
 	struct hlist_node *n;
 
-- 
2.39.5



