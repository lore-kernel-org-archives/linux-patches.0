Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00865282E1;
	Tue, 12 Aug 2025 18:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021752; cv=none; b=k0qCxEyGDO7PSSmCMHRouhBvl43GpQNZH3HLOyguXoQ7olee+1LMUJVu8JWO1/ZPUlr8GAvAqiHlPS0SBjvu4PyUvbpKnr77ld6npb22HaODSsbdKPeqhYVMj0NFmyCc7GVwvKLQwEIcHq2Rs5wmbGresuuqpLR063xwbtkHN58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021752; c=relaxed/simple;
	bh=fus9dX9dGf1C8lDD86NA3W6qndtDcsrD9ny9mY0YkHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s8r6PY9JrfKhxhAARTuwEf+Z9Mg8TwUYb9nu1kP8wS9xiDsQglHEW8JApQ2ivrrC4WnvXasTr8HoFnNi3fLUBlkGBjTbf3EiHrIYlR2u0F456x9DnOZL8G1Qxo8u6YJDUBIQBHX6OBKOVXJClgc9dRYKZuCgWKL1eFhO5fpwYJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuPn97BU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuPn97BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506DAC4CEF0;
	Tue, 12 Aug 2025 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021751;
	bh=fus9dX9dGf1C8lDD86NA3W6qndtDcsrD9ny9mY0YkHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuPn97BUa3h8OHsbtKCeEMQPOHreYE8SxcyWP72dGKvTpEUjgJ0syICDMrOwnkqf9
	 1l/IVsn+fwKjdZHn7/vqgFxkJDFS41zPDJtin3CsNqFAMlNZItfTCYFF9yZaM96AmL
	 qbbAnMdWF6BOQNjd6n1Z0+v1Gk9r0YtzeY5l+CQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Maher Azzouzi <maherazz04@gmail.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 214/262] net/sched: mqprio: fix stack out-of-bounds write in tc entry parsing
Date: Tue, 12 Aug 2025 19:30:02 +0200
Message-ID: <20250812173002.259375033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 793009f445c0..a0e3f3bae536 100644
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



