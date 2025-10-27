Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECED2D5C95;
	Mon, 27 Oct 2025 19:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591726; cv=none; b=guo22xrMwf3Uu9IYJxeEynsn1vF7+OrK8MPvU1eLHczJsgQIjs3zHDHphQr9ljBswJ435Yfe+SLKZRBGttfZMHQHYgJbxI8D7jAekFXe59eHHFKgmMFbMG1PzZmQRtKIJ30JdR8a++Eo93AJZgTAUZHzOJDHa0/iLysKGuyTUCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591726; c=relaxed/simple;
	bh=px+jiTLMUCPUz8sph1+W9URHYSjrru+O57K2M1B7cpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hifZHKhpORsLtPE1DXCwa4t+qCIJ7SybN94s2TM2Cg6Vexm8EGXoAbzt7zsDttqtH5UtnNwV3ZiGSeqGVhqrCazZ9kTWaxaKuIxO7AhHN7qbWhDoMIza1Z5xayMkpA8djrcv63/0gJ4FNavIQDx/reghhRLP2VHx0kcxitX67Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccFc/kXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccFc/kXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B3FC4CEF1;
	Mon, 27 Oct 2025 19:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591726;
	bh=px+jiTLMUCPUz8sph1+W9URHYSjrru+O57K2M1B7cpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccFc/kXSUXPgtFqADN7mR7FvDOcR1B9vB8WUpKs0/bMLctTLOFEsRdCNfQIFhmDku
	 xd4uQ5wZtf7vRCWK0+DGxIpBZrPqehNBzUJbq4qgqUeWl6shHXBMssdNg4GC/854m8
	 Ukj4G8NeCkA3KajeiCXlTIIWYlx3jUxJTbuhYMMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/332] net: rtnetlink: add helper to extract msg types kind
Date: Mon, 27 Oct 2025 19:35:22 +0100
Message-ID: <20251027183531.961940908@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 2e9ea3e30f696fd438319c07836422bb0bbb4608 ]

Add a helper which extracts the msg type's kind using the kind mask (0x3).

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 6 ++++++
 net/core/rtnetlink.c    | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 74eff5259b361..02b0636a4523d 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -19,6 +19,12 @@ enum rtnl_kinds {
 	RTNL_KIND_GET,
 	RTNL_KIND_SET
 };
+#define RTNL_KIND_MASK 0x3
+
+static inline enum rtnl_kinds rtnl_msgtype_kind(int msgtype)
+{
+	return msgtype & RTNL_KIND_MASK;
+}
 
 void rtnl_register(int protocol, int msgtype,
 		   rtnl_doit_func, rtnl_dumpit_func, unsigned int flags);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index c0a3cf3ed8f34..2cd4990ac8bc3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5532,7 +5532,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return 0;
 
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
-	kind = type&3;
+	kind = rtnl_msgtype_kind(type);
 
 	if (kind != RTNL_KIND_GET && !netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
-- 
2.51.0



