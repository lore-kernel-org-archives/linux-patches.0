Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4592F35C68D;
	Tue, 21 Jul 2026 21:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668870; cv=none; b=MFMNTkM969zMTUqOvW+VTdRzh5khEfsydvZSapMskoaW2vaT0xuxAK4uGIMALov1iu7xK992sIdNXraw+WBxznPqVjKHAU6sPUCzhscFyRmF3dVYdTKsHRVqOPcc5BZNaLZRJudM/R19LT7t9WmXfp7KcH86z0glV3ymP96t76E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668870; c=relaxed/simple;
	bh=+gcnr4Dc27WtAfaPcCSQkhLxtCsWxi9KIk1QzexadhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFaThJ/qKhFUxSJFWa86QIhiU95JHWY7keA3Naea1R6ho2t0SgpCEpnJslfGFhIc5d+8rve8JfvPxkdEroHmriswdCRShWVoiVAtpeRWtga2FHhdrsa0bYu1Gaa7s3auLsbToJreTLo7ppExr3LM/GWkC2bBvkmPRxMiiuvb5JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xo6UO96w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xo6UO96w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9141F000E9;
	Tue, 21 Jul 2026 21:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668868;
	bh=RUueN+8aeRIajt4TEez5Zk+1c1mAUKqRbgll4pODRz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xo6UO96wPqxKraZ2JHeqIO3NLOVaDoza04X6srxyZjektKJI/Jsme5MsN+/pLSTm7
	 yY721sFV7Aea+qFYYEvoNobEs0GZ4RwURxUyIC7FTm5ZR6CgSO4WTRlBKtIwIL4fe+
	 aGkLYfg4PeOuu7qmtd8V21nZjr6c4YRyYsfTlFvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stephen Suryaputra <ssuryaextr@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0340/1067] ipv6: guard against possible NULL deref in __in6_dev_stats_get()
Date: Tue, 21 Jul 2026 17:15:41 +0200
Message-ID: <20260721152432.200975662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 507541c2a8eeb76c02bd2511958f73a8cfa3e1bc ]

dev_get_by_index_rcu() could return NULL if the original physical
device is unregistered.

Found by Sashiko.

Fixes: e1ae5c2ea478 ("vrf: Increment Icmp6InMsgs on the original netdev")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Stephen Suryaputra <ssuryaextr@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260526145529.3587126-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/addrconf.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 5bcc63eade0357..d95cf59727cd17 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -334,8 +334,11 @@ static inline struct inet6_dev *__in6_dev_get(const struct net_device *dev)
 static inline struct inet6_dev *__in6_dev_stats_get(const struct net_device *dev,
 						    const struct sk_buff *skb)
 {
-	if (netif_is_l3_master(dev))
+	if (netif_is_l3_master(dev)) {
 		dev = dev_get_by_index_rcu(dev_net(dev), inet6_iif(skb));
+		if (!dev)
+			return NULL;
+	}
 	return __in6_dev_get(dev);
 }
 
-- 
2.53.0



