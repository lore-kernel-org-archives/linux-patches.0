Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1A230DEA3;
	Sat, 12 Sep 2026 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222759; cv=none; b=mnLsbdWXdcIPhAGJt4JXU+2r6/xvq/13FvCBqO06xfVFjzuEkcJTL+lHA/vUNvC6+0yjgNakWs6wuTuBjuTLpGLcn+4UKa0vvlQVXJgp5mWjF1y7yYsI0J5+0f6JqT602LIMxJHSlakqGgObuGItxevnOc60zC0XkQ79pfFQtoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222759; c=relaxed/simple;
	bh=PEuv6uQdvZyw3xICfH0uILvjlRoQkIM4cVmqVrGyiV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hq3njVnF5d3vjC3tzZ0UhlFCMuUdxUTQeNwJ3n9cq0aGUmW83qQMm+KOfzFzUuG0Zkeac83iH/cVSudhHEd4/r7e23nnTdiptnPS6Gg5Ua6Pc0ByERsHCiWNexyw+aJFwdRB8EyMZi6YVxMsFPKMC3FDjdHIn/MK3G/VYzNszjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8yknww/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8yknww/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEF81F000FF;
	Sat, 12 Sep 2026 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222758;
	bh=GpOKccHcVbUOE3lLqRVGjSnrfp17JCAQJtriEiCR7lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8yknww/0Kefjly6BmELb+vXD1ZuHn1ELx6WLhV1VrbHDActduGCPV1tELD8HgZJN
	 xftWRCe/9hdTXPEBFGGbbBwgIb2nKyKoYj0wL+7KlT04ID/VDN9MegvjMaQGaa513L
	 Sc5JKz24fJMJsznUXKlK67HT0+BodpC+HS4w2nWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haowen Tu <tuhaowen@uniontech.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0651/1424] PM: sleep: Fix off-by-one in wakelocks number limit check
Date: Sat, 12 Sep 2026 08:51:23 +0200
Message-ID: <20260912065621.869298874@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



