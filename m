Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8513DFC7D;
	Tue, 31 Mar 2026 16:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974951; cv=none; b=JQDosU8kgFKyuxA0IlGRlNjk+DwgILNgqb+20rCzriJ0t6eak8ULHS3TRT/Q06PRLkZqa7byxngOKisLKNaIx7ZlfTUXIIaY4PAwYS0M/GTiVauIVFupc3TS75cWhfATr0bwt70m8XAmmA0vXGouoT/7X7K9a8AYHFdh7EVMfBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974951; c=relaxed/simple;
	bh=SnR/bJ9efnBYI6u7B20eldiK9wF1+Y0NpyehxmjzCZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uuzM3J+46z3GAInHEhrGIwJ7Wv1VeOJfParYK3vgai8ZG2ZkeqCWwRg5Qp3gG5kWuVVRLyvZ3WPDWS8dZP8gyMiv+TM7LitwxNA7fPxCN13bJQ1k9wssph09YLGJLDLy0w8OmRgxRtWDhIqBM8ZCNxFQzRK5r1U13Z3gQOBCGk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AILQYpdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AILQYpdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8491AC2BCB4;
	Tue, 31 Mar 2026 16:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974950;
	bh=SnR/bJ9efnBYI6u7B20eldiK9wF1+Y0NpyehxmjzCZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AILQYpdDiKRI3E93s9o+MKLMtEIUf6uN0p0qJP2L4v2GtnXj4HFPnp9l8F6/rWD26
	 SV+lrN9Y+yZtG1rupZ190z9lqnWAYTBIRNJQQH1Z84gmewgQ0R/DSR9zuQ15Q3fBYV
	 w3BoT2f/MP28aohEFrwvuDaTkL0+V+97Xmw/6e90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 107/342] rtnetlink: count IFLA_INFO_SLAVE_KIND in if_nlmsg_size
Date: Tue, 31 Mar 2026 18:19:00 +0200
Message-ID: <20260331161802.951925747@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit ee00a12593ffb69db4dd1a1c00ecb0253376874a ]

rtnl_link_get_slave_info_data_size counts IFLA_INFO_SLAVE_DATA, but
rtnl_link_slave_info_fill adds both IFLA_INFO_SLAVE_DATA and
IFLA_INFO_SLAVE_KIND.

Fixes: ba7d49b1f0f8 ("rtnetlink: provide api for getting and setting slave info")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/049843b532e23cde7ddba263c0bbe35ba6f0d26d.1773919462.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 63cbba9e46b93..6cdf6ee8be216 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -707,11 +707,14 @@ static size_t rtnl_link_get_slave_info_data_size(const struct net_device *dev)
 		goto out;
 
 	ops = master_dev->rtnl_link_ops;
-	if (!ops || !ops->get_slave_size)
+	if (!ops)
+		goto out;
+	size += nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_SLAVE_KIND */
+	if (!ops->get_slave_size)
 		goto out;
 	/* IFLA_INFO_SLAVE_DATA + nested data */
-	size = nla_total_size(sizeof(struct nlattr)) +
-	       ops->get_slave_size(master_dev, dev);
+	size += nla_total_size(sizeof(struct nlattr)) +
+		ops->get_slave_size(master_dev, dev);
 
 out:
 	rcu_read_unlock();
-- 
2.51.0



