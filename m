Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18FB4D9EA;
	Wed, 19 Jun 2024 13:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803565; cv=none; b=FUeMpCHU74u06VD/49R/mUsDWOFBdS5SwF2VKJ2178YYhjVrEVtqXZgL1xeiuhnuQHSrkMkdU7HNimM+oqCVKnew9um0MM9L93SAW0CQMEIjdMNGCgIvDyAosSS5b5UCET5EMFFqbRFBnlSfEm/kzU5mo/K0in+hdOyrtku9fFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803565; c=relaxed/simple;
	bh=CuCLLSPvRWv4fYuVUsaQddek3NIBF7iY4nFcG83/dC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6LqiD89vDuasB/4hZMgrIKHP25rCFwT6N/5bUliLUSAMz2a9n//mKWpbji7+RMo5j/zsf/Xf20NIAXuLrAGl92xS6JtStH2gSxSCvOfZkJ570L5QSwbGVLlSQAaCKY0v/vC6SCirABlBpwugHRZOox5PLOuqNAp9+NhoCF6C0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seDjKPH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seDjKPH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5845CC2BBFC;
	Wed, 19 Jun 2024 13:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803565;
	bh=CuCLLSPvRWv4fYuVUsaQddek3NIBF7iY4nFcG83/dC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seDjKPH+t1RWr68GSSVelZSwOatM6RZRqTe9gtUSDdX0+GXcbHvHsgy6Sk8oT3YBq
	 u+wXotGAf4Kwab4zqoTcxaw80uorlBgQzL1shXV4spc3IjhuQocJLRJKSUDk23a2yw
	 Zw3LEiVGxMT17YtcCV/H9K6yedCt/MRatYbfL58I=
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
Subject: [PATCH 6.1 028/217] net/sched: taprio: always validate TCA_TAPRIO_ATTR_PRIOMAP
Date: Wed, 19 Jun 2024 14:54:31 +0200
Message-ID: <20240619125557.735156688@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1d4638aa4254f..41187bbd25ee9 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -938,16 +938,13 @@ static int taprio_parse_mqprio_opt(struct net_device *dev,
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



