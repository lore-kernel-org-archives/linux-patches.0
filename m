Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656BD29BD9D;
	Tue, 12 Aug 2025 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026790; cv=none; b=SlomBOdQYynqmdVNWO/f3pCV7aKQUdl/zgPjThH+XJA7f4XunliNH90R0Pfz9B33SGwSeeksFHC2B4IDKNFHm/a7R0oKwL5aE5hHAzRE07sm8aCPEEgFLqJRoS2ct5Cws/DjBGVLXQhF2Sdh6aROZudKBYGoMn7wvHR6ph8ETn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026790; c=relaxed/simple;
	bh=Wzn0hxnVVQxg9BAA69bhzo5FaQpiHlIA8D3/NFtmOig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ltHXsHfXwccCEtK9bSdm9Q09UQG2/ZBs7PP18KMnAltjn2+8kW22aP+BOU/wia1ZCGOPKu7cddKY8c0McpGZ2Bg5WfBYByncysLlLUEg50MXfhyKIKkNv9CQlwo+UwznvWqpjsiR6ZYwUXscWU+VmnSChvBeD2FX4wGyZ33d570=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGk/LvIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGk/LvIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7430C4CEF1;
	Tue, 12 Aug 2025 19:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026790;
	bh=Wzn0hxnVVQxg9BAA69bhzo5FaQpiHlIA8D3/NFtmOig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGk/LvIqwSdZDhH1H+3SdxTzaQQmiL70N1+jKTH3dUqFCRJVlSC4q285m0K8WF4pa
	 BktcT4/CJSWE5B8bNqRDkSpaOAGZFNeJEkSmsZ9YbqASOiw7V2lhH3isSCoFhedlYS
	 iPnk/MC9GqhFep4KL/bUqZbLjwrQoriSfUqOlrhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Maher Azzouzi <maherazz04@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 409/480] net/sched: mqprio: fix stack out-of-bounds write in tc entry parsing
Date: Tue, 12 Aug 2025 19:50:17 +0200
Message-ID: <20250812174414.298283688@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



