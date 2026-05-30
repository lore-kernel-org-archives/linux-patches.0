Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E3E3469FC;
	Sat, 30 May 2026 18:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166687; cv=none; b=BjAjs6Eq1f/Qv//dhOJDsDnpS5tdYCbBTwZkhPphsbWXN6l1x7KnnY0HpFBvOkLPR2iDfhFFU6y15EYH/ZwYVbd0tscZCJ1aJmko3fha7sGSlv1GTc5Ko/Iwm63eOeTXzk4wEYQXjYyFWLz1uQSxAS8qNT6d3Fw6M6WTo1UdcvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166687; c=relaxed/simple;
	bh=fWafcRpAIjiDnZ/QQ0nVLKog2nPQzLTuK0X22sBGrq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4QTJMb8abaG4oLS4WNViPxk51ErCXAzoe/aWD6hkNS0huNzNouV7UkEYJhzgVzlyqKoXZWI+Josv3RXwcbU+muQtV2uRYUizgGcnSjEEb+Qtca2N+AavET1+3RQ8chjuB4Ksybcw2FhwMf9yZbMVPgScJMJVjBeeVXzZed6PNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Se0KujH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Se0KujH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068A11F00893;
	Sat, 30 May 2026 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166686;
	bh=LADOyQutXuTuCS1wMVb/xuaegvqb5DavlH/PJBTJNPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Se0KujH4hZ5p0RyBl6w2Nv2WB+cL0FiMrluKVURplZCl4KTclQ09H2jxttXWFgv4c
	 fOzeJF6l6fdcXTDfazSZ2GKMvFz61XIU8kJNLnqWZscHHotDVAFT0yqZOY8dKmCN8q
	 4SOVur5aWb0E8vd4DbM/mkDRX/8nKI33lgpK7Ads=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 396/589] RDMA/core: Prefer NLA_NUL_STRING
Date: Sat, 30 May 2026 18:04:37 +0200
Message-ID: <20260530160235.191643379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 6ed3d14fc45d3da6025e7fe4a6a09066856698e2 ]

These attributes are evaluated as c-string (passed to strcmp), but
NLA_STRING doesn't check for the presence of a \0 terminator.

Either this needs to switch to nla_strcmp() and needs to adjust printf fmt
specifier to not use plain %s, or this needs to use NLA_NUL_STRING.

As the code has been this way for long time, it seems to me that userspace
does include the terminating nul, even tough its not enforced so far, and
thus NLA_NUL_STRING use is the simpler solution.

Fixes: 30dc5e63d6a5 ("RDMA/core: Add support for iWARP Port Mapper user space service")
Link: https://patch.msgid.link/r/20260330122742.13315-1-fw@strlen.de
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/iwpm_msg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/iwpm_msg.c b/drivers/infiniband/core/iwpm_msg.c
index 46686990a8271..698ec2e730510 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -381,9 +381,9 @@ int iwpm_remove_mapping(struct sockaddr_storage *local_addr, u8 nl_client)
 /* netlink attribute policy for the received response to register pid request */
 static const struct nla_policy resp_reg_policy[IWPM_NLA_RREG_PID_MAX] = {
 	[IWPM_NLA_RREG_PID_SEQ]     = { .type = NLA_U32 },
-	[IWPM_NLA_RREG_IBDEV_NAME]  = { .type = NLA_STRING,
+	[IWPM_NLA_RREG_IBDEV_NAME]  = { .type = NLA_NUL_STRING,
 					.len = IWPM_DEVNAME_SIZE - 1 },
-	[IWPM_NLA_RREG_ULIB_NAME]   = { .type = NLA_STRING,
+	[IWPM_NLA_RREG_ULIB_NAME]   = { .type = NLA_NUL_STRING,
 					.len = IWPM_ULIBNAME_SIZE - 1 },
 	[IWPM_NLA_RREG_ULIB_VER]    = { .type = NLA_U16 },
 	[IWPM_NLA_RREG_PID_ERR]     = { .type = NLA_U16 }
@@ -698,7 +698,7 @@ int iwpm_remote_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
 
 /* netlink attribute policy for the received request for mapping info */
 static const struct nla_policy resp_mapinfo_policy[IWPM_NLA_MAPINFO_REQ_MAX] = {
-	[IWPM_NLA_MAPINFO_ULIB_NAME] = { .type = NLA_STRING,
+	[IWPM_NLA_MAPINFO_ULIB_NAME] = { .type = NLA_NUL_STRING,
 					.len = IWPM_ULIBNAME_SIZE - 1 },
 	[IWPM_NLA_MAPINFO_ULIB_VER]  = { .type = NLA_U16 }
 };
-- 
2.53.0



