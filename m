Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3180123D2A2;
	Mon,  2 Jun 2025 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873588; cv=none; b=uKHvakmAAQaYR5lSvzzvuI7C7WkWP/qRMfw2IcidYOhqhjRPGb04p9L1LiXbQsPKxw38V8SylgBKhPQPh2PkP1KJ83Vcu35momEEhRAC3RfOwnTGcqDMQI6bo3YBYdOzS5obYX0dqu+T/CT+D1L1cqR8hTQ0SCSNBvsu4x8UYxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873588; c=relaxed/simple;
	bh=dVnL2y7HSfcThgRryTGfGldnCiLhK701ZDQGbpn3YkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lth/D1+whY//DTluiVclsid0DZMWyZqvdmKjSYR7OSAmsWicORM2r5aVYM96d4yoMOajwpfMtkcZIjfQSOVVrQNyffooVs/MCnq9kY1Ey6UbRXn/7Vq58lKZgZaw2+N0pKJdm9EsSSXpk7Fu35ARXE624PUC8WnWoFB46cUo37c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+wOOuod; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+wOOuod"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2AB0C4CEEB;
	Mon,  2 Jun 2025 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873588;
	bh=dVnL2y7HSfcThgRryTGfGldnCiLhK701ZDQGbpn3YkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+wOOuoddf11EEsRatMUJpzjcfESbP+fUiu92FJql3vvcKNK/8/ilkH+04Jh8kvkF
	 N4UoIG7Z+kRgRvTP0O+N7jhiYCHjL66biyxtAxPJM5CrSIIZ9cw3yEk1LupDQJLPqJ
	 Nvi41eIeWshvPGHcc0G61pCYUtPeuVc8+2j+CVl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 189/444] cpuidle: menu: Avoid discarding useful information
Date: Mon,  2 Jun 2025 15:44:13 +0200
Message-ID: <20250602134348.575159327@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 85975daeaa4d6ec560bfcd354fc9c08ad7f38888 ]

When giving up on making a high-confidence prediction,
get_typical_interval() always returns UINT_MAX which means that the
next idle interval prediction will be based entirely on the time till
the next timer.  However, the information represented by the most
recent intervals may not be completely useless in those cases.

Namely, the largest recent idle interval is an upper bound on the
recently observed idle duration, so it is reasonable to assume that
the next idle duration is unlikely to exceed it.  Moreover, this is
still true after eliminating the suspected outliers if the sample
set still under consideration is at least as large as 50% of the
maximum sample set size.

Accordingly, make get_typical_interval() return the current maximum
recent interval value in that case instead of UINT_MAX.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Tested-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Christian Loehle <christian.loehle@arm.com>
Tested-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Link: https://patch.msgid.link/7770672.EvYhyI6sBW@rjwysocki.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index b96e3da0fedd0..edd9a8fb9878d 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -246,8 +246,19 @@ static unsigned int get_typical_interval(struct menu_device *data)
 	 * This can deal with workloads that have long pauses interspersed
 	 * with sporadic activity with a bunch of short pauses.
 	 */
-	if ((divisor * 4) <= INTERVALS * 3)
+	if (divisor * 4 <= INTERVALS * 3) {
+		/*
+		 * If there are sufficiently many data points still under
+		 * consideration after the outliers have been eliminated,
+		 * returning without a prediction would be a mistake because it
+		 * is likely that the next interval will not exceed the current
+		 * maximum, so return the latter in that case.
+		 */
+		if (divisor >= INTERVALS / 2)
+			return max;
+
 		return UINT_MAX;
+	}
 
 	thresh = max - 1;
 	goto again;
-- 
2.39.5



