Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAE33242D7;
	Sat, 30 May 2026 17:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161519; cv=none; b=ke2uy48SPwhpwUintUWXvC+oEiMJLtnvp7eMwQWdKYeriIc1w3FhG70vAhqGy5nB0sMbO6YgSPluaM5qQesps7fiU3xV3vTjhre7f0dM96dBQUm59kn/RsvWpYfKnWia2ih9KLh7l84ELjuYUCTxi4f3ejO9YM9AflSHZe9uTYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161519; c=relaxed/simple;
	bh=kGCiBuQujOl2Dz56FmAg8yPzAmn5SAU1NIcpEjqy+eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwfjARYQ5M4VP611En6otab6M82KuU8/rJ7En39A1vn4eB0SaLo3T65BPGCq2KaABJi4KzcRKCVdoTuzIIttH/raqcyFg0unKy2v3tQmZVCTWh96NQu3s+2fpwqkUKwH47P7XsbAVNHiLqz1Z26ZSUr4S0zkLabnxO1Eo19ymOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXiCgSbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXiCgSbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58DF1F00893;
	Sat, 30 May 2026 17:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161518;
	bh=ZX+Guv9BBT98xtouhDPFiYwmIfnKW3TN56AgGLutdLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXiCgSbe+8yv88wNCpTlzjWm1gWHZpx8pD7mTQZygiyJjQMhvz5ZienHDRbXMcgB8
	 iZD0bX3mPyS1vhHo9TXxhqM/6iBAzp1uqjTIet5W6Q3w2fQRiAgfv7JEGiWvyyi/fX
	 z+w+VKFu9ihkdFm4ZhwOfCK5yWthgsNtus2lZBoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 648/969] RDMA/core: Prefer NLA_NUL_STRING
Date: Sat, 30 May 2026 18:02:52 +0200
Message-ID: <20260530160318.356204219@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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
index 3c9a9869212bb..feb09008eb9ca 100644
--- a/drivers/infiniband/core/iwpm_msg.c
+++ b/drivers/infiniband/core/iwpm_msg.c
@@ -365,9 +365,9 @@ int iwpm_remove_mapping(struct sockaddr_storage *local_addr, u8 nl_client)
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
@@ -677,7 +677,7 @@ int iwpm_remote_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
 
 /* netlink attribute policy for the received request for mapping info */
 static const struct nla_policy resp_mapinfo_policy[IWPM_NLA_MAPINFO_REQ_MAX] = {
-	[IWPM_NLA_MAPINFO_ULIB_NAME] = { .type = NLA_STRING,
+	[IWPM_NLA_MAPINFO_ULIB_NAME] = { .type = NLA_NUL_STRING,
 					.len = IWPM_ULIBNAME_SIZE - 1 },
 	[IWPM_NLA_MAPINFO_ULIB_VER]  = { .type = NLA_U16 }
 };
-- 
2.53.0



