Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF93B34F259;
	Thu, 28 May 2026 20:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999842; cv=none; b=EA3Wi1HE3E/asfIN5huyl9rCrwZ5D9ZvM/OEqT9Yf388BV5Lv1R+5G5XI8BCPLkGsixFJSJedBKgNvAj9wEpnFrz3lGZJW1H4ohEUzcEzsMon8lhvkw1fPqvDpygTYR1Lc6EXXOWR2aiaGQIb8xNlyiF9FHhDl2QowCumxG7M2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999842; c=relaxed/simple;
	bh=iCYkH0BrKtXP76Zbgk3T18iEaqqCe/hUfDxM27qVGXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPyPTBJOMPGmg4FNQVhsDILmYuUHWj9WqghJotKP5eKnXmcZ8B83420bGLjXHt0R1U8qBezAJWJhTlVRA4Ux7SPFyqZZBHf7H5P/4fa7T1In52vC+zAlDqXzQYX1UzIpOtkzEMb1Ht6xftDN41aAwbuiMBEIRCu3S+MADmE5LY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWGzmdUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWGzmdUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3899C1F00A3D;
	Thu, 28 May 2026 20:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999841;
	bh=1hXuXaqLn9CGGCJL7vLWbGHMw2LBdUp+c6p2+XS68Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CWGzmdUqQIEC/SFToJHeIyKhKqVZbMVRIXPclLui2QgzgNxneaYiE9S38V4VLp6nW
	 Vux3J+DaXV95AerjvcPttvVQQZZOYDWTYxqf0uCuOYABzhOzU4xcOR1RpAxUQlZDZh
	 QCYXtEAFA8IaVHP6lQBsXKhqgzhnpKnwAdRBZkmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tantilov <emil.s.tantilov@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Samuel Salin <Samuel.salin@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/377] idpf: fix read_dev_clk_lock spinlock init in idpf_ptp_init()
Date: Thu, 28 May 2026 21:47:28 +0200
Message-ID: <20260528194644.483306621@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Emil Tantilov <emil.s.tantilov@intel.com>

[ Upstream commit da4f76b6a84ede14a71282ef841768299ead0221 ]

In idpf_ptp_init(), read_dev_clk_lock is initialized after
ptp_schedule_worker() had already been called (and after
idpf_ptp_settime64() could reach the lock). The PTP aux worker
fires immediately upon scheduling and can call into
idpf_ptp_read_src_clk_reg_direct(), which takes
spin_lock(&ptp->read_dev_clk_lock) on an uninitialized lock, triggering
the lockdep "non-static key" warning:

[12973.796587] idpf 0000:83:00.0: Device HW Reset initiated
[12974.094507] INFO: trying to register non-static key.
...
[12974.097208] Call Trace:
[12974.097213]  <TASK>
[12974.097218]  dump_stack_lvl+0x93/0xe0
[12974.097234]  register_lock_class+0x4c4/0x4e0
[12974.097249]  ? __lock_acquire+0x427/0x2290
[12974.097259]  __lock_acquire+0x98/0x2290
[12974.097272]  lock_acquire+0xc6/0x310
[12974.097281]  ? idpf_ptp_read_src_clk_reg+0xb7/0x150 [idpf]
[12974.097311]  ? lockdep_hardirqs_on_prepare+0xde/0x190
[12974.097318]  ? finish_task_switch.isra.0+0xd2/0x350
[12974.097330]  ? __pfx_ptp_aux_kworker+0x10/0x10 [ptp]
[12974.097343]  _raw_spin_lock+0x30/0x40
[12974.097353]  ? idpf_ptp_read_src_clk_reg+0xb7/0x150 [idpf]
[12974.097373]  idpf_ptp_read_src_clk_reg+0xb7/0x150 [idpf]
[12974.097391]  ? kthread_worker_fn+0x88/0x3d0
[12974.097404]  ? kthread_worker_fn+0x4e/0x3d0
[12974.097411]  idpf_ptp_update_cached_phctime+0x26/0x120 [idpf]
[12974.097428]  ? _raw_spin_unlock_irq+0x28/0x50
[12974.097436]  idpf_ptp_do_aux_work+0x15/0x20 [idpf]
[12974.097454]  ptp_aux_kworker+0x20/0x40 [ptp]
[12974.097464]  kthread_worker_fn+0xd5/0x3d0
[12974.097474]  ? __pfx_kthread_worker_fn+0x10/0x10
[12974.097482]  kthread+0xf4/0x130
[12974.097489]  ? __pfx_kthread+0x10/0x10
[12974.097498]  ret_from_fork+0x32c/0x410
[12974.097512]  ? __pfx_kthread+0x10/0x10
[12974.097519]  ret_from_fork_asm+0x1a/0x30
[12974.097540]  </TASK>

Move the call to spin_lock_init() up a bit to make sure read_dev_clk_lock
is not touched before it's been initialized.

Fixes: 5cb8805d2366 ("idpf: negotiate PTP capabilities and get PTP clock")
Signed-off-by: Emil Tantilov <emil.s.tantilov@intel.com>
Reviewed-by: Madhu Chittim <madhu.chittim@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20260506-jk-iwl-net-2026-05-04-v2-3-a5ea4dc837a9@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_ptp.c b/drivers/net/ethernet/intel/idpf/idpf_ptp.c
index 0a8b50350b860..31c5593550e1a 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_ptp.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_ptp.c
@@ -949,6 +949,8 @@ int idpf_ptp_init(struct idpf_adapter *adapter)
 		goto free_ptp;
 	}
 
+	spin_lock_init(&adapter->ptp->read_dev_clk_lock);
+
 	err = idpf_ptp_create_clock(adapter);
 	if (err)
 		goto free_ptp;
@@ -974,8 +976,6 @@ int idpf_ptp_init(struct idpf_adapter *adapter)
 			goto remove_clock;
 	}
 
-	spin_lock_init(&adapter->ptp->read_dev_clk_lock);
-
 	pci_dbg(adapter->pdev, "PTP init successful\n");
 
 	return 0;
-- 
2.53.0



