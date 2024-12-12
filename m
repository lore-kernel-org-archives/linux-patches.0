Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA06241F40;
	Thu, 12 Dec 2024 15:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019150; cv=none; b=t6P0GoHFtrBw1Ix7R/5Fzk2LxAR/EgoVJpMlDPTLcvnjkMTps+GLcHkC29ZoH/g1VbvwKp9sP5lS4pgRj2W2m5H2Ux4x/oRYFUxqhPoate64c1Hl6g+5sizug7E3T+KMDn3q5bxjsZo3dJ750zJUwpCb2nF3GgdKha9eaV2EiOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019150; c=relaxed/simple;
	bh=TELLZLcqINJvTCdCGp5jf/6HUqmeujhotutaeuQWH30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFHXSo2JMwCtINzrgNfzS+7umxviqGe90BZUolRXJLTJOMGFJH9anY6S8fmfuxnw3Ly5Ugx43e+5QC6bWjzGeVsbl8P90+4Lr1Hk1PnB9hJB+dM9xBktfonFyPeUtTlCNV2bakiVJaV8rY053yJT5zuUU25G+ROkJx7DNy2tluw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDD5ANC7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDD5ANC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0F8C4CED3;
	Thu, 12 Dec 2024 15:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019150;
	bh=TELLZLcqINJvTCdCGp5jf/6HUqmeujhotutaeuQWH30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDD5ANC7xMQRyy9MYPJAlQEP8OCHE6PWZtZ/zpMELswFBBnH5smdomrSqRwCOnuOb
	 swy5+O7aqT3x88MDpv7UR22A21cmn64zBG/moFwvLotycILBIrIxrdwN+w1L2rsImD
	 /Z6SPb1kw1SUyn9xS57GOIApB4Vstg77VOmNTCWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/772] clocksource/drivers/timer-ti-dm: Fix child node refcount handling
Date: Thu, 12 Dec 2024 15:50:36 +0100
Message-ID: <20241212144353.706016634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit e5cfc0989d9a2849c51c720a16b90b2c061a1aeb ]

of_find_compatible_node() increments the node's refcount, and it must be
decremented again with a call to of_node_put() when the pointer is no
longer required to avoid leaking the resource.

Instead of adding the missing calls to of_node_put() in all execution
paths, use the cleanup attribute for 'arm_timer' by means of the
__free() macro, which automatically calls of_node_put() when the
variable goes out of scope.

Fixes: 25de4ce5ed02 ("clocksource/drivers/timer-ti-dm: Handle dra7 timer wrap errata i940")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20241031-timer-ti-dm-systimer-of_node_put-v3-1-063ee822b73a@gmail.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-ti-dm-systimer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/timer-ti-dm-systimer.c b/drivers/clocksource/timer-ti-dm-systimer.c
index 632523c1232f6..734920e8c5759 100644
--- a/drivers/clocksource/timer-ti-dm-systimer.c
+++ b/drivers/clocksource/timer-ti-dm-systimer.c
@@ -688,9 +688,9 @@ subsys_initcall(dmtimer_percpu_timer_startup);
 
 static int __init dmtimer_percpu_quirk_init(struct device_node *np, u32 pa)
 {
-	struct device_node *arm_timer;
+	struct device_node *arm_timer __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
 
-	arm_timer = of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
 	if (of_device_is_available(arm_timer)) {
 		pr_warn_once("ARM architected timer wrap issue i940 detected\n");
 		return 0;
-- 
2.43.0



