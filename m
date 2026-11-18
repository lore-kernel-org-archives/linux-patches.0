Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021464;
	b=OQ/njm9/r+TDM8nepTt2d3oymKdEEjebRUPlgiQCpWXyOZ9+Rav6c8x60Phm4XMM++tE
	 LbvmGJ6Z2+sFPq8B65aczU174LcLL1riONxz2v3rQKg4n4TOWKqY6SXnLpBuRn1oLhrxL
	 L7McLCViL6zLLVvqY8fYGWpzxiPWmjQNb5a9P0M5hGH47GhUWxBQ0yNsKyWCvVM2PVFCA
	 HG5nR7WgxjxsdU2Q8xJXbgDzG4UssqEwCZXwaUtGLwXZc1Ji8NkNNejhUZ6ropZzP2ktk
	 u65XQkEx8FrpyURAi5qvoukkT3MOM6vXb7xLBg5ZAQhigNgApu4VaJGY9neG9yF3+1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VnqM6INqk9fjFxsdgvlF+1O13vrvaFx6LlQnmQ9RAt4=;
	b=bEN+MJJIYQDeNJprzofsG+upYW/WxOzmib3DH3HKEJ/8NrlPUa9tAAM2z7RXVlhg+1n8
	 YFjPX9k2t4IA8ZHLlUOaudAHe8m/T+iLODLoVBpnvaa/hxk/y3ODyr/FM2I2kHvfbAEzm
	 82AkyoRXTAA7maxxTVBZAl0D0T+1TMBuB75seoObTV/0Y5wpb9/bz5jSbSsF+gYJud5h/
	 pW5n9gX7gEuT+XP0Pa3IezBa9u1AjDOgWrOVo94UTArDrMTOah2mBuKqc0kWvXwl0nNQX
	 3lVKZ88igbCH/Y5xhQ+9H/hKOQ5ClJYzR6ZYxgc8x/bKGj6uVMpmq9YahbAqD6rUpWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7q+gKa7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F1E60A263F;
	Wed, 18 Nov 2026 17:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q7q+gKa7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCC91F000C7;
	Wed, 18 Nov 2026 17:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021463;
	bh=VnqM6INqk9fjFxsdgvlF+1O13vrvaFx6LlQnmQ9RAt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q7q+gKa7fUM1MPgv0nrOu7ERPzj9TWHKyY+PqbkezPGfck7TRwNDnua8m4dPLig70
	 GugkGriVHjH83AmTdyEBrsxH/xHGQybYX5fxMaKyoD1KGzdD4Cgw/LYEZB5Ur8jaDc
	 JgXMqCJBrnYjATzsBs5cHqPsNB/mIXRbNATlBN3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2314/2651] gtp: hold RCU for the device lookup when adding a PDP context
Date: Wed, 18 Nov 2026 15:59:14 +0100
Message-ID: <20261118150408.513978096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Kaushik <anilkaushikwireless@gmail.com>

[ Upstream commit fe3e1a42fb7eb18d8c55d714b50a3d51f8cd6ffe ]

gtp_genl_new_pdp() calls gtp_find_dev(), which looks the device up with
dev_get_by_index_rcu(). Since commit e2d1baca2b33 ("gtp: remove useless
rcu_read_lock()"), this only runs under the rtnl lock, and kernels with
CONFIG_PROVE_RCU_LIST warn:

  WARNING: suspicious RCU usage
  net/core/dev.c:1047 RCU-list traversed in non-reader section!!
  ...
   dev_get_by_index_rcu
   gtp_find_dev
   gtp_genl_new_pdp

Hold the RCU read lock around the lookup only: gtp_pdp_add() allocates
with GFP_KERNEL, and the rtnl lock keeps the device alive afterwards.

Found with the gtp selftest on a debug kernel.

Fixes: e2d1baca2b33 ("gtp: remove useless rcu_read_lock()")
Signed-off-by: Anil Kaushik <anilkaushikwireless@gmail.com>
Link: https://patch.msgid.link/20261016093225.1036375-3-anilkaushikwireless@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 3dd97d75551ce..df182cdd3bd4a 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -2050,7 +2050,10 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 
+	/* the rtnl lock keeps the device alive once found */
+	rcu_read_lock();
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
+	rcu_read_unlock();
 	if (!gtp) {
 		err = -ENODEV;
 		goto out_unlock;
-- 
2.53.0



