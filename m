Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A044C74;
	Mon, 23 Jun 2025 22:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716127; cv=none; b=Jjq38HcqQdll829gBPEXPq6YHSUgamDZB4QmWCZ7AlHZlmFGfn4S9MqTUesARMOegf5irfUiPLIKfi9qWScM9g1x7B3eCd0iec2jCr8XhsdpgpeUdBuUoJCsLYWVybJRm5AnM0JUopkquvqdTB+Hb73oiSSJtdAKaDAjfMMFd8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716127; c=relaxed/simple;
	bh=wLyWm/I/qQHUpp3eElQTLgbMdnUQg+Fv/gTHcVEQj0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qei7lIlBNgUkz0ghWntoSV8HN9jDqj1eduTl02v40xIvqvrOMyXJnYz6rBtkfYhPLS2z/blOcAn5nsKOqZzFkP6riyLl3kNyv5PtZOVfr0TaG/E2NUFk2h8EiNZx6dvdfy8vf3S5STwkBvYsxLYWWXtY80+l6+BsEmX+oFb8yVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ajpk5IzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ajpk5IzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E15C4CEEA;
	Mon, 23 Jun 2025 22:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716127;
	bh=wLyWm/I/qQHUpp3eElQTLgbMdnUQg+Fv/gTHcVEQj0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ajpk5IzZqOnE0/fo+Z/vzD/Yf7MPCPwtQctqASTe4sK2GNqx8789BKGIIC3BnUGbX
	 /M+5qpXlToXcsztKEYpnuKvOW3h9GGzOZSmehmhcu755FtEhG/mJzWXcOCqOu9lkuj
	 sBYiuw0fUB9D2AwEjRYvCc9nUajPd1GSMrRWS+8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 304/411] cpufreq: Force sync policy boost with global boost on sysfs update
Date: Mon, 23 Jun 2025 15:07:28 +0200
Message-ID: <20250623130641.298210330@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 121baab7b88ed865532dadb7ef1aee6e2bea86f5 ]

If the global boost flag is enabled and policy boost flag is disabled, a
call to `cpufreq_boost_trigger_state(true)` must enable the policy's
boost state.

The current code misses that because of an optimization. Fix it.

Suggested-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/852ff11c589e6300730d207baac195b2d9d8b95f.1745511526.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 2c98ddf2c8db1..bbb0cbb2eb8c2 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2698,8 +2698,10 @@ int cpufreq_boost_trigger_state(int state)
 	unsigned long flags;
 	int ret = 0;
 
-	if (cpufreq_driver->boost_enabled == state)
-		return 0;
+	/*
+	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
+	 * make sure all policies are in sync with global boost flag.
+	 */
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver->boost_enabled = state;
-- 
2.39.5



