Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB83A23D298;
	Wed, 23 Apr 2025 14:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419974; cv=none; b=lzUaj3OLeSCs9i3Jyh1dAUSNn4zyfhJBJSlZ86YuxZTLH6zuOgALRdMsAWaUANKD0dK5xG1kUZY6bG5x4gJb396YE/SvwTylizT8tdI+hMQm2aWD23V431liy4AIbCfLefILkYWDi9ivqN7YWItrItoExAkq2l/FWMMO8SQaz84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419974; c=relaxed/simple;
	bh=f09dpu4JuaXkZZhD8pkXE67bZfQ44EH+3fAjB4vEXhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DF/dluUjIiFv5J1TNrqH9D61uWRQiDwhax2Fy4STBOva7aatwNUq9zae2U7y8JhiOnZ90UKaXrWeJNRcn6TR0PGPY59zIcQ/JMsjPsuqf/vJvXU9QidV1ela4zJTv/ZaOlDR/t7/KrnsWEM3gOA9c9Tp62CYGovZL1SDnPWnmH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmC5KAYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmC5KAYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DFC5C4CEE2;
	Wed, 23 Apr 2025 14:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419973;
	bh=f09dpu4JuaXkZZhD8pkXE67bZfQ44EH+3fAjB4vEXhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmC5KAYV1d3aCnhDaHOvKQDexmuSKNt74sgG9C8LZ8y6j05uZg7OeGCL9WyaFqsKw
	 EUNF8V1XdpjNz1szmDLhcnNfLgxceRhnwPaXCd4cbymzxjrbgihdHpViQdyBNqyoFx
	 G9kDRqx9TagZ/7FqcRF4MX8rCWjhTwLZQDmbIfxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/291] rtnl: add helper to check if rtnl group has listeners
Date: Wed, 23 Apr 2025 16:39:55 +0200
Message-ID: <20250423142624.673378406@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit c5e2a973448d958feb7881e4d875eac59fdeff3d ]

As of today, rtnl code creates a new skb and unconditionally fills and
broadcasts it to the relevant group. For most operations this is okay
and doesn't waste resources in general.

When operations are done without the rtnl_lock, as in tc-flower, such
skb allocation, message fill and no-op broadcasting can happen in all
cores of the system, which contributes to system pressure and wastes
precious cpu cycles when no one will receive the built message.

Introduce this helper so rtnetlink operations can simply check if someone
is listening and then proceed if necessary.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://lore.kernel.org/r/20231208192847.714940-2-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 369609fc6272 ("tc: Ensure we have enough buffer space when sending filter netlink notifications")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rtnetlink.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index ae2c6a3cec5db..ad5f15d369235 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -138,4 +138,11 @@ extern int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 
 extern void rtnl_offload_xstats_notify(struct net_device *dev);
 
+static inline int rtnl_has_listeners(const struct net *net, u32 group)
+{
+	struct sock *rtnl = net->rtnl;
+
+	return netlink_has_listeners(rtnl, group);
+}
+
 #endif	/* __LINUX_RTNETLINK_H */
-- 
2.39.5



