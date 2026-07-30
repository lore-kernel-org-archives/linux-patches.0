Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA7E42F707;
	Thu, 30 Jul 2026 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423914; cv=none; b=AgxPlI3X8kzq2dhHhlmbC3UJb5eYIJ+/kwwlI3YvF4wzYDEx7K4dk9yvBTt+ttyWvUFZ3q4ZHiq6z41CKXcPQrE/2r+mNJq9l/Gs9OD+UM4CbwdEyRwk6eRRZ9HoPO9c8S6XgMRXfxS6ah7F44azhXgQ953bidcvg8gpy59P9Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423914; c=relaxed/simple;
	bh=atimfeOvcUMUdjJqaE6ZdQaoS1XowooAprCsPz+NJ/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRYA7FgtrcxC2NX4VVE7uX0ZlsA7kFOP3qZNvqwyLNLW5dRlHigFxOfCPTllPs8YE+0HZ05jZaIxkQcggARkfGSNfA/G5yb8S+qQbnGmPTfHv/3kV2UzkSAO5DkCdRWEBmWdSEhhJ6Mn7fT5sB9mThUj57YOe5VtAzFO/HbQB0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCov9ON2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCov9ON2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A251F000E9;
	Thu, 30 Jul 2026 15:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423913;
	bh=bTbBEqTS0yu3OP75LxdzF993DMgJENFtACK/2HaJr4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCov9ON2xd0kk6t/C9KinQHCvzXOugAK6PLmRJZU/27BFBnqtgKjeChlLD/q6lMC7
	 oM/Bjr7bTwT6fE0ClRd4vgIuhUBGaRrMme4XlNplKBiPPbTXRcRQtwhT1YLuPWh5Iq
	 9nX7EyXoLaEh2SKHjYxP4LkXxt5MJP4Wc7zF49Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/675] watchdog: pretimeout: Fix UAF in watchdog_unregister_governor()
Date: Thu, 30 Jul 2026 16:08:23 +0200
Message-ID: <20260730141448.815112742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 2526436dc74dd8..ea05f84f07e184 100644
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



