Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D866818DB17;
	Wed, 23 Apr 2025 14:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419850; cv=none; b=pRWDmgIl6uV1m8xQPMXlTm5Ai9vlDhye7+U38g551JS/1RKyBabk8ehxxZEzUdhyaQ7BhZEzSAFj94ci0sS+mOHoyNCCtr/Mw5HrertiJwaotF+IgmTiEGIrQPyfdCPRFN3ceP0c5I7n3smkvGuliv/n4YGjzk9wMGJ3b8iRBtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419850; c=relaxed/simple;
	bh=pdrQs++KqYIBUIPBvu+si3RSKKsZybue9jGJaVg75rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UejQdHQ6OVz1LxRUcsblKK1zcknBPevBV1IY+RnCdnMzmTl6iV9uXkeZ/CRCB8i7vb9vD/+L/v98eXsM3T3q2jrXokSx1S8m8UqncNEZfONwchAmMz/yt/xz4CoaOVEuTZ6Tukv7QoxwnQEPJKTrAQfGYZEcxv1krr28FErBmVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeyIaEh4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeyIaEh4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C10C4CEE2;
	Wed, 23 Apr 2025 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419850;
	bh=pdrQs++KqYIBUIPBvu+si3RSKKsZybue9jGJaVg75rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeyIaEh4BUyRM1Vcsto+uk/cCoZZjwh5KEWF+1yiVB4wmLhZZn+iU8FVitFmRPImD
	 g7F743uOqv/16IW0s3S3DfA+cqlmdWM++P5Gs6hPRj9E9MHqlFrZlYeSlifEDSnmG3
	 OJO/Stf9TlghkGg/1PInK/B2/RlR40iWVjFH95Ck=
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
Subject: [PATCH 6.6 012/393] rtnl: add helper to check if rtnl group has listeners
Date: Wed, 23 Apr 2025 16:38:28 +0200
Message-ID: <20250423142643.780745247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3d6cf306cd55e..a7d757e96c55f 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -130,4 +130,11 @@ extern int ndo_dflt_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
 
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



