Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933B96FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:02:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A69C433EF;
	Mon, 16 Jan 2023 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888533;
	bh=R5m+meuX56lK8qqvJMnFyVFAEiJUbiZ90m0DHPeDlvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ggh3bWZXFL6mrqNrrhggTdUYjwmNxH+7/0ymhLU6ivKZWo50rZNkZKTasCdsUABle
	 Rtzsms4dBGcfrjBgV44cPSdhc3tDunCKZuB1cSPlazLdZ17jUn9j/jMIFzv/MJw8mZ
	 mQ6IroT8zKi1Hxzbr+kISvI3Il61/l+iH29oBo0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 041/338] cpuidle: dt: Return the correct numbers of parsed idle states
Date: Mon, 16 Jan 2023 16:48:34 +0100
Message-Id: <20230116154822.575465503@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ulf Hansson <ulf.hansson@linaro.org>

[ Upstream commit ee3c2c8ad6ba6785f14a60e4081d7c82e88162a2 ]

While we correctly skips to initialize an idle state from a disabled idle
state node in DT, the returned value from dt_init_idle_driver() don't get
adjusted accordingly. Instead the number of found idle state nodes are
returned, while the callers are expecting the number of successfully
initialized idle states from DT.

This leads to cpuidle drivers unnecessarily continues to initialize their
idle state specific data. Moreover, in the case when all idle states have
been disabled in DT, we would end up registering a cpuidle driver, rather
than relying on the default arch specific idle call.

Fixes: 9f14da345599 ("drivers: cpuidle: implement DT based idle states infrastructure")
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/dt_idle_states.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/dt_idle_states.c b/drivers/cpuidle/dt_idle_states.c
index 53342b7f1010..ea3c59d3fdad 100644
--- a/drivers/cpuidle/dt_idle_states.c
+++ b/drivers/cpuidle/dt_idle_states.c
@@ -224,6 +224,6 @@ int dt_init_idle_driver(struct cpuidle_driver *drv,
 	 * also be 0 on platforms with missing DT idle states or legacy DT
 	 * configuration predating the DT idle states bindings.
 	 */
-	return i;
+	return state_idx - start_idx;
 }
 EXPORT_SYMBOL_GPL(dt_init_idle_driver);
-- 
2.35.1



