Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2BA27FD49;
	Wed, 23 Apr 2025 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421855; cv=none; b=fiyZJQay4sGuegArPeB7IQvUB4eryzKLLvwviv1OzcpB6eZNLcdGycHLBWYhigkzMvYZnDkl4M6cy9P38ALiKowVGcerWn42i6f/eawbfqgRp+ntSSVJnVJ2NHLHwrT61OR84B3UvKkKhf+AuD9N1/z3xAOGtnlYeBPZduhKAEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421855; c=relaxed/simple;
	bh=BJGEhW27Lr2TGVKka1wg4aV4wH0+F+J2iUfeHmLHlu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZxkfp2LQ2J4FeHC7dOepNjV+FKxcY+WDCHyebhXTMjpRihvSBhiYut4TldW/P/z/uKNPBDoGQ3BihV6GC8ZPp+VdQ7ByPrQKgGrzF8sneX/GZUmV8EPQw68Bw12vZtRurRyw867+nFP4W99+uut6GBvNVIQwFOoF3qvKH8eShE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ro3WMF5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ro3WMF5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB022C4CEE2;
	Wed, 23 Apr 2025 15:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421855;
	bh=BJGEhW27Lr2TGVKka1wg4aV4wH0+F+J2iUfeHmLHlu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ro3WMF5nRPAlbq4NwxH+RI/qfIKb4YNfoionyinFxiBTtyjIgsMq5NL26VWtyn+QA
	 +E/NMROqmtiAaHQ+oVV7t5lL5MqNYR8/ZW5v132bJ9rKFUPGeNMmoWq5t8aKkY3vL9
	 4/2eFL3N2tDxrFckLwbdUIgqe4QVHxcGl1EBp7RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b07a9da40df1576b8048@syzkaller.appspotmail.com,
	Ilya Maximets <i.maximets@ovn.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 186/291] net: openvswitch: fix nested key length validation in the set() action
Date: Wed, 23 Apr 2025 16:42:55 +0200
Message-ID: <20250423142631.976158633@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 65d91192aa66f05710cfddf6a14b5a25ee554dba ]

It's not safe to access nla_len(ovs_key) if the data is smaller than
the netlink header.  Check that the attribute is OK first.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Reported-by: syzbot+b07a9da40df1576b8048@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b07a9da40df1576b8048
Tested-by: syzbot+b07a9da40df1576b8048@syzkaller.appspotmail.com
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Link: https://patch.msgid.link/20250412104052.2073688-1-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/flow_netlink.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 5ebbec656895e..0ed3953dbe529 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2860,7 +2860,8 @@ static int validate_set(const struct nlattr *a,
 	size_t key_len;
 
 	/* There can be only one key in a action */
-	if (nla_total_size(nla_len(ovs_key)) != nla_len(a))
+	if (!nla_ok(ovs_key, nla_len(a)) ||
+	    nla_total_size(nla_len(ovs_key)) != nla_len(a))
 		return -EINVAL;
 
 	key_len = nla_len(ovs_key);
-- 
2.39.5



