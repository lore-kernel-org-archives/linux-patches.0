Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC67A349CE2;
	Sat, 12 Sep 2026 19:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242417; cv=none; b=vGfXhLuH4jRs4wSRbwZuvqozTcygleDrMhzepw+fwcIHwyJKd8u5QHYpwXafQiYU9xfo4leQLbTOfDxrute1p6UrjpHqgXvsVbJMqjdi23F4Lnp1l4Uk3Sdu6QSiilTq9VlynPJSLTEdnv6jXRH18ABlp6m3NnI+HPp8+BQF0Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242417; c=relaxed/simple;
	bh=swT3XKSaeAmTjSd21ilmLyc3AGMxUVxhv9U9mxs+CSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qexUvKStFs52vRW2ZiefIj+BCkNeA0Fmo5y8e5+BZFFSf4lQ3c0RP+SUfx+JYt9pbXOa6s0VwAZr/PQhsHGj80DtIZhpvSMDajOS2TTMHPHQhfObeXoVSLCCFPrYcyoinpkoxvPbk/JhbcGyvf8nma9kemm2zMJXj4qcCwWlnjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUOtlm2a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUOtlm2a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217201F000FF;
	Sat, 12 Sep 2026 19:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242416;
	bh=2Wvgm8MRSVBgYufOsYRK+5E4E/3PhLDiR7/j1GETVbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUOtlm2aMdqhZBBPoRu63EAKbj4fXBo/eUjJMfM5T6q/44Eq+wF4YZA1H9WHITYDO
	 RpRi0xVb7zpd/oZbRMnUAKceTH4YPIreagqEpGz8Trcro0KwJJTCFmBcu7ZpFB73QY
	 qK6rM/hJrajErCv8+0ZRETWEmq+RnsKAeQ9JdRKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowen Tu <tuhaowen@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 379/798] PM: sleep: Fix off-by-one in wakelocks number limit check
Date: Sat, 12 Sep 2026 09:00:07 +0200
Message-ID: <20260912065525.843225381@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haowen Tu <tuhaowen@uniontech.com>

[ Upstream commit 6058646587dded0ce0ba91bd5a6afbf14fe42055 ]

CONFIG_PM_WAKELOCKS_LIMIT is documented as the maximum number of
user-space wakeup sources, but the limit check is performed before
the counter is incremented and only rejects new wakeup sources when the
current number is greater than the limit. This allows one extra wakeup
source to be created.

Reject new wakeup sources once the counter has reached the limit.

Fixes: b86ff9820fd5 ("PM / Sleep: Add user space interface for manipulating wakeup sources, v3")
Signed-off-by: Haowen Tu <tuhaowen@uniontech.com>
[ rjw: Subject edits ]
Link: https://patch.msgid.link/20260624053839.2150567-1-tuhaowen@uniontech.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/wakelock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/wakelock.c b/kernel/power/wakelock.c
index 4e941999a53ba..5c2a248cf249a 100644
--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -63,7 +63,7 @@ static unsigned int number_of_wakelocks;
 
 static inline bool wakelocks_limit_exceeded(void)
 {
-	return number_of_wakelocks > CONFIG_PM_WAKELOCKS_LIMIT;
+	return number_of_wakelocks >= CONFIG_PM_WAKELOCKS_LIMIT;
 }
 
 static inline void increment_wakelocks_number(void)
-- 
2.53.0



