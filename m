Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B84DA1422B8;
	Wed, 19 Jun 2024 13:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803941; cv=none; b=JrJJ4gwXWmjr0vxD22/vQn0pscg0fzxHgyq+7QoH7dD7h9I16r7HqHm/5WJUMVm2XcGcUGhzR4owsZXv7ps8172p+/OCHdl/Cc6fUEQuymM8GmTuQSgr5PLKZL8hmAR4UYHekgtkIzUmzkvA7zDWTDoDifwNlDbrCoJ0JJXaa+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803941; c=relaxed/simple;
	bh=ydnWW8w0w/OTzlnenZSm0Ifwkq0dFI37QrWAXdnJwIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUARTgxbglNSzwR1lHO3SMQ4fD4WGInXl4SWXRHzyOT7k5uHQ2oj/pLuxUwSny7Geu6k9YVvgdQsc0UXmVvPBLfvcsI58BkwlcqdZQEFl5Eqz3Vn5s1GLQy8B9LVEWUk/b87pRrzcED6oK18Z1scdvWmzwfQVKh90R8WDb/J2wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8DBc9PD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8DBc9PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36222C2BBFC;
	Wed, 19 Jun 2024 13:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803941;
	bh=ydnWW8w0w/OTzlnenZSm0Ifwkq0dFI37QrWAXdnJwIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8DBc9PDdZlsUuf+vhb6y3lzqpER+wLCsQGLTVHj31hbYOsu1cK6UX4V5LQpj8sh+
	 p4OdVm25H8PZdfs5lc/4pU/5wjMOF5FjoK8gjAeZmt2kCEkg8y0mrYEAiGucK3cEmR
	 N56reCnrdxF/7E+yDXhuZ9760hj4JFmLwGBrHAf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bbe2de1bc9d470eb5fe@syzkaller.appspotmail.com,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/217] net: bridge: mst: fix suspicious rcu usage in br_mst_set_state
Date: Wed, 19 Jun 2024 14:56:38 +0200
Message-ID: <20240619125602.670138787@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 546ceb1dfdac866648ec959cbc71d9525bd73462 ]

I converted br_mst_set_state to RCU to avoid a vlan use-after-free
but forgot to change the vlan group dereference helper. Switch to vlan
group RCU deref helper to fix the suspicious rcu usage warning.

Fixes: 3a7c1661ae13 ("net: bridge: mst: fix vlan use-after-free")
Reported-by: syzbot+9bbe2de1bc9d470eb5fe@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bbe2de1bc9d470eb5fe
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240609103654.914987-3-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_mst.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 1de72816b0fb2..1820f09ff59ce 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -102,7 +102,7 @@ int br_mst_set_state(struct net_bridge_port *p, u16 msti, u8 state,
 	int err = 0;
 
 	rcu_read_lock();
-	vg = nbp_vlan_group(p);
+	vg = nbp_vlan_group_rcu(p);
 	if (!vg)
 		goto out;
 
-- 
2.43.0



