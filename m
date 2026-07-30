Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED4543C04B;
	Thu, 30 Jul 2026 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427299; cv=none; b=ob00l7dus/rNePV7Xmyjc5piSVmn8cesmubGlnooX7958/mfyGM1DXbxyHNbXYjH2AK+Vnt/nU8sw01YiD/maFNJmVzk660k94vmvAvVCsZnkjv+IrWpCGhbsnelsDuj7LLrqJGk3S/Q8vQn4HqEF+Th45/HEQC23P4r1RhECXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427299; c=relaxed/simple;
	bh=9seTzeZMZo3V/HUTwHNnRhcOFzAAS/ey6ZjeaD8rp40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Juex+yb1FLzhSO2oj1+N4zzJrM9XaQX50y6j1jTudxQsg6fHPrfPjKWpcdS7XGQHYxdiyFS5gxt0T60ebRwcG5zen/9jK+rjPOb6VAClOAnPlZc5W7DI7iwD89MWxzVG6X4WP2lHwtyaZqhabLZ9BxNIYKPf5T07LCTUI12ktv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBP3omF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBP3omF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566D31F000E9;
	Thu, 30 Jul 2026 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427297;
	bh=gPNu/sUVUkfCL4homCbRguMRn8KGl5xOrWl7U64tTh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBP3omF39aN6ILxqS9WKTNEbAIe1Eg9s5TY6aPKVAu1Xr/Af/Z4k9WoMSXWREvatX
	 JytDy14xiz8ZR0r3Ltux4swmj7uoD0QD158W50wEeia8VqSRhYCMl+RsraxI0zkIA1
	 yxwLsPh45w3TCxYFEuW44rwkrNq/DyCKsJzSPVE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/484] watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()
Date: Thu, 30 Jul 2026 16:10:17 +0200
Message-ID: <20260730141426.066582788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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



