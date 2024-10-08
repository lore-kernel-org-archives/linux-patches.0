Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EF71D26F2;
	Tue,  8 Oct 2024 12:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389985; cv=none; b=oiUMvRN0qOdjap8ErOwGn5wNvQZcKdS7zFAFixbfaUNyOB7t/U0XDgbK4A8yLsh7VSO40RMIjcAw9W86l4uwxwy7/hq/7cOVrkVcuEQnMytr7Qc8gVg0R9ivdHu2sinL9NNMW6ERBFPrKhCgMihElTmrRSYkd3yaHAu5uOsjweo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389985; c=relaxed/simple;
	bh=xEt7zUk8UzCp/3Ezl/pfCj7Wo1gQVbKd+BCnyQZi5Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tlxq6MGR4ONoWkVjpVehxHM1rb0mK76vjva1Stn2KlU0CfER3MBA3Nxo9qDdWa+5p5Ywj3ITeLdB0JJlhg/Co40cXdIjixu8489vVf78g6/43fhAQ5jqgHH5x5yeZ3bH1fJM0jEKPInY4+BFpqX99iuKtNlZcVQUX8HPlG3b4No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lbrwokol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lbrwokol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D881C4CEC7;
	Tue,  8 Oct 2024 12:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389985;
	bh=xEt7zUk8UzCp/3Ezl/pfCj7Wo1gQVbKd+BCnyQZi5Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbrwokolINwdBEvfTXoUNyOmCLOQAYpKFwXyGAthh1yYlcHHHTdGUTw7f63G6Clva
	 Af+QAyjMl89+n1K/VBfxtmswDedRPfieMWTeqfmFGRZGSh9Pw2MvcEVdtHPgwNX7Ya
	 iLgw0AaUuplX3vCg1z2biWbqot3nqbOrHVB+GB1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 124/482] netdev-genl: Set extack and fix error on napi-get
Date: Tue,  8 Oct 2024 14:03:07 +0200
Message-ID: <20241008115653.186435776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 4e3a024b437ec0aee82550cc66a0f4e1a7a88a67 ]

In commit 27f91aaf49b3 ("netdev-genl: Add netlink framework functions
for napi"), when an invalid NAPI ID is specified the return value
-EINVAL is used and no extack is set.

Change the return value to -ENOENT and set the extack.

Before this commit:

$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/netdev.yaml \
                          --do napi-get --json='{"id": 451}'
Netlink error: Invalid argument
nl_len = 36 (20) nl_flags = 0x100 nl_type = 2
	error: -22

After this commit:

$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/netdev.yaml \
                         --do napi-get --json='{"id": 451}'
Netlink error: No such file or directory
nl_len = 44 (28) nl_flags = 0x300 nl_type = 2
	error: -2
	extack: {'bad-attr': '.id'}

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20240831121707.17562-1-jdamato@fastly.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netdev-genl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 05f9515d2c05c..a17d7eaeb0019 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -216,10 +216,12 @@ int netdev_nl_napi_get_doit(struct sk_buff *skb, struct genl_info *info)
 	rtnl_lock();
 
 	napi = napi_by_id(napi_id);
-	if (napi)
+	if (napi) {
 		err = netdev_nl_napi_fill_one(rsp, napi, info);
-	else
-		err = -EINVAL;
+	} else {
+		NL_SET_BAD_ATTR(info->extack, info->attrs[NETDEV_A_NAPI_ID]);
+		err = -ENOENT;
+	}
 
 	rtnl_unlock();
 
-- 
2.43.0



