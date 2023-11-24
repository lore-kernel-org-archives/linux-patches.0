Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E701831740;
	Fri, 24 Nov 2023 18:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qBlvBqq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D35C433C7;
	Fri, 24 Nov 2023 18:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849895;
	bh=M4GG0QAoIc7nJmsWIrTbywVVX7NLXkYF9c4RsHQfn+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qBlvBqqE6yV9VRGZslxmiBYu7dghqc9iAttPhcWxP1iiA4lUTbozBuv+IJOxX4p5
	 +ihR6fJ5Y3arMMxM6uZRTaxIP1daPdEKeHzla1VUObcaF64kuuS78QDLxDOLsM7gTB
	 Yfm/fcnVRZ2SbQuelEFhtg3xwpY6SdarTTsG15hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Nishanth Menon <nm@ti.com>,
	Benjamin Bara <benjamin.bara@skidata.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 364/530] kernel/reboot: emergency_restart: Set correct system_state
Date: Fri, 24 Nov 2023 17:48:50 +0000
Message-ID: <20231124172039.092418916@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Benjamin Bara <benjamin.bara@skidata.com>

commit 60466c067927abbcaff299845abd4b7069963139 upstream.

As the emergency restart does not call kernel_restart_prepare(), the
system_state stays in SYSTEM_RUNNING.

Since bae1d3a05a8b, this hinders i2c_in_atomic_xfer_mode() from becoming
active, and therefore might lead to avoidable warnings in the restart
handlers, e.g.:

[   12.667612] WARNING: CPU: 1 PID: 1 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch+0x33c/0x6b0
[   12.676926] Voluntary context switch within RCU read-side critical section!
...
[   12.742376]  schedule_timeout from wait_for_completion_timeout+0x90/0x114
[   12.749179]  wait_for_completion_timeout from tegra_i2c_wait_completion+0x40/0x70
...
[   12.994527]  atomic_notifier_call_chain from machine_restart+0x34/0x58
[   13.001050]  machine_restart from panic+0x2a8/0x32c

Avoid these by setting the correct system_state.

Fixes: bae1d3a05a8b ("i2c: core: remove use of in_atomic()")
Cc: stable@vger.kernel.org # v5.2+
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Tested-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Benjamin Bara <benjamin.bara@skidata.com>
Link: https://lore.kernel.org/r/20230327-tegra-pmic-reboot-v7-1-18699d5dcd76@skidata.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/reboot.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -74,6 +74,7 @@ void __weak (*pm_power_off)(void);
 void emergency_restart(void)
 {
 	kmsg_dump(KMSG_DUMP_EMERG);
+	system_state = SYSTEM_RESTART;
 	machine_emergency_restart();
 }
 EXPORT_SYMBOL_GPL(emergency_restart);


