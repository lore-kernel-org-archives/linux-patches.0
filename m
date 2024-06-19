Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA9F13D525;
	Wed, 19 Jun 2024 12:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718801983; cv=none; b=uAUYQ9gHOFplcgst/bYqURZcQ23YYmIvDGc5yQ0cQVvZLEHZn0xXvI441oJOusMx4hzt4SfvlZv7dxCtdFT3e5YqjZsIRJWHgIt4C7Fd5YwGcT2ENxkOzsmRoqK7hFKOUrcSg5C1/vsiJoxmWOSIDSHC1EuzqanuhQ9VutTvoP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718801983; c=relaxed/simple;
	bh=ZNh7mByHZ7LbLROBNezbZXroWbO5ZgalaNnGCGd6gL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPC+F9a9O4mdkNu0ZgxlIt7XcQzUtxGEOjyQURmUGLgjf4TIayOWam4rs1NJITZinalZABelWs0e+onaobjd3vj0fu4GHcqpiyEtOqTJiSfuO42UN6VftUtLfcAVElFCqFQQixuXtn0H9rZKGUDOldyMxUzmM16knrBcDCOJK/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UA0DkhHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UA0DkhHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDEBC2BBFC;
	Wed, 19 Jun 2024 12:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718801983;
	bh=ZNh7mByHZ7LbLROBNezbZXroWbO5ZgalaNnGCGd6gL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA0DkhHM/NCfsFnJY/7SvuhZ3pV9ikxYJLaqHDb7NcCISU9tkia6Hok+UO9zxO4Qa
	 rT0sKzVwj91rquInxwBjAYF0Jz2Ex1HZqC1tcZhnortDUXEtTfFsQ9B0vq0OTSMa32
	 5fqxL3LmX8/jz5M0oF2w70LGtj910l3uKt81C5tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noam Rathaus <noamr@ssd-disclosure.com>,
	Eric Dumazet <edumazet@google.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/267] net/sched: taprio: always validate TCA_TAPRIO_ATTR_PRIOMAP
Date: Wed, 19 Jun 2024 14:53:13 +0200
Message-ID: <20240619125607.982373439@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f921a58ae20852d188f70842431ce6519c4fdc36 ]

If one TCA_TAPRIO_ATTR_PRIOMAP attribute has been provided,
taprio_parse_mqprio_opt() must validate it, or userspace
can inject arbitrary data to the kernel, the second time
taprio_change() is called.

First call (with valid attributes) sets dev->num_tc
to a non zero value.

Second call (with arbitrary mqprio attributes)
returns early from taprio_parse_mqprio_opt()
and bad things can happen.

Fixes: a3d43c0d56f1 ("taprio: Add support adding an admin schedule")
Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20240604181511.769870-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_taprio.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index a315748a5e531..418d4a846d04a 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1186,16 +1186,13 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 {
 	bool allow_overlapping_txqs = TXTIME_ASSIST_IS_ENABLED(taprio_flags);
 
-	if (!qopt && !dev->num_tc) {
-		NL_SET_ERR_MSG(extack, "'mqprio' configuration is necessary");
-		return -EINVAL;
-	}
-
-	/* If num_tc is already set, it means that the user already
-	 * configured the mqprio part
-	 */
-	if (dev->num_tc)
+	if (!qopt) {
+		if (!dev->num_tc) {
+			NL_SET_ERR_MSG(extack, "'mqprio' configuration is necessary");
+			return -EINVAL;
+		}
 		return 0;
+	}
 
 	/* taprio imposes that traffic classes map 1:n to tx queues */
 	if (qopt->num_tc > dev->num_tx_queues) {
-- 
2.43.0



