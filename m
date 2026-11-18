Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032670;
	b=VzKvjwQXLWjeGmEdRNmsL1Aw8mrLuknBlU2foiue/j7jFgcyBtPRVoPnSgvQ0I49tDep
	 XtISbj8Jl7AGFjapzSw4WGO41MDwRsVMNXe5sea+FPyjPGR/GyM0yXBrMSHy4n6OrDzAt
	 tAVdq1J6mDldINIU35ebsQLrykW1+Uc9k4agCTU5Dj44yxfZVpVAg5A6Z8FShLYSDZ8gY
	 LPOKQJRjsEJghg4IXPNzvCL7Up0YrWh5FuBhIojHdxxM2DRgmFG+QBbMJwsv0s2RVJSKG
	 7WlAT2XURGCYMOPkxYFAq4SY2Ll5sIQ5oG94uEfYRAhW7BIKgXlTi6Z0Dc+8r0qGZ8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032670;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cQQSzJCPKxF12tuyPLYboEMf7AruBOybnjxuvRYPbvE=;
	b=F/4qK1nkM3jNjVVWkRRv1T9RGaPCtV5Tp3rQMC5rf5nduS6fb19GV4Q3Jau0zfsp8NjO
	 kxbLujrj7OJa13RcjAURRkKebcXKOFboGD03WiKejssWLERZp+eohvaF15GvjK2ylHjMh
	 W2PSDlOBf7WvLzfjKSncL7sVNTHR2LKXvRhUvejnhtZ+lcWcKiwwJTdsUJIxl3dt7wYa8
	 +k3AvVCRlYP4mUtRylSIQ0ABSxTIOar4UgkbFDayyy2wclOS+OGaX2cw/qV+G9KC9OpFj
	 pEPJDwy7I0D7PHDVqi7eVD8/c8p5vabY54RNdPGAltGgESK43yzfIozoJl9ui2Vn/PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPnp+WKW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706DB606A31C;
	Wed, 18 Nov 2026 20:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPnp+WKW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75CB1F000C4;
	Wed, 18 Nov 2026 20:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032670;
	bh=cQQSzJCPKxF12tuyPLYboEMf7AruBOybnjxuvRYPbvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPnp+WKWqtRQuV9ijqIhwkGD1na2BGKscpIiK+Mb9/nvIudM44i3SWIBHpIltaJLc
	 aETZbRt+M5LMI/zXC4+HCljHyJN4LvVCUWHzjvqZUXyavDFK2C40ci4+x9kMQvppTz
	 mqowaN+FPeKgg2zLW6/jA8v5AY6WdZKdxF8FZHHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1493/1756] gtp: hold RCU for the device lookup when adding a PDP context
Date: Wed, 18 Nov 2026 16:00:20 +0100
Message-ID: <20261118150108.405696727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7978389c45a4c..2551f17cbf14e 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -2048,7 +2048,10 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 
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



