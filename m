Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A522E7BD4;
	Tue, 12 Aug 2025 18:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022952; cv=none; b=IGa9/wxZT03Rdz41teaFLGbMpllb3dTL4OIhUtb1t/c1SsazjVuzlCURuZSqj+VNeK7dER6kyJrIHdohvDmD7UyctKM/SSfI/ZZ1ylwUcT4eMUj0nIBg4aKZs+RqLr449aBuV8eJk3EXXg4O7IGPiaxec65TI7uI15VKveDctow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022952; c=relaxed/simple;
	bh=poXzssY3S7rEvxo8kG7TmDjOqJjZM+d7gUxIH8bUwlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o5oYGIegvry+cQbx1jiA1fmI3VCzmR2+aaPyzk7jP8VNHFbZkLYTHj9os4pnxmlC5SNbmUBxl1lLWOC/ZzETBjEDr3SC1WXvDg0rxY1NpyAytpp9u+K6KwKPiqKU7o5Ks32kNNFzdsW7MFaGi+R5R8q5rFG+RXOOMPBa11Z50Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nhF1ShH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nhF1ShH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024E0C4CEF0;
	Tue, 12 Aug 2025 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022952;
	bh=poXzssY3S7rEvxo8kG7TmDjOqJjZM+d7gUxIH8bUwlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nhF1ShH3bn7/JqtoxxQd9MxN+MqkDM2YmJgBnMgwLWW+VxZ3fgkyPquEwuDoXIpJD
	 Xbp6ykZreWaqooG3nkpvIfxFZ0opS0SpZ84vJnltl4TRjrzyshLy5wHklj4lXYWSx7
	 dMTczYRAIu3MPLGcw4YFFqXvDRUIUK6r/l+K/eSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Maher Azzouzi <maherazz04@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/369] net/sched: mqprio: fix stack out-of-bounds write in tc entry parsing
Date: Tue, 12 Aug 2025 19:30:03 +0200
Message-ID: <20250812173028.242665265@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Azzouzi <maherazz04@gmail.com>

[ Upstream commit ffd2dc4c6c49ff4f1e5d34e454a6a55608104c17 ]

TCA_MQPRIO_TC_ENTRY_INDEX is validated using
NLA_POLICY_MAX(NLA_U32, TC_QOPT_MAX_QUEUE), which allows the value
TC_QOPT_MAX_QUEUE (16). This leads to a 4-byte out-of-bounds stack
write in the fp[] array, which only has room for 16 elements (0–15).

Fix this by changing the policy to allow only up to TC_QOPT_MAX_QUEUE - 1.

Fixes: f62af20bed2d ("net/sched: mqprio: allow per-TC user input of FP adminStatus")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Maher Azzouzi <maherazz04@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250802001857.2702497-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_mqprio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index 51d4013b6121..f3e5ef9a9592 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -152,7 +152,7 @@ static int mqprio_parse_opt(struct net_device *dev, struct tc_mqprio_qopt *qopt,
 static const struct
 nla_policy mqprio_tc_entry_policy[TCA_MQPRIO_TC_ENTRY_MAX + 1] = {
 	[TCA_MQPRIO_TC_ENTRY_INDEX]	= NLA_POLICY_MAX(NLA_U32,
-							 TC_QOPT_MAX_QUEUE),
+							 TC_QOPT_MAX_QUEUE - 1),
 	[TCA_MQPRIO_TC_ENTRY_FP]	= NLA_POLICY_RANGE(NLA_U32,
 							   TC_FP_EXPRESS,
 							   TC_FP_PREEMPTIBLE),
-- 
2.39.5



