Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD19D2FA631;
	Tue, 17 Jun 2025 16:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178916; cv=none; b=Xz+EGrbtF1DlLvbDvba82X/YEH7ojpNlA0a4u+BnfCr5P+B+f38RHsWK56qJkOKUzxDk1V6MezrrclgpEmkk9ARW6Fd6BxWy/Qe/ZYIGuWhmkxvz1eUkCjLSXItcY3bxHBNo/rocQuN0PMzAdFi8JwJsrnxGtwa/K/3Uxs2f7F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178916; c=relaxed/simple;
	bh=aWbdFXKeNKL7Ix2Q608H4cm/pHXLwp28LTj6I4Y06Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQHArzSqsXXJtsVaHbpx2RYbLpnp+i7IoooAwrrLgYjFAo/NSO0VgFRM6xvTrB+QSYU9I8hocl6d4rFKJbnoJB8wo5TnQSfkLYV3HN979x04nRj1VsuHRwc0Q1D8Ed9Eni0yHWxvGPdshtb+8fTwFHq22dWEMPUBCgYGsPFCMMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmXnvMME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmXnvMME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC6BC4CEE3;
	Tue, 17 Jun 2025 16:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178915;
	bh=aWbdFXKeNKL7Ix2Q608H4cm/pHXLwp28LTj6I4Y06Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmXnvMMEEIItGnG24x14I1nAxV67IFtSyABacFiPAujJyA8iQmB/xhgHjw+EzoZ59
	 x1HKEPDh4mflDM1P8OWkBruoSTNOiVI8A+6dYXn2sYe2fi1CJWQxu77uGoFAGDO7Nk
	 DYWiM6WTVFAfAkMlkPcS77pr1UPoqa27f/IDr4H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 592/780] iavf: iavf_suspend(): take RTNL before netdev_lock()
Date: Tue, 17 Jun 2025 17:25:00 +0200
Message-ID: <20250617152515.583581080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit dba35a4bb4a3da5696f2a179b7d695dc3ea25fb8 ]

Fix an obvious violation of lock ordering.
Jakub's [1] added netdev_lock() call that is wrong ordered wrt RTNL,
but the Fixes tag points to crit_lock being wrongly placed (by lockdep
standards).

Actual reason we got it wrong is dated back to critical section managed by
pure flag checks, which is with us since the very beginning.

[1] afc664987ab3 ("eth: iavf: extend the netdev_lock usage")

Fixes: 5ac49f3c2702 ("iavf: use mutexes for locking of critical sections")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 6d7ba4d67a193..a77c726435281 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -5596,22 +5596,27 @@ static int iavf_suspend(struct device *dev_d)
 {
 	struct net_device *netdev = dev_get_drvdata(dev_d);
 	struct iavf_adapter *adapter = netdev_priv(netdev);
+	bool running;
 
 	netif_device_detach(netdev);
 
+	running = netif_running(netdev);
+	if (running)
+		rtnl_lock();
+
 	netdev_lock(netdev);
 	mutex_lock(&adapter->crit_lock);
 
-	if (netif_running(netdev)) {
-		rtnl_lock();
+	if (running)
 		iavf_down(adapter);
-		rtnl_unlock();
-	}
+
 	iavf_free_misc_irq(adapter);
 	iavf_reset_interrupt_capability(adapter);
 
 	mutex_unlock(&adapter->crit_lock);
 	netdev_unlock(netdev);
+	if (running)
+		rtnl_unlock();
 
 	return 0;
 }
-- 
2.39.5



