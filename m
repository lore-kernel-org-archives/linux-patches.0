Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D808219C8A;
	Tue, 12 Nov 2024 10:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408303; cv=none; b=sZfYMXgXqfT7VIT1YR6ZrYZY06b2dFEqGbrOJtEeOh560IUwbpwjnsuqR8Uy4TifGnCfNREL3HBRVk9TkrMnconBuzUrsfh9vpJ0/6KCc8rG7pZyYxLnvaGzeepBsoMi0/XX2yV22sDRTyKJPC3irHoIEjaRg/5FEws+dZbSJ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408303; c=relaxed/simple;
	bh=noR7LvMedfxNBpyY9jgrxMarB6WqL9VFdQUsxKfPpYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+OG0Ia6UMvu7uOE/MSdHuJvNo+Jm3jYL+i2UvobW8t4AkCXqqEWUKIbGDAbWjzyCJxnuj8UABy32ws3W/D0pNWs5DinPQtr0a6OijUh5MBKO/5aShHg2FLs7wLrVEbu2xG71hpbcNoGNVhDFwYhSiVhdX4B8NwzGXtxUms8h4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TXHrU+l/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TXHrU+l/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E968CC4CECD;
	Tue, 12 Nov 2024 10:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408303;
	bh=noR7LvMedfxNBpyY9jgrxMarB6WqL9VFdQUsxKfPpYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TXHrU+l/J8b5Izfr4bydtRJsMhfQTCeakF64ye4BvnltwLt92bt4uQdSgUgqKB9IY
	 y92aq0QAu51mzBq5RC47Yxwf5n2MbAqKIXZ5e4Pa9YRtlRvZlWKzcEON5FzOnm/Jmd
	 CToWGZILavFTglm23p9Gm8uM94CHEZeWJEKdT68s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Caratti <dcaratti@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 121/184] mptcp: no admin perm to list endpoints
Date: Tue, 12 Nov 2024 11:21:19 +0100
Message-ID: <20241112101905.511200237@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit cfbbd4859882a5469f6f4945937a074ee78c4b46 upstream.

During the switch to YNL, the command to list all endpoints has been
accidentally restricted to users with admin permissions.

It looks like there are no reasons to have this restriction which makes
it harder for a user to quickly check if the endpoint list has been
correctly populated by an automated tool. Best to go back to the
previous behaviour then.

mptcp_pm_gen.c has been modified using ynl-gen-c.py:

   $ ./tools/net/ynl/ynl-gen-c.py --mode kernel \
     --spec Documentation/netlink/specs/mptcp_pm.yaml --source \
     -o net/mptcp/mptcp_pm_gen.c

The header file doesn't need to be regenerated.

Fixes: 1d0507f46843 ("net: mptcp: convert netlink from small_ops to ops")
Cc: stable@vger.kernel.org
Reviewed-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241104-net-mptcp-misc-6-12-v1-1-c13f2ff1656f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/netlink/specs/mptcp_pm.yaml |    1 -
 net/mptcp/mptcp_pm_gen.c                  |    1 -
 2 files changed, 2 deletions(-)

--- a/Documentation/netlink/specs/mptcp_pm.yaml
+++ b/Documentation/netlink/specs/mptcp_pm.yaml
@@ -293,7 +293,6 @@ operations:
       doc: Get endpoint information
       attribute-set: attr
       dont-validate: [ strict ]
-      flags: [ uns-admin-perm ]
       do: &get-addr-attrs
         request:
           attributes:
--- a/net/mptcp/mptcp_pm_gen.c
+++ b/net/mptcp/mptcp_pm_gen.c
@@ -112,7 +112,6 @@ const struct genl_ops mptcp_pm_nl_ops[11
 		.dumpit		= mptcp_pm_nl_get_addr_dumpit,
 		.policy		= mptcp_pm_get_addr_nl_policy,
 		.maxattr	= MPTCP_PM_ATTR_TOKEN,
-		.flags		= GENL_UNS_ADMIN_PERM,
 	},
 	{
 		.cmd		= MPTCP_PM_CMD_FLUSH_ADDRS,


