Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80300435AB0;
	Thu, 30 Jul 2026 14:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421764; cv=none; b=b1R3r+0/q1n1SrKFcssJIX3hkJEC7RfmTzjQx5UMpNghurLX2AUEU5ocEIAtGn/754Hxaouzo3RmwJg/UrEf+XN4hgKIXWTAOc/HUv+dOccTKJsgWAJVc3lqAhJurONlLeJKNT0AftLx10pSlQ9auxBIA7p5uwX0zFDQ3bRZYTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421764; c=relaxed/simple;
	bh=0JKF9PpR3k3oQW7/IE9vh4JOehb64u8f3j9OfwssKa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBifXdeQTBmYKD4sh1dnNfWBoBHbmV4zOr6uCiHm2fh44Q5HyPw/RHfQ4YMelN/gTbPkuSHHrHRInAAcmP+ZZ9u10/8+FTmEOquBohzVt6RWdNjxh9xBopgBJHNNXkJZz9o6nZvYd+tUiUcAmmbIq02A0DERODQw6ROsMmSgoV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajBESriP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajBESriP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0BC1F000E9;
	Thu, 30 Jul 2026 14:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421763;
	bh=+hfogXW0rauS0pCr1gLrscOE6h4fnSSB/Nk6Yk0ocBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajBESriP/n/VK+W8m4GEWbfU+Sao5qOGVNgd+7JkLWuDcL2TcaIOyWRctBRPPpKG0
	 lqou8tlIOdwNwiuknUmyEZCm76lTgMiBIllF8J1SZS8oNJ1mJs8osLlkErpbSpaeCn
	 CJdC0RcxaHdoViwOxcx8fCJF2G5/YdQioyZEc9lI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 176/744] watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()
Date: Thu, 30 Jul 2026 16:07:29 +0200
Message-ID: <20260730141448.028537028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 19eb2ed2c7cb0e..02e09b9e396dab 100644
--- a/drivers/watchdog/watchdog_pretimeout.c
+++ b/drivers/watchdog/watchdog_pretimeout.c
@@ -167,6 +167,8 @@ void watchdog_unregister_governor(struct watchdog_governor *gov)
 	}
 
 	spin_lock_irq(&pretimeout_lock);
+	if (default_gov == gov)
+		default_gov = NULL;
 	list_for_each_entry(p, &pretimeout_list, entry)
 		if (p->wdd->gov == gov)
 			p->wdd->gov = default_gov;
-- 
2.53.0



