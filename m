Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8813E3C661A;
	Mon, 17 Aug 2026 14:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976721; cv=none; b=lYQ20Qmj0EUwb17S3s985Tx2KFd3AC1FyjJhbLpYjc3y2N6rGEuFzQ+Wqn5FD72Gfgr5NaBA8n/4dlO6GOUeFCDvGlNpTsrtLmsnT0TkIidk2I3nDpT+oZ1ImJLj9N1Um09R7/NofaQK10PJrosfWBi4W4rS1QMDoQmTdYYatEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976721; c=relaxed/simple;
	bh=mGZ6KjTBOhjtWsgNJBpsTaHc4yfL88+bYqhaVLHSd2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1thuSSYE2mwIRAuyu1iM+6U3Ipz+UrETEcrhVP1MRAU0afR+3QZmej8TXnW9b8oZr1SJU5vgkvobsNSveXlniP9wA1bnVNdbiakcx4GWJ3kxUQD5e5tPgiAUTmtr3Yu2KJbc7UsJSGb3OKi8VHJhWqTMePQY3YuxjSfZyAkepU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPtWrkvM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPtWrkvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83AC1F000E9;
	Mon, 17 Aug 2026 14:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976720;
	bh=jP7WUCiQasRH5kqkm8sZLogFHIJiFAuY8gq3Ax+/iZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rPtWrkvMTCQA/kYPIoMt6ZlF/vg9P3lr4yCFc5YO1oQg3gQM+FsZemnbrBjAcf8Hh
	 OUwqfY5Pjq6uayggWscAAyWXD5tz4XMwBnjQxp6Y1fzdsIaHSuWkB1p/cHp7ynQ/DF
	 8RHkrU+BYNQcdmVHC626NAniHdB/e0vd54tAIsbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 081/456] watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()
Date: Mon, 17 Aug 2026 15:27:51 +0200
Message-ID: <20260817132543.275226026@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 7362ba0f9c96ac3ad6a2ca3995bd9fc9a28a8661 ]

When a watchdog governor is unregistered, it updates existing watchdog
devices that were using this governor by falling back to `default_gov`.

If the governor being unregistered is currently set as `default_gov`,
the `default_gov` is never cleared.  This leads to 2 use-after-free
issues:
1. New watchdog devices registered after this point will inherit the
   dangling `default_gov`.
2. Existing watchdog devices using the unregistered governor will have
   their `wdd->gov` reassigned to the dangling `default_gov`.

Fix the UAF by clearing `default_gov` if it matches the governor being
unregistered.

Fixes: da0d12ff2b82 ("watchdog: pretimeout: add panic pretimeout governor")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://lore.kernel.org/r/20260707101803.3598173-1-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_pretimeout.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/watchdog_pretimeout.c b/drivers/watchdog/watchdog_pretimeout.c
index 376a495ab80c49..3c109f1db8f0e5 100644
--- a/drivers/watchdog/watchdog_pretimeout.c
+++ b/drivers/watchdog/watchdog_pretimeout.c
@@ -165,6 +165,8 @@ void watchdog_unregister_governor(struct watchdog_governor *gov)
 	}
 
 	spin_lock_irq(&pretimeout_lock);
+	if (default_gov == gov)
+		default_gov = NULL;
 	list_for_each_entry(p, &pretimeout_list, entry)
 		if (p->wdd->gov == gov)
 			p->wdd->gov = default_gov;
-- 
2.53.0



