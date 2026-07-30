Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38400436BF8;
	Thu, 30 Jul 2026 15:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425750; cv=none; b=a8cufENEmKciJOCIxOcXhvRzevLr1GLzI9YBGjhwje8/WJYpQvV0jzQqGig3dnXhU/FQsC88rTZpMlVk9YTo6uVoZV8B16P8BeFP7tYjMxhBAfXSOGK9ew3jFaRQ//ziOEXrDC7rMnughC6RYdub+gqECT6QYOE1wshB/AWpcAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425750; c=relaxed/simple;
	bh=MbU7O4Jmwuhq9L/+5CEPQXhNTESuofJ82rX4JpR88oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ad1M2+uLlbIugNzP7112MENE6+Nn3JcNHiMSgpMyW1cRMldXSjBwAihVHZ2U3J3pCkQ6Eaj9Eb4hhy3ei+zyOF9s07KNqa2IYamzUGwMzzxF4yu/oll3E4DtddEHTI3P/g3PafoiPl8b1EuxVp0d8rLrYw9fwGoapZxcHINgPb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAXdgEzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAXdgEzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CB8B1F000E9;
	Thu, 30 Jul 2026 15:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425749;
	bh=21yHSuYEZSRqjXf9o3KpA1Gs8puStuI5KZPXte6NIP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAXdgEzXQBVy2v/gIWELh2MuSZQqWpfPpw1HtDoX1pJTNkfoLrLVyZS7oASpCDemP
	 NZoWG4UiDbQ5peQDrGnnlmsCiqW5vCQQiJix/2UWTG+mSLnoRdd/7C3H48o6NZHQOk
	 YwmWWEnsKQqUllSXxllcRy73n+lFTIzEbueyvjYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/602] watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()
Date: Thu, 30 Jul 2026 16:08:53 +0200
Message-ID: <20260730141438.942833745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index e5295c990fa1b8..787b6227b8ccc3 100644
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



