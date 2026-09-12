Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53782479880;
	Sat, 12 Sep 2026 12:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214868; cv=none; b=EkDlN90BUAaV951WHu6EUlFJtkPn27NczQXuRfwXctxLAu7sz3vPrmltiLXO49UrH2gMmQ0KHkhUNvK2XKJJFAXVEa6pEBjYuBPEjieQxt1L1OwNFHPQAdHEl+EXwoAhAyce2PN4jvBMei3aU7Hal/q/ZLp9KWUqNSflGXOlYcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214868; c=relaxed/simple;
	bh=ZmT2ln9uhqSFSMwZTEjUTemcRDA5FE3MWbTWfA3ZSNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6PDcxb5ddEhfsmwbhSqi1DB0kyhr5oKq9vT8S0UHA4eRIqFLK8ZrvEnPzpdqwbUYcNBQx6urk4r2FxHN4W+OMoluIt+Kf7u3PlVgcJYIR/9oRPhiojZv37kue5fDRPu1klt8qNyGRYFBRwfxTE2W1jrwkn6/4JFZ7Msf5DFxcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cocESswF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cocESswF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A761F000FF;
	Sat, 12 Sep 2026 12:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214867;
	bh=oxKfnQCO0br+sgaY8KMPGAmjhgRKu0b47N+n14y6DJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cocESswFn1vGkjKpLrn3K9pLSHwzxghIDwHdu2fsZ+qrlPj7dZSMCxr4/tKwvDnO5
	 yrk34D43U6ZzdSynnMD9ziqHL83QeiC2xnHJUBu8yiLci46Ho0IW/tOJPEfc0/7AI0
	 MzJPJ12L/i5WMzaTGf4mmj8ZDCJihxMjdZ8avyho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowen Tu <tuhaowen@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0413/1376] PM: sleep: Fix off-by-one in wakelocks number limit check
Date: Sat, 12 Sep 2026 08:47:19 +0200
Message-ID: <20260912065616.747450130@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



