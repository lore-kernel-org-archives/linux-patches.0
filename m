Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE582FD1DA;
	Tue, 31 Mar 2026 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976516; cv=none; b=SOgTP3XDW4Spm73ieiG6nkKs5wZVrsetg0FLo5J/80TBWKtR3EOR235q51lHprbE/IJM5tTf3bz1RuIBc9T1JDrwyrrMvevrSl65lLEl9JswyO+z1V8UvqO2gtqb1kL/2WxrGqQ6Q/HVYTpX+Kw/dxzymB4JPKX5+dIO/h7tfoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976516; c=relaxed/simple;
	bh=LSEDfFK+yWzgkNK4vhsS6kH/zLUQ3j11ekzz8le1G2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtYm9J2ESwY8s4Rp94WzzapgpKoLbcZcHeUfg9EfxbG+gfJsLnlmMV728RGV05Ts9/84OH38PcHKKva57mTcDu9XmcHZWN3aklFjhJ2DzGKELdqxiqy4FyQRf67nOqYUJLZmttBlYM+gYgG/UheW+iCFu1ZtNGCK0HVJj4zK7F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mGCja0hH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mGCja0hH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C626C19423;
	Tue, 31 Mar 2026 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976516;
	bh=LSEDfFK+yWzgkNK4vhsS6kH/zLUQ3j11ekzz8le1G2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mGCja0hHzihT917/KUfdpt3ECVXftj3Pt3/ta24GBTgiKbkjYAFSw9TCVHoYCwWkO
	 ctSxGkr2QHU0phCiwWB4eGhYRhYzFxZtr6yvQp9QK7faqKzOc9i2U4hzMO3Al7QnFy
	 eFPlYVuvu+Kk0GHSCeyHWVp0p/xyXATyTt/OUL/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/309] rtnetlink: count IFLA_PARENT_DEV_{NAME,BUS_NAME} in if_nlmsg_size
Date: Tue, 31 Mar 2026 18:19:58 +0200
Message-ID: <20260331161756.987193562@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 52501989c76206462d9b11a8485beef40ef41821 ]

Commit 00e77ed8e64d ("rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME")
added those attributes to rtnl_fill_ifinfo, but forgot to extend
if_nlmsg_size.

Fixes: 00e77ed8e64d ("rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/0b849da95562af45487080528d60f578636aba5c.1773919462.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 576d5ec3bb364..1960b59961cb8 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1267,6 +1267,21 @@ static size_t rtnl_dpll_pin_size(const struct net_device *dev)
 	return size;
 }
 
+static size_t rtnl_dev_parent_size(const struct net_device *dev)
+{
+	size_t size = 0;
+
+	/* IFLA_PARENT_DEV_NAME */
+	if (dev->dev.parent)
+		size += nla_total_size(strlen(dev_name(dev->dev.parent)) + 1);
+
+	/* IFLA_PARENT_DEV_BUS_NAME */
+	if (dev->dev.parent && dev->dev.parent->bus)
+		size += nla_total_size(strlen(dev->dev.parent->bus->name) + 1);
+
+	return size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1328,6 +1343,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(8)  /* IFLA_MAX_PACING_OFFLOAD_HORIZON */
 	       + nla_total_size(2)  /* IFLA_HEADROOM */
 	       + nla_total_size(2)  /* IFLA_TAILROOM */
+	       + rtnl_dev_parent_size(dev)
 	       + 0;
 }
 
-- 
2.51.0



