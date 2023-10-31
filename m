Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C4E200D8
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnFuUUBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52EAC433C9;
	Tue, 31 Oct 2023 17:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771836;
	bh=sybyvJX6f9RTDd4I66HTmH7b4oAKg2Y6v0GKwxDwycU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EnFuUUBRDvESn+2/tUhH0T7nzVZymjUjR/DBd+IUM6GZjI8FtBlL3xRLNTMuHsf+9
	 5k6ZsceGGMLe89MFxFrHrxzFYvQ4rFVlJSdQoAGaViUns4WDuu/w5f6lnY/4VVgHWa
	 WIQ9Li1ipp45ND4+jU0rK8gQIk3hmrblVCCxKn8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 37/86] iavf: initialize waitqueues before starting watchdog_task
Date: Tue, 31 Oct 2023 18:01:02 +0100
Message-ID: <20231031165919.794321733@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 7db3111043885c146e795c199d39c3f9042d97c0 ]

It is not safe to initialize the waitqueues after queueing the
watchdog_task. It will be using them.

The chance of this causing a real problem is very small, because
there will be some sleeping before any of the waitqueues get used.
I got a crash only after inserting an artificial sleep in iavf_probe.

Queue the watchdog_task as the last step in iavf_probe. Add a comment to
prevent repeating the mistake.

Fixes: fe2647ab0c99 ("i40evf: prevent VF close returning before state transitions to DOWN")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index a39f7f0d6ab0b..1ae90f8f9941f 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -5020,8 +5020,6 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	INIT_WORK(&adapter->finish_config, iavf_finish_config);
 	INIT_DELAYED_WORK(&adapter->watchdog_task, iavf_watchdog_task);
 	INIT_DELAYED_WORK(&adapter->client_task, iavf_client_task);
-	queue_delayed_work(adapter->wq, &adapter->watchdog_task,
-			   msecs_to_jiffies(5 * (pdev->devfn & 0x07)));
 
 	/* Setup the wait queue for indicating transition to down status */
 	init_waitqueue_head(&adapter->down_waitqueue);
@@ -5032,6 +5030,9 @@ static int iavf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Setup the wait queue for indicating virtchannel events */
 	init_waitqueue_head(&adapter->vc_waitqueue);
 
+	queue_delayed_work(adapter->wq, &adapter->watchdog_task,
+			   msecs_to_jiffies(5 * (pdev->devfn & 0x07)));
+	/* Initialization goes on in the work. Do not add more of it below. */
 	return 0;
 
 err_ioremap:
-- 
2.42.0



