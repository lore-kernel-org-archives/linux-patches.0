Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8830AD49
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A47C433EF;
	Wed,  4 Jan 2023 16:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849003;
	bh=gNuR4lz7qacuk26VC0zY9GUdUL5YqpTPnepTnvbtHQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fope+QGwmTvUW7HP15PV4tHVMU5aVgnvRJEiLfU8GvS/Wa6c80/ltZzlVkKJbZaW4
	 6WhY3PbXzCmHojoee5XgJyVZ57pFhyOHyiRS7BisYW6DMV/bp3lyYRaEQY5XB+vCHH
	 HYJjurRKlUMqxeZBXn3mOD+ERPfJDhRM6N6y8BYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 040/177] mptcp: netlink: fix some error return code
Date: Wed,  4 Jan 2023 17:05:31 +0100
Message-Id: <20230104160508.870026111@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

commit e0fe1123ab2b07d2cd5475660bd0b4e6993ffaa7 upstream.

Fix to return negative error code -EINVAL from some error handling
case instead of 0, as done elsewhere in those functions.

Fixes: 9ab4807c84a4 ("mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE")
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 9e82250cbb70..0430415357ba 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -156,6 +156,7 @@ int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_val.addr.id == 0 || !(addr_val.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
 		GENL_SET_ERR_MSG(info, "invalid addr id or flags");
+		err = -EINVAL;
 		goto announce_err;
 	}
 
@@ -282,6 +283,7 @@ int mptcp_nl_cmd_sf_create(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_l.id == 0) {
 		NL_SET_ERR_MSG_ATTR(info->extack, laddr, "missing local addr id");
+		err = -EINVAL;
 		goto create_err;
 	}
 
@@ -395,11 +397,13 @@ int mptcp_nl_cmd_sf_destroy(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_l.family != addr_r.family) {
 		GENL_SET_ERR_MSG(info, "address families do not match");
+		err = -EINVAL;
 		goto destroy_err;
 	}
 
 	if (!addr_l.port || !addr_r.port) {
 		GENL_SET_ERR_MSG(info, "missing local or remote port");
+		err = -EINVAL;
 		goto destroy_err;
 	}
 
-- 
2.39.0



