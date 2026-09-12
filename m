Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CAF352022;
	Sat, 12 Sep 2026 16:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231852; cv=none; b=tPh+vXeFVcNZZd4X+ZVPjYFOetxI3C8fAJpatspxFyl4MHg6ss87zBYReS1gZvvNOgaZqMhPaAUcSWNa+YjeIJgQil843g7tuDOUWxrTDG7V/If+YBlkEhgkL41XP5bChGjnC37llO8CqCaJ7NVE/cV2DWixLhreB2GgRA0rcrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231852; c=relaxed/simple;
	bh=ahKyrcGqx2ntx0AXXma7v7YKDeBqOhuMJ0gJ/M3NO8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+AOdyRHr/VHHWs/EDh19AWZdJLoMXVFN5dpQWBbCnQnKM9GAb+DE3hHcylsLeAjnq6zEeWKWUHPJfNDr9ZJOmzom84qZuGtcpyrWgV9dyPafnYu3/jmcPQiBkULPbKj0yKfwNYWSsKM28roaKCA+3j/GBEpJN4tXa4YasdrzD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4gUSTU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4gUSTU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7941F00893;
	Sat, 12 Sep 2026 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231851;
	bh=7yz/TOpk/Gkpdxlbfj9U6pRCJbXE41Ok/Tg2OSdtebo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4gUSTU51+UX//FrEmec48IqY3RKF7rqmaM8twuHCXIzjKQKKgoJjtQE4bgwBdDkd
	 HvC/0OCbFJ/fo6I3fgzSQJGbng1Cdv/btnIHQx+dSTTxCLHUQvMf50hvJo6ZCVheB9
	 mAZq1JCHxQh8sM0oKRFV4bQ1sQNnJToO16609HdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1083/1191] net: ipa: balance runtime PM reference on remove error
Date: Sat, 12 Sep 2026 09:03:31 +0200
Message-ID: <20260912065612.489962678@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 6b9eaa61ff2df63c6eb35d5cd025e2cef0861d76 ]

ipa_remove() takes a runtime PM reference before accessing IPA hardware
during teardown. If a concurrent modem start or stop keeps
ipa_modem_stop() busy across both attempts, the callback intentionally
returns without releasing the remaining resources because proceeding
with teardown could crash. That return also skips the matching
pm_runtime_put_noidle(), leaving the callback's usage-count reference
held.

Drop only this runtime PM reference before returning.
pm_runtime_put_noidle() does not request an idle transition, so the
hardware and resources retained on this exceptional path remain
untouched while the usage count stays balanced.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 923a6b698447 ("net: ipa: get clock in ipa_probe()")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Alex Elder <elder@riscstar.com>
Link: https://patch.msgid.link/20260815151737.3758320-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 5e2d1961ea604..ce10159455a33 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -879,12 +879,12 @@ static void ipa_remove(struct platform_device *pdev)
 		}
 		if (ret) {
 			/*
-			 * Not cleaning up here properly might also yield a
-			 * crash later on. As the device is still unregistered
-			 * in this case, this might even yield a crash later on.
+			 * Continuing teardown after failing to stop the modem
+			 * could crash, so leave the remaining resources allocated.
 			 */
 			dev_err(dev, "Failed to stop modem (%pe), leaking resources\n",
 				ERR_PTR(ret));
+			pm_runtime_put_noidle(dev);
 			return;
 		}
 
-- 
2.53.0



