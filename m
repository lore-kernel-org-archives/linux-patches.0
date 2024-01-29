Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717D87375F;
	Mon, 29 Jan 2024 17:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548551; cv=none; b=ahj/ULQg/Ubvuwe9iLMkRBmzdj37sGqqERp5iUGjUxsHOPG2sl2y74YxJxsCywg3Gjqa2jZdqvOR2Ot7FlPHmV67s4nJkpe5CkDjM/F0AQjzxjm8BByoV67/JzOYkIqBqp56QZhXRjdSA97wVbTB+ZJhMQIysnpgIF/WltMTR5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548551; c=relaxed/simple;
	bh=yqK/5eH6klddMnko0IUGRKQTJoV/p0oI6V5IjLJpNaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZOgU2EN+M4rMtV+LlDvYf5shhrNK/9+7wo2b8NKc+1Y+H3wgxwaFprg5tnKQ+SHMEVNk3qKjBSCoYtPtPPZ4Eor6DNFN0ZCrdTMSFhmGne5k1YIRLfTUZqmdwV7ui2y3VsvyhCRJmeHxmAGzsFfwlwK3ewZCAJtzB6N/7KX3Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTN8sqh0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTN8sqh0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C55DC433F1;
	Mon, 29 Jan 2024 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548551;
	bh=yqK/5eH6klddMnko0IUGRKQTJoV/p0oI6V5IjLJpNaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTN8sqh0Vie1wd5V8kDf+AUtxtaccWZKzGMCuikHL3f0LzXkZxdfDO8ULyIDFAkcV
	 0yz6WU166qva46ykjtax8qrl31lSq5c/w8//i8wUcboRA1pqUbhAaaDQaOPMq2t3Ql
	 T7okmU2Gd6ofYP4ckz/kS0RuYPeZMLCjOZH8CVeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/331] selftests: bonding: Increase timeout to 1200s
Date: Mon, 29 Jan 2024 09:03:54 -0800
Message-ID: <20240129170019.889525256@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit b01f15a7571b7aa222458bc9bf26ab59bd84e384 ]

When tests are run by runner.sh, bond_options.sh gets killed before
it can complete:

make -C tools/testing/selftests run_tests TARGETS="drivers/net/bonding"
	[...]
	# timeout set to 120
	# selftests: drivers/net/bonding: bond_options.sh
	# TEST: prio (active-backup miimon primary_reselect 0)                [ OK ]
	# TEST: prio (active-backup miimon primary_reselect 1)                [ OK ]
	# TEST: prio (active-backup miimon primary_reselect 2)                [ OK ]
	# TEST: prio (active-backup arp_ip_target primary_reselect 0)         [ OK ]
	# TEST: prio (active-backup arp_ip_target primary_reselect 1)         [ OK ]
	# TEST: prio (active-backup arp_ip_target primary_reselect 2)         [ OK ]
	#
	not ok 7 selftests: drivers/net/bonding: bond_options.sh # TIMEOUT 120 seconds

This test includes many sleep statements, at least some of which are
related to timers in the operation of the bonding driver itself. Increase
the test timeout to allow the test to complete.

I ran the test in slightly different VMs (including one without HW
virtualization support) and got runtimes of 13m39.760s, 13m31.238s, and
13m2.956s. Use a ~1.5x "safety factor" and set the timeout to 1200s.

Fixes: 42a8d4aaea84 ("selftests: bonding: add bonding prio option test")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20240116104402.1203850a@kernel.org/#t
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://lore.kernel.org/r/20240118001233.304759-1-bpoirier@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/bonding/settings | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/bonding/settings b/tools/testing/selftests/drivers/net/bonding/settings
index 6091b45d226b..79b65bdf05db 100644
--- a/tools/testing/selftests/drivers/net/bonding/settings
+++ b/tools/testing/selftests/drivers/net/bonding/settings
@@ -1 +1 @@
-timeout=120
+timeout=1200
-- 
2.43.0



