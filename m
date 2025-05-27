Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966261FB3;
	Tue, 27 May 2025 17:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367936; cv=none; b=h3eZA7Tx/sQONUGwmQZNrf/SfJcS9NPiYvz0VjendFsufHHy0Ei7/JnSxfJc1HXblEd0kWig2R04WV3p7+DuWwMIU1XSOyKqTkFEF0/rJP+0HzkA7qTrGO4k43BEWAHKeZsCZZQFwm3+J0sJSodreJsk6pCHHDCpJSLM03otZu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367936; c=relaxed/simple;
	bh=pgWIQgYy+n1gFsy7unnLb8kC3tKO3JO9hbD/vzJg2Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eo2+eaqngRIxvxHmYkyyxy2lqFCTIMxw7F2QqzgxfTWHKV24cGpUc+ZrEu7biWvZ2/eKt34UOldI4fwTGlKwyT+E18NrgjoP3uDicDUQQaYYCW0klpfzFaVanNPR1JViarxu1sNUnlCvzmtZQagxev5QDUsOrGvd1nuTiAxkcpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDfMjoUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDfMjoUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F04CC4CEE9;
	Tue, 27 May 2025 17:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367936;
	bh=pgWIQgYy+n1gFsy7unnLb8kC3tKO3JO9hbD/vzJg2Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDfMjoUeoONK1aZlNNJ9M90G9QY01t0MYQ9mB5OoYHGKMKjKHjeyrK6mr7TdHSrAk
	 IlNX9QHqpgNRsPJ5wG0xaawNWJP306wKlbUtPzm5K/RPLrKdzcjV8hDwuyOC80pXQv
	 uFBuGdYUmJd0KkL9WT0c/TR2ikqbrx4wIdIifKwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 517/783] mptcp: pm: userspace: flags: clearer msg if no remote addr
Date: Tue, 27 May 2025 18:25:14 +0200
Message-ID: <20250527162534.198950268@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 58b21309f97b08b6b9814d1ee1419249eba9ef08 ]

Since its introduction in commit 892f396c8e68 ("mptcp: netlink: issue
MP_PRIO signals from userspace PMs"), it was mandatory to specify the
remote address, because of the 'if (rem->addr.family == AF_UNSPEC)'
check done later one.

In theory, this attribute can be optional, but it sounds better to be
precise to avoid sending the MP_PRIO on the wrong subflow, e.g. if there
are multiple subflows attached to the same local ID. This can be relaxed
later on if there is a need to act on multiple subflows with one
command.

For the moment, the check to see if attr_rem is NULL can be removed,
because mptcp_pm_parse_entry() will do this check as well, no need to do
that differently here.

Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_userspace.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 940ca94c88634..cd220742d2493 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -583,11 +583,9 @@ int mptcp_userspace_pm_set_flags(struct sk_buff *skb, struct genl_info *info)
 	if (ret < 0)
 		goto set_flags_err;
 
-	if (attr_rem) {
-		ret = mptcp_pm_parse_entry(attr_rem, info, false, &rem);
-		if (ret < 0)
-			goto set_flags_err;
-	}
+	ret = mptcp_pm_parse_entry(attr_rem, info, false, &rem);
+	if (ret < 0)
+		goto set_flags_err;
 
 	if (loc.addr.family == AF_UNSPEC ||
 	    rem.addr.family == AF_UNSPEC) {
-- 
2.39.5



