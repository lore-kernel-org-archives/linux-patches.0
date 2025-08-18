Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5002C235D;
	Mon, 18 Aug 2025 14:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525967; cv=none; b=e5z2PM9Iz05wQSMPLV1YIJhjU8MOGLtvGK0grAp7+oTTmm2RAAkwxfWu/P9jI4slIs0WoAgmCD+T6V5qk8r+JXVr99EzlF7vZQYAP4Mjwd9+zLcyNp7R8znfmN5tae+p5+8Z4plQgNNI+q8K0rQraI8bMUYmL43taOdTMk8IKjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525967; c=relaxed/simple;
	bh=umG/+d47Xlsutind0816hQrNKzw93+T6Pd6wMEDnWEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1RWtZhURQ8BigcM2hu4rRYshE1gCDoqrKU7ZF+vMmelDqE9cg8ZJ/8LdQJ+xMp81oaBUJNTJlLjhoDi7AnPxQ/FL81C9Hju3C8Pbg+zue/5apmwQRhjAJkihp9slT1g5/HWg3J915G7pZYnOeQKD5hxbJ7Z6xgOrUjfa39zk9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PEBdFN/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PEBdFN/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E766FC116C6;
	Mon, 18 Aug 2025 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525967;
	bh=umG/+d47Xlsutind0816hQrNKzw93+T6Pd6wMEDnWEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEBdFN/LCCibuyLb/sSERqK4xm7bIdn6fGfOp8KkMDIMN03px9tLs0vGQ7h7ZaMi9
	 7mrFwSCk0tPRJ3zWiUX699aLblg36Z2qBPMzbntZ9E6aMZjz2j7hF5/X2eqe6DcvRz
	 A//1PjWN6/BA53ES/xvTiX7pJLiRQ3ducNWTmuSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 420/570] soundwire: amd: serialize amd manager resume sequence during pm_prepare
Date: Mon, 18 Aug 2025 14:46:47 +0200
Message-ID: <20250818124522.021018929@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 03837341790039d6f1cbf7a1ae7dfa2cb77ef0a4 ]

During pm_prepare callback, pm_request_resume() delays SoundWire manager D0
entry sequence. Synchronize runtime resume sequence for amd_manager
instance prior to invoking child devices resume sequence for both the amd
power modes(ClockStop Mode and Power off mode).
Change the power_mode_mask check and use pm_runtime_resume() in
amd_pm_prepare() callback.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250530054447.1645807-3-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 7a671a786197..3b335d6eaa94 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1178,10 +1178,10 @@ static int __maybe_unused amd_pm_prepare(struct device *dev)
 	 * device is not in runtime suspend state, observed that device alerts are missing
 	 * without pm_prepare on AMD platforms in clockstop mode0.
 	 */
-	if (amd_manager->power_mode_mask & AMD_SDW_CLK_STOP_MODE) {
-		ret = pm_request_resume(dev);
+	if (amd_manager->power_mode_mask) {
+		ret = pm_runtime_resume(dev);
 		if (ret < 0) {
-			dev_err(bus->dev, "pm_request_resume failed: %d\n", ret);
+			dev_err(bus->dev, "pm_runtime_resume failed: %d\n", ret);
 			return 0;
 		}
 	}
-- 
2.39.5



