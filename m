Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EA51D7E5C;
	Sat, 12 Sep 2026 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226086; cv=none; b=Lj4B72u1gelVEj32GiQB/256Y9IYG4WjevllRdco/7PtoLdmswkutlV891NQBG1L5T7MpUU38R4e4WTWTlIYlqM8C69eV0bdlWoyQGhXbxnIvHWwwJ4ip64iTJyzrz+k3qJk1Gr9M5lrOkpbY9u6r8Oi9Dd+X5VY5Ym0WlDq+p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226086; c=relaxed/simple;
	bh=D+Wl4mwZSTwo5qF4LiNMXF5RNvhSTwxXYWl/e0ZnqUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPTCTUcGpghO9F6g2fg1vvIxdhUUBpNlIrFY/mPQj8wgyRYg+zyp8ZvrJqSOJQiheSLp9mDpNMK622NE18x/3/VYhwFOjUW3R7cAhOia5sY/vVB9ii5lQpThFTa19TG75wEXvB1pSBQ65U7KlSWQ6X8WaG9/n7hXRt0aIWVSFAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sGYRrOky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sGYRrOky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C801F000FF;
	Sat, 12 Sep 2026 15:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226085;
	bh=KN4UUDXp0NOi4aUtH4753KEWMS40iUoZfmiN6hAxplo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGYRrOkyTJlDIWraJv48brvf19JPPCPB2E/5cR97L3OE0i17BN7jX/P313Szy5LiD
	 SY0i0PkRoTJkhxlVj+hQbLC55zabkWT2xNgLrniyUdFpi95imqSiptN/lkWW/HAc2a
	 /EL0uwL/BoyZOpcvlHm66jpl5H2fP4GrdcRb2aI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Alex Elder <elder@riscstar.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1331/1424] net: ipa: balance runtime PM reference on remove error
Date: Sat, 12 Sep 2026 09:02:43 +0200
Message-ID: <20260912065637.065100007@linuxfoundation.org>
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
index 196755bf60f87..fe569c8c14af8 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -961,12 +961,12 @@ static void ipa_remove(struct platform_device *pdev)
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



