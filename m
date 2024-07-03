Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8047C13D61B;
	Wed,  3 Jul 2024 10:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003755; cv=none; b=qjpfm22HAIuxQKmW4nQD6PRMn1zrTG5qIEBdu3LKPCONoBmLyCVHigGttxKeWmOsDFR/cQlWSdGfMjQsujjpDthgj2U1y88asxRGuuB0G1FyapdBqjA8RfBrSoxj8lZ+Z4GFr6Z9Bh8XZBYoau7SlN9L0uUdD3FckqAMb55hUMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003755; c=relaxed/simple;
	bh=OB8ltOrF2bGfiVz7A5tXhfR8/mlnf6sb9U9w2IzQcgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9jAa9rGb9p7/7L66tt77pNl4wx0IRg6oQJyiH2ysnkMRGjzRFMLSJS/EpcF0N+pxIlE5gfS2Ki0+2/hCIB6J9GObqGPzBiRc5eYJl6jDsI/unDK2IoudBvX0Eyq1gX+u54rOiMC12QnyV4Sr9z7CcM6GzB2p2lQ7hqj+j8iF6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmH3J0km; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmH3J0km"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B484C32781;
	Wed,  3 Jul 2024 10:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003755;
	bh=OB8ltOrF2bGfiVz7A5tXhfR8/mlnf6sb9U9w2IzQcgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmH3J0kmfDrdqWXv5Mi7rosnVPloa01mVaOR+91Td9srxMByLMcnJocDYoP/MzUjm
	 JAR1eoHw/sH9idGh27WufARyt84ihqnrZgCvObT5ovEBe4arcqd42tZlg9e2mUXz0x
	 y54JkaFqOPLJNcjvzivJiFQJJzQwzlB/CO52kbIY=
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
Subject: [PATCH 5.4 012/189] net/sched: taprio: always validate TCA_TAPRIO_ATTR_PRIOMAP
Date: Wed,  3 Jul 2024 12:37:53 +0200
Message-ID: <20240703102841.966388192@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e4c4d23a1b535..7b896be009d55 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -925,16 +925,13 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
 {
 	int i, j;
 
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
 
 	/* Verify num_tc is not out of max range */
 	if (qopt->num_tc > TC_MAX_QUEUE) {
-- 
2.43.0



