Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C20F248191;
	Tue, 29 Apr 2025 16:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945468; cv=none; b=c+gq06C52W8mPwm29uACHIqM7w7hNyu5DYR3p9Wj2iFDkmWbhbtlYUvZibbaBp8KIsMyhh/NvzahVs9zPRxj/EzXJXePdR8koijwpUmgx9Nf4Gk42I7bpfTDvGnHhh7F/JCFu6YggivHbN+aN2eXtgGMcjqhtvM015SYFi6uc7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945468; c=relaxed/simple;
	bh=nfILDgwqPCMOsMlgwL/Ha3Prt9Qm2hewkJSk2gfaioo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDP8JPqkC4LNkDxEtocGZM+rqxVbHgNNjOeaBphNtFTOTbKi+ZOfa6cIdJZS9LMoBRw/W+RBKITDAtWytpJH1aY7kXhNM0mGt2cc/SkWbX2tgKfeTZv9I1+ufSa0KZpCQRK11pt5PINHGc7tHKoA9umACW2Fu4iMxaLvxfphkcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWqxJEre; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWqxJEre"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851DAC4CEE3;
	Tue, 29 Apr 2025 16:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945467;
	bh=nfILDgwqPCMOsMlgwL/Ha3Prt9Qm2hewkJSk2gfaioo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWqxJEreJaFhYauMth4J10QSmBZ/YTuogLWLH+sbuQ7DkD/qxJ0qkrR/XvwOfVGPc
	 kyaL0GtJ8uN8bAd+8+piTrlQ2VLWTb0izw2sVizYek63LZI3wse30ezbSjvPrhvtLz
	 9cZ2fOJTy/AdkJp4Ti/D2tGwT14zsSmxp1jJ1zV8=
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
Subject: [PATCH 5.4 092/179] net: openvswitch: fix nested key length validation in the set() action
Date: Tue, 29 Apr 2025 18:40:33 +0200
Message-ID: <20250429161053.124312532@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 67125939d7eee..4ad4c89886ee3 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2741,7 +2741,8 @@ static int validate_set(const struct nlattr *a,
 	size_t key_len;
 
 	/* There can be only one key in a action */
-	if (nla_total_size(nla_len(ovs_key)) != nla_len(a))
+	if (!nla_ok(ovs_key, nla_len(a)) ||
+	    nla_total_size(nla_len(ovs_key)) != nla_len(a))
 		return -EINVAL;
 
 	key_len = nla_len(ovs_key);
-- 
2.39.5



