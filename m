Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A416121;
	Tue, 23 Jan 2024 01:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974102; cv=none; b=g6RNLpeAW2a1869ycxXw+5vK2syHPTIuOq6xEoyC0Fagzll1k5yhYhcW8iu3V1h9PvozU7sTSwKgGp4OvP27R7xUZYMWdxGnL8MjOM5lEcrDXDsAbPtFy0KGbEclXV+F0ZvanIpL6+VbnyEAa55y7AWRUz8Gd5MQRT+HdyLGrSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974102; c=relaxed/simple;
	bh=23zlyUyL8y3HWW5QNXf8ouQXM+6XCoEdxaDB7LrplVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Szt89N9iRTCVUBypphZjQI65u9wefmJm0Ntm2Gcyqj2RzRtKSJ9O2e5QHLgLVLW0pQcLsuhquGBamXd2ERrtPsSG1q9qefL7cZwyx9JDzybhZTr3GokWuQXkEw2Mv/wCKSmCITMqb3Sn5FaPDw8voslMzzE5FBHjsmxEjwCSdE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itT1Qj7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itT1Qj7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1DEC43390;
	Tue, 23 Jan 2024 01:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974101;
	bh=23zlyUyL8y3HWW5QNXf8ouQXM+6XCoEdxaDB7LrplVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=itT1Qj7ngN9Tr3CRGYNdOvRyylxMfdUkrM0R5ly4GU9sfpMYgghma9nnNZOsrl86y
	 /tRGLvKC9W5m5K8FEYv/22z79u5yMICuJ7CwEBaYf420T1kvxnZY5ysZ9SxrSIej7U
	 K26a+iuph1PR9S105DH2nCx22Af7V29xsbMRtSuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	forza@tnonline.net,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/583] cpuidle: haltpoll: Do not enable interrupts when entering idle
Date: Mon, 22 Jan 2024 15:51:30 -0800
Message-ID: <20240122235813.350306059@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

[ Upstream commit c8f5caec3df84a02b937d6d9cda1f7ffa8dc443f ]

The cpuidle drivers' ->enter() methods are supposed to be IRQ invariant:

  5e26aa933911 ("cpuidle/poll: Ensure IRQs stay disabled after cpuidle_state::enter() calls")
  bb7b11258561 ("cpuidle: Move IRQ state validation")

Do that in the haltpoll driver too.

Fixes: 5e26aa933911 ("cpuidle/poll: Ensure IRQs stay disabled after cpuidle_state::enter() calls")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218245
Reported-by: <forza@tnonline.net>
Tested-by: <forza@tnonline.net>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/cpuidle-haltpoll.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index e66df22f9695..d8515d5c0853 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -25,13 +25,12 @@ MODULE_PARM_DESC(force, "Load unconditionally");
 static struct cpuidle_device __percpu *haltpoll_cpuidle_devices;
 static enum cpuhp_state haltpoll_hp_state;
 
-static int default_enter_idle(struct cpuidle_device *dev,
-			      struct cpuidle_driver *drv, int index)
+static __cpuidle int default_enter_idle(struct cpuidle_device *dev,
+					struct cpuidle_driver *drv, int index)
 {
-	if (current_clr_polling_and_test()) {
-		local_irq_enable();
+	if (current_clr_polling_and_test())
 		return index;
-	}
+
 	arch_cpu_idle();
 	return index;
 }
-- 
2.43.0



