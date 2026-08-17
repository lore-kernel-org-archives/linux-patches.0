Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78182EEE86;
	Mon, 17 Aug 2026 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979088; cv=none; b=GPo4zSBQ5ke1N5aSWYYwOIgtEapAHfK+1fLgYxKsWaaTvwYeRg1nmVLVilbve+EF6xetTwvmjWwiIPN/mIgCIdKRDWWOw/krJ2K5HjRFJtHCuC7376gEbpPBv/0fTliHVAJhyIo1cYfDEYp6ESafZojP8OVCFaXkMWDLiuAkxdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979088; c=relaxed/simple;
	bh=s88t/KH2sxwFL2NuAaqxr5/Hh8qXW4Uf7oZp6ePhISQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYr3UqpUycQ0MIrt5UJZLt9DLKhqHD0Rh2TcsRtitUrxYz4at7RrAYlt/Wya/HXd5oVHloPCgYig0WdQnNbZ8eQhNO8a3p+9y0EGRnlBH4ZzQK8PQI9tqOCet+pCfAbG54E9yWrs5euodMsaj96fpAzILDWcJucJ2mfryISJxAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J4ffny1G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J4ffny1G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6C71F000E9;
	Mon, 17 Aug 2026 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979087;
	bh=jqeVua5uprgCCB4TYbnZNJshjoBHvxB6cUDJa857A3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4ffny1GVGQYQWMDB8vcMmgEboDLPXdmPwcxFaw8NsTNv9R6AqRemKHit8Ne8txUK
	 IsN9H5tqvfr0Ha4uTQNg1q7uS/IztSijR4qizA3kL1tkIXpt8hNlkXIEsHsNa1kpwA
	 I4D2AcbU/ufAuhUlSJ0oDuB9dP7g/NXTqfRI4uzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/609] watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()
Date: Mon, 17 Aug 2026 15:26:39 +0200
Message-ID: <20260817132547.172963476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



