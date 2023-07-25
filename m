Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C821D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3960AC433C7;
	Tue, 25 Jul 2023 11:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283049;
	bh=cvp4N1SVV1R7hATudZCJdO6PGCbejkamXcHFoSFEKW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lygv+4gw7SQ6gqmmIDp2WVOa7r5XrIsCdIFhPK4V+6Z4X2DJj9ttDbeUuFxEJwnAf
	 +aobscJO7x33SpPlgJj/9mpxjefE+X9+Wtmh/kX2M2HeX2C9SLfky2efVszQIKE5dh
	 VRi82ptY6Tej3fOSVWlfkwLiK3YoyWrqHCoF+PMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/183] iavf: use internal state to free traffic IRQs
Date: Tue, 25 Jul 2023 12:45:48 +0200
Message-ID: <20230725104512.272455835@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ahmed Zaki <ahmed.zaki@intel.com>

[ Upstream commit a77ed5c5b768e9649be240a2d864e5cd9c6a2015 ]

If the system tries to close the netdev while iavf_reset_task() is
running, __LINK_STATE_START will be cleared and netif_running() will
return false in iavf_reinit_interrupt_scheme(). This will result in
iavf_free_traffic_irqs() not being called and a leak as follows:

    [7632.489326] remove_proc_entry: removing non-empty directory 'irq/999', leaking at least 'iavf-enp24s0f0v0-TxRx-0'
    [7632.490214] WARNING: CPU: 0 PID: 10 at fs/proc/generic.c:718 remove_proc_entry+0x19b/0x1b0

is shown when pci_disable_msix() is later called. Fix by using the
internal adapter state. The traffic IRQs will always exist if
state == __IAVF_RUNNING.

Fixes: 5b36e8d04b44 ("i40evf: Enable VF to request an alternate queue allocation")
Signed-off-by: Ahmed Zaki <ahmed.zaki@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 81676c3af4b36..104de9a071449 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1941,15 +1941,16 @@ static void iavf_free_rss(struct iavf_adapter *adapter)
 /**
  * iavf_reinit_interrupt_scheme - Reallocate queues and vectors
  * @adapter: board private structure
+ * @running: true if adapter->state == __IAVF_RUNNING
  *
  * Returns 0 on success, negative on failure
  **/
-static int iavf_reinit_interrupt_scheme(struct iavf_adapter *adapter)
+static int iavf_reinit_interrupt_scheme(struct iavf_adapter *adapter, bool running)
 {
 	struct net_device *netdev = adapter->netdev;
 	int err;
 
-	if (netif_running(netdev))
+	if (running)
 		iavf_free_traffic_irqs(adapter);
 	iavf_free_misc_irq(adapter);
 	iavf_reset_interrupt_capability(adapter);
@@ -3056,7 +3057,7 @@ static void iavf_reset_task(struct work_struct *work)
 
 	if ((adapter->flags & IAVF_FLAG_REINIT_MSIX_NEEDED) ||
 	    (adapter->flags & IAVF_FLAG_REINIT_ITR_NEEDED)) {
-		err = iavf_reinit_interrupt_scheme(adapter);
+		err = iavf_reinit_interrupt_scheme(adapter, running);
 		if (err)
 			goto reset_err;
 	}
-- 
2.39.2



