Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D72234FF44;
	Tue, 16 Dec 2025 11:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886169; cv=none; b=KaYOmYPy+L/8GB+ZxbREhiT39D/89ys0Fw0KP2J80rb4nDOTHLy7rXJyVFvdZxDKjtdfKugisCcNqnVcBSEjKZRvjoh3IFjwp4ROOKH9OVwBxXkMHdi87t2jTMMJtsZRLz0a1wQmur93HeH6XRf5k/H7RAS7ZR8J7NxTGxWIxG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886169; c=relaxed/simple;
	bh=sW8GVmnk0eXRchEV0EkOxg+cmW1oqZDhqXJ/OQyOMhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmZTNU5wtpLuMuqDvSwB/mvgEXCyaFN5sx7w7lFEc2tmBM+xQiDtJIFSVSevjlqATPjK7I23By314AHeeNe1uzo4qUFsJB91MMP/cVFGWH3e2etnoXWYY2XWKaH9XyBDw37PY5h+fM0h/fqA6n544pY+UXd8WPvsgc/J6uQD9a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9blAew0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9blAew0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED74C4CEF1;
	Tue, 16 Dec 2025 11:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886169;
	bh=sW8GVmnk0eXRchEV0EkOxg+cmW1oqZDhqXJ/OQyOMhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V9blAew0Q/4egVr+2pyqThr/93UUlpMZmeg42Z3jpLd5AMXlCBsUGQnzGAPjqR1i+
	 SbshDg/zs129AlkDwwKhVMjqLkFPXNIAxa9MESvEdvX9eAUw29ez/ZWQ9ZoHpASINh
	 N+52fQci0+VGM1xRGd7cTQmeFh3nQ2CowkXtH/Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 359/507] clocksource/drivers/nxp-stm: Prevent driver unbind
Date: Tue, 16 Dec 2025 12:13:20 +0100
Message-ID: <20251216111358.463864488@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 6a2416892e8942f5e2bfe9b85c0164f410a53a2d ]

Clockevents cannot be deregistered so suppress the bind attributes to
prevent the driver from being unbound and releasing the underlying
resources after registration.

Even if the driver can currently only be built-in, also switch to
builtin_platform_driver() to prevent it from being unloaded should
modular builds ever be enabled.

Fixes: cec32ac75827 ("clocksource/drivers/nxp-timer: Add the System Timer Module for the s32gx platforms")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20251111153226.579-4-johan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-nxp-stm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-nxp-stm.c b/drivers/clocksource/timer-nxp-stm.c
index bbb671b6e0284..b0cd3bc7b096d 100644
--- a/drivers/clocksource/timer-nxp-stm.c
+++ b/drivers/clocksource/timer-nxp-stm.c
@@ -485,9 +485,10 @@ static struct platform_driver nxp_stm_driver = {
 	.driver	= {
 		.name		= "nxp-stm",
 		.of_match_table	= nxp_stm_of_match,
+		.suppress_bind_attrs = true,
 	},
 };
-module_platform_driver(nxp_stm_driver);
+builtin_platform_driver(nxp_stm_driver);
 
 MODULE_DESCRIPTION("NXP System Timer Module driver");
 MODULE_LICENSE("GPL");
-- 
2.51.0



