Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C709627055F;
	Wed, 23 Apr 2025 14:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420026; cv=none; b=G2A0Mw12zFQstlm1iE0zcsM4YLdzfPktvCq9jm0IcqNC1BWAZZO+QJu/8b2xWL81Tr0o/92JKNs5XwyXe8rZez/NNtptSjZNUVmVT7NNWIPQaYiQ9HlxUeZVNmS0oWCDeDZ2mOhmrrVHLwyz7G/DcZxSLy/mFgiaPNTP7TFzDpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420026; c=relaxed/simple;
	bh=gwRyLtFK+Ut2AaUFQAQOJUM3nFoRJVRJ3AiZ14P/CoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gfCdIUCy/RtVwvXXQBBrhGt/MXBszsxwL6odwH5u2Y9WTKx/wK2ETzCBBSziOPsOLbThUtMt+2/tSm1l5vxDkBSJuYH5w1ylk5vCHby605MKfrF7YxJek0MC9d95zGuFuHO4wX6ayBDl8zN5dB5/OMXGb1tH9Tq1QwYB1DuqwO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v08kL6ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v08kL6ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFCCC4CEE3;
	Wed, 23 Apr 2025 14:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420026;
	bh=gwRyLtFK+Ut2AaUFQAQOJUM3nFoRJVRJ3AiZ14P/CoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v08kL6ak/OnWI4WmNMByVDju6HaDvfZ0w1/8LgzN3wDH2JK6FiJ668pFxXhFCy2ZH
	 B7DTN8m5jxI5RhVBDA4p1QxcnwT8jhqGw708hmR+1/nxbwRVRtTfqJpbCcX/F+Yikq
	 Dx4Qk58NlUF9RTDCtRs1Alsyv6ABL8FDubSX65mQ=
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
Subject: [PATCH 6.14 053/241] net: openvswitch: fix nested key length validation in the set() action
Date: Wed, 23 Apr 2025 16:41:57 +0200
Message-ID: <20250423142622.674250578@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 95e0dd14dc1a3..518be23e48ea9 100644
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



