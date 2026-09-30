Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5CD2BEFEE;
	Wed, 30 Sep 2026 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784940; cv=none; b=KGQ86K9QliFpIJa/SsvW4dDf4n8OlKz8qsQcZxh6xNgDyyULs60Kxwzp465XCpv+1YfstuOeWdLWzFIxlVKORH13vW0aFoFXNbyNIbGzzv521osnLBrM9JbNYFWNfwASPxnb79eFyIgGkLAWBeMhst0FqXjezZG88B2Ec2JLgF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784940; c=relaxed/simple;
	bh=eKyIkXZBI+4mNMuEN0h07TzXENj+CvwVKpk7Jz/C4uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e664ASLe1A0ANFWv411nvDcMae8uAQzpDdm76Bg+ZYRpW0RSbU8MYT//Ya4xBawGd6/R8iGOa5EV4Z+1BVqdFySHZij7SEJzH8O3kymDCXZLjqrK7AMDAgenosBmn/hz5BjVBNVMhOFj8qDeKmDfDqGfGG/vJSNqorzimL2y26M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKGPWXYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKGPWXYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 864781F00893;
	Wed, 30 Sep 2026 16:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784935;
	bh=SeKp13rvMZhKIJdSNhhqQHWbrdptNyC7aDH8/tUfYDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKGPWXYn8MMGBXwa2kmfn0cnb6ySdMqKAB2+9tO1EDJO0Yo320triU56UK4R9WV3F
	 grzWa7YaLVsMjaSzS5jHgOXpZVnWyVNadxSarNls5iSge0hWYxUv+0u21U2qFV9oQd
	 c8tgdei67wZDdoeyWa7bgGiQikg7o3uo4ijSq2dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 330/982] rtnl: add helper to send if skb is not null
Date: Wed, 30 Sep 2026 17:17:46 +0200
Message-ID: <20260930152423.907867430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit ddb6b284bdc32b6e218b3d90b5a745ea26620812 ]

This is a convenience helper for routines handling conditional rtnl
events, that is code that might send a notification depending on
rtnl_has_listeners/rtnl_notify_needed.

Instead of:
   if (skb)
      rtnetlink_send(...)

Use:
      rtnetlink_maybe_send(...)

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://lore.kernel.org/r/20231208192847.714940-4-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 251367a0a331 ("net/sched: act_api: fix skb sizing and action leak on reoffload delete")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtnetlink.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 9494b7647e812..a01bd720e7cdd 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -10,6 +10,13 @@
 #include <uapi/linux/rtnetlink.h>
 
 extern int rtnetlink_send(struct sk_buff *skb, struct net *net, u32 pid, u32 group, int echo);
+
+static inline int rtnetlink_maybe_send(struct sk_buff *skb, struct net *net,
+				       u32 pid, u32 group, int echo)
+{
+	return !skb ? 0 : rtnetlink_send(skb, net, pid, group, echo);
+}
+
 extern int rtnl_unicast(struct sk_buff *skb, struct net *net, u32 pid);
 extern void rtnl_notify(struct sk_buff *skb, struct net *net, u32 pid,
 			u32 group, const struct nlmsghdr *nlh, gfp_t flags);
-- 
2.53.0



