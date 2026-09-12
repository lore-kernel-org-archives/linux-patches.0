Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4749E1D514E;
	Sat, 12 Sep 2026 09:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206485; cv=none; b=j6CsIiyX0JLN1n+0MYa8shlRhcUN/PInn/NSmHG6WwJG+fX535U3vOeLB3uw4MbZGlmdvZ/73EDnurF3l5Zl5L1+ovtyQ0Wzx8rQr2eczHeprzR6LLLmlTh0Lf3inT/X9pDHzCKF93K8nRryKVOAspt2akSPs60rAA+5XA1MZ4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206485; c=relaxed/simple;
	bh=p+2YCxE1DalYyImy7PcRCzUQALMhiBvXOZ47Dhp0vcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hf6nET8rn2NiJi7mdiLmmIgZfQI5qxOevjDz2Pm4UCDpUJIAygz9zTIRpGdFXZX9eNSi2fZYXgrcBKRGztHlobpK6hdnxXKaF/p0aidJMV1FCxo4CzBx8AQfRnuMjS8xjgeIY6JLY3Ru+E8HNu+VleKEzLmARQTkZT64T1rhiQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmXTkkSD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmXTkkSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105141F000FF;
	Sat, 12 Sep 2026 09:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206484;
	bh=zF5uY0FrBVBIR4B7B+BA0b4NcouM8sI/U3JtNCWGiTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cmXTkkSDKDwRPr9lXWafiCwimHOzLfQOuo5kfnW0TdjO7laXjLbrS1QieZR6Ng6f1
	 FdKc7izB5uGljRkdu9e4YMGcmSXQnl0imN8YVGEY57PjS+SJyR7nEpqSkOwvkSUJpl
	 6/PThjyjVrY42zKvQkPCt64mRRx/QLTiv3hFyiBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowen Tu <tuhaowen@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0216/1518] PM: sleep: Fix off-by-one in wakelocks number limit check
Date: Sat, 12 Sep 2026 08:39:45 +0200
Message-ID: <20260912065628.376645430@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



