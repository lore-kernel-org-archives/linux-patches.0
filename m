Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1412E64F;
	Fri, 24 Nov 2023 19:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSyf0v2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07EA9C433C7;
	Fri, 24 Nov 2023 19:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852812;
	bh=RK0IN3+y/rFNXNg2CXjsNFse1Gm4ycM4u1EdChge1+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSyf0v2AYH6YFuqmYDgyzpC/21Z9VzC1xLGhqPkuGD+3htbXJlkV131vD7iNplhbm
	 3hvfccFVfebHaBxEer8PaKifxI6aeNUf2yoW4eQFQEoNdZe0R4jDhV2Adg4aYpqO0t
	 HVUsyzxrGh+yb6oqtiYZUdmznnw8brwzOPZNHDLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Wolfram Sang <wsa@kernel.org>,
	Nishanth Menon <nm@ti.com>,
	Benjamin Bara <benjamin.bara@skidata.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 132/193] i2c: core: Run atomic i2c xfer when !preemptible
Date: Fri, 24 Nov 2023 17:54:19 +0000
Message-ID: <20231124171952.507470636@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171947.127438872@linuxfoundation.org>
References: <20231124171947.127438872@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Bara <benjamin.bara@skidata.com>

commit aa49c90894d06e18a1ee7c095edbd2f37c232d02 upstream.

Since bae1d3a05a8b, i2c transfers are non-atomic if preemption is
disabled. However, non-atomic i2c transfers require preemption (e.g. in
wait_for_completion() while waiting for the DMA).

panic() calls preempt_disable_notrace() before calling
emergency_restart(). Therefore, if an i2c device is used for the
restart, the xfer should be atomic. This avoids warnings like:

[   12.667612] WARNING: CPU: 1 PID: 1 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch+0x33c/0x6b0
[   12.676926] Voluntary context switch within RCU read-side critical section!
...
[   12.742376]  schedule_timeout from wait_for_completion_timeout+0x90/0x114
[   12.749179]  wait_for_completion_timeout from tegra_i2c_wait_completion+0x40/0x70
...
[   12.994527]  atomic_notifier_call_chain from machine_restart+0x34/0x58
[   13.001050]  machine_restart from panic+0x2a8/0x32c

Use !preemptible() instead, which is basically the same check as
pre-v5.2.

Fixes: bae1d3a05a8b ("i2c: core: remove use of in_atomic()")
Cc: stable@vger.kernel.org # v5.2+
Suggested-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Acked-by: Wolfram Sang <wsa@kernel.org>
Reviewed-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Tested-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Benjamin Bara <benjamin.bara@skidata.com>
Link: https://lore.kernel.org/r/20230327-tegra-pmic-reboot-v7-2-18699d5dcd76@skidata.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/i2c-core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/i2c-core.h
+++ b/drivers/i2c/i2c-core.h
@@ -29,7 +29,7 @@ int i2c_dev_irq_from_resources(const str
  */
 static inline bool i2c_in_atomic_xfer_mode(void)
 {
-	return system_state > SYSTEM_RUNNING && irqs_disabled();
+	return system_state > SYSTEM_RUNNING && !preemptible();
 }
 
 static inline int __i2c_lock_bus_helper(struct i2c_adapter *adap)


