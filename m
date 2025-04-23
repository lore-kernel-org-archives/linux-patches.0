Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CAB27D76E;
	Wed, 23 Apr 2025 14:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419832; cv=none; b=t1nJn9dDuNn5CgI1r6zEei4FRwyYMKRJo4V7tzj9hF4fnwJnV8LWg3RxN7bZI0q5aO+a6CR/WlSXJ8QGdxvy9VzEx24DjL4TytBBwnB3pgN/N1q/hIefdpGTyh0WkQydKPgsQ+e27aBl6Sufa7vtduMM6Esp7GrnXqgHHcpziMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419832; c=relaxed/simple;
	bh=9/kre7z2agR/vqILKiP5RRKuHks9L45fFJkCVgfEU6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R7oR4vL5ObgXfKZ4I0Zh83siq5+aJMzetgTAeM03WieUxrEK9e9umR8T+iIWjxp2BPZz9KVWGSVl9AoDIO7YQcFOKj8n1yuTQDYY0NW/Yh5UP6n0mmvz/HualGXzU+R3I+c2a23D/6sOQxnfuhQqq7j9pPuWT7uJhGfV/qTGUZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqCRof0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqCRof0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD58C4CEE2;
	Wed, 23 Apr 2025 14:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419831;
	bh=9/kre7z2agR/vqILKiP5RRKuHks9L45fFJkCVgfEU6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqCRof0m1mhiP6u2g0J8kLejq/filB+DDF9yMFK04vRYgBXtgvHyq5yP0qBEcA1/8
	 c1t2zlEdaspD45bB5K6Adf8t1QD7PJRWuWU4YykiARkFHgbODrC9rERZJnONmLVxwA
	 DixP7zQRbdmvPuiIe5TNZMkdfF+RGNeD85ffFFzM=
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
Subject: [PATCH 6.12 047/223] net: openvswitch: fix nested key length validation in the set() action
Date: Wed, 23 Apr 2025 16:41:59 +0200
Message-ID: <20250423142619.049569797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0df89240b7336..305daf57a4f9d 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2876,7 +2876,8 @@ static int validate_set(const struct nlattr *a,
 	size_t key_len;
 
 	/* There can be only one key in a action */
-	if (nla_total_size(nla_len(ovs_key)) != nla_len(a))
+	if (!nla_ok(ovs_key, nla_len(a)) ||
+	    nla_total_size(nla_len(ovs_key)) != nla_len(a))
 		return -EINVAL;
 
 	key_len = nla_len(ovs_key);
-- 
2.39.5



