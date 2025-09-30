Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E3C2FFDE6;
	Tue, 30 Sep 2025 14:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244359; cv=none; b=AM1c0IezeDVtuco71xfNeubLymJRIRtYepwoawBT9V3Eu2VW7NaYyD5jQEA9yesqIye5dbdrt2BOK5XB+1G1gZIfTW3qZuuAHZgIXdmQVj6oG7nhEas6PkJFDHfWhV2sengLXlTdeyt7hLD1ZzNckU89dFS8U23uNxHRFid+XUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244359; c=relaxed/simple;
	bh=6tfGCj5qLArekWJOjC7aWi5jJSO3wbRQ+9qfJs7uij8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXlKKnIuJTY4x24SkgGyKt4pnXInVhZw621Db60mBsFKRzGhesWIQJjhM8fsf7Il1YoAuMOxjaHm6RDLcYCZ2xA2fBQYRT5D6mxbn9G4y0X0umMFffcnZ9NBzk3S4BBgpuz7GLwL/hE7BBX8laRkzvzmE4Mij7HQyQTqpw+/aQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjXmu9Yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjXmu9Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A54C4CEF0;
	Tue, 30 Sep 2025 14:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244359;
	bh=6tfGCj5qLArekWJOjC7aWi5jJSO3wbRQ+9qfJs7uij8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjXmu9YpTzvK8l1y8Kz7kVyfFQYQXEREN138ywQOtfwnZrY4yoqpJpCvqLkdwW2Qd
	 ORYq7wY3GZyIYUEpkYKvVRP1RF+dC2J/LnI3LOwcTPavUKzXY208vT1Pnyq9j+WpDB
	 kZp4C1fplXK3C9UAGCCemTbAWrP++czRCTaypZC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/122] nexthop: Emit a notification when a single nexthop is replaced
Date: Tue, 30 Sep 2025 16:47:16 +0200
Message-ID: <20250930143827.276860040@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 8c09c9f9d846cdd8a92604c591132985b04fd1d6 ]

The notification is emitted after all the validation checks were
performed, but before the new configuration (i.e., 'struct nh_info') is
pointed at by the old shell (i.e., 'struct nexthop'). This prevents the
need to perform rollback in case the notification is vetoed.

The next patch will also emit a replace notification for all the nexthop
groups in which the nexthop is used.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 390b3a300d78 ("nexthop: Forbid FDB status change while nexthop is in a group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 3063aa1914b1f..d2b338b357220 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1009,12 +1009,22 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 				  struct netlink_ext_ack *extack)
 {
 	struct nh_info *oldi, *newi;
+	int err;
 
 	if (new->is_group) {
 		NL_SET_ERR_MSG(extack, "Can not replace a nexthop with a nexthop group.");
 		return -EINVAL;
 	}
 
+	err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new, extack);
+	if (err)
+		return err;
+
+	/* Hardware flags were set on 'old' as 'new' is not in the red-black
+	 * tree. Therefore, inherit the flags from 'old' to 'new'.
+	 */
+	new->nh_flags |= old->nh_flags & (RTNH_F_OFFLOAD | RTNH_F_TRAP);
+
 	oldi = rtnl_dereference(old->nh_info);
 	newi = rtnl_dereference(new->nh_info);
 
-- 
2.51.0



