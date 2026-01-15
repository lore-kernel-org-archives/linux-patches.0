Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FA0274B43;
	Thu, 15 Jan 2026 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496201; cv=none; b=S8jLNGlx7D07iMg8ooT5eW7zSrsYhhl8cbU0tFvj9jJerlvf4ZjrEMjxXBSVPkk6N1z6/2UQDl/CCZVfntDxTeiN+9o8YVuybZ7aOxaT0r7o0xqCNWYU0f9fGTBZ48ftswP/uUqWpbYnpn1QIwhy3QEK+giY63wduMY1VBKSQWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496201; c=relaxed/simple;
	bh=JlQ5G4nAuSX/AFYA4fX6yE/qMWSi6uDA3BByNnBKHuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIAzTrMtw0priKTuAUPp60rsBzpwf+qoSqsGTNCKk2VLjW1a5EWz03n9Zzz1Nysz/2DiIhZmtu5RFYyn2demOQmr9owE0YeQHWmSeIrSjkDyFWWRgGDpzmj7E9O7YqxZATARwqpXUAQINYS+DF5EMI+ewc8oqLSfM4m90SYO2O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuVB5qej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuVB5qej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521A3C16AAE;
	Thu, 15 Jan 2026 16:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496201;
	bh=JlQ5G4nAuSX/AFYA4fX6yE/qMWSi6uDA3BByNnBKHuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuVB5qejO8cpPD1U3Ib0VJN3hvKlcIFxLbWLeoNEvHtXY4PFt5wcHPrvYAJmOXxqV
	 OrjMMMnKlJ56KrUp6hsd3+puPUHDEq9B4rXqqgFuD05fbVZubcsnSiZhb/SgU+1l4d
	 tL1Bs8JpANBP0cmz+kvH+DYolHOSbtJi7jlEcpcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Liang <xiliang@redhat.com>,
	David Arinzon <darinzon@amazon.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/181] net/ena: fix missing lock when update devlink params
Date: Thu, 15 Jan 2026 17:47:23 +0100
Message-ID: <20260115164206.145865545@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Frank Liang <xiliang@redhat.com>

[ Upstream commit 8da901ffe497a53fa4ecc3ceed0e6d771586f88e ]

Fix assert lock warning while calling devl_param_driverinit_value_set()
in ena.

WARNING: net/devlink/core.c:261 at devl_assert_locked+0x62/0x90, CPU#0: kworker/0:0/9
CPU: 0 UID: 0 PID: 9 Comm: kworker/0:0 Not tainted 6.19.0-rc2+ #1 PREEMPT(lazy)
Hardware name: Amazon EC2 m8i-flex.4xlarge/, BIOS 1.0 10/16/2017
Workqueue: events work_for_cpu_fn
RIP: 0010:devl_assert_locked+0x62/0x90

Call Trace:
 <TASK>
 devl_param_driverinit_value_set+0x15/0x1c0
 ena_devlink_alloc+0x18c/0x220 [ena]
 ? __pfx_ena_devlink_alloc+0x10/0x10 [ena]
 ? trace_hardirqs_on+0x18/0x140
 ? lockdep_hardirqs_on+0x8c/0x130
 ? __raw_spin_unlock_irqrestore+0x5d/0x80
 ? __raw_spin_unlock_irqrestore+0x46/0x80
 ? devm_ioremap_wc+0x9a/0xd0
 ena_probe+0x4d2/0x1b20 [ena]
 ? __lock_acquire+0x56a/0xbd0
 ? __pfx_ena_probe+0x10/0x10 [ena]
 ? local_clock+0x15/0x30
 ? __lock_release.isra.0+0x1c9/0x340
 ? mark_held_locks+0x40/0x70
 ? lockdep_hardirqs_on_prepare.part.0+0x92/0x170
 ? trace_hardirqs_on+0x18/0x140
 ? lockdep_hardirqs_on+0x8c/0x130
 ? __raw_spin_unlock_irqrestore+0x5d/0x80
 ? __raw_spin_unlock_irqrestore+0x46/0x80
 ? __pfx_ena_probe+0x10/0x10 [ena]
 ......
 </TASK>

Fixes: 816b52624cf6 ("net: ena: Control PHC enable through devlink")
Signed-off-by: Frank Liang <xiliang@redhat.com>
Reviewed-by: David Arinzon <darinzon@amazon.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20251231145808.6103-1-xiliang@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_devlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_devlink.c b/drivers/net/ethernet/amazon/ena/ena_devlink.c
index ac81c24016dd4..4772185e669d2 100644
--- a/drivers/net/ethernet/amazon/ena/ena_devlink.c
+++ b/drivers/net/ethernet/amazon/ena/ena_devlink.c
@@ -53,10 +53,12 @@ void ena_devlink_disable_phc_param(struct devlink *devlink)
 {
 	union devlink_param_value value;
 
+	devl_lock(devlink);
 	value.vbool = false;
 	devl_param_driverinit_value_set(devlink,
 					DEVLINK_PARAM_GENERIC_ID_ENABLE_PHC,
 					value);
+	devl_unlock(devlink);
 }
 
 static void ena_devlink_port_register(struct devlink *devlink)
@@ -145,10 +147,12 @@ static int ena_devlink_configure_params(struct devlink *devlink)
 		return rc;
 	}
 
+	devl_lock(devlink);
 	value.vbool = ena_phc_is_enabled(adapter);
 	devl_param_driverinit_value_set(devlink,
 					DEVLINK_PARAM_GENERIC_ID_ENABLE_PHC,
 					value);
+	devl_unlock(devlink);
 
 	return 0;
 }
-- 
2.51.0



