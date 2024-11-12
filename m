Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F4C20E307;
	Tue, 12 Nov 2024 10:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408451; cv=none; b=nJ4HqV2E1TX3+EeoDBiSBfJEt/yFcOgZF9fHt77IV5H+ddYs+kV5HmgQVDjhdoKol2ROxl/rgfXOMOuV1IqpwlgdZ7ZcYG0B47FgbZaakxl1EpR4M8b/SgEce2E8rxEutz/T79k5f0ZZo0yFAXf5U+ca30ubJzk8hCHIQ+AyjPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408451; c=relaxed/simple;
	bh=ZMeLJp96ShZUUjyMFr5Je+/DjGabfM5lMB24KpCkthE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeryVekbdqQCpWWvvpwzOgvs1Cg6Vgk49n5QkJ+uQF0rkkBT6FFBcMdcK+a7X389//7Nk1oQ8+KYCCZE0YLwZ/3noliDecMUzSuTCK7LsAQjHWMYZNZOliYX+VFE8xtai73A3XR0PzopJZjnizthaK7mSctrNOCRan5WxIgzgh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKak6d7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKak6d7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC23C4CECD;
	Tue, 12 Nov 2024 10:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408451;
	bh=ZMeLJp96ShZUUjyMFr5Je+/DjGabfM5lMB24KpCkthE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKak6d7XsDthMpVhEkpZ0Xx6MD9230NFpAoN3MQPzlh/YP77S0uJLyPL4yBGJ7Eoa
	 fYAPTRA7GM3ejeccclGq/7iadAU9bCjVBdeQ8YBJGOxcK7cfBfrBF/7NClIHiFcQtC
	 sIM31K8DS/QdKoNHbaTdjHN5fZeWaRTOXhQJC9+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarun K Singh <tarun.k.singh@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
	Krishneil Singh <krishneil.k.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH 6.11 135/184] idpf: fix idpf_vc_core_init error path
Date: Tue, 12 Nov 2024 11:21:33 +0100
Message-ID: <20241112101906.050916564@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Kumar Linga <pavan.kumar.linga@intel.com>

commit 9b58031ff96b84a38d7b73b23c7ecfb2e0557f43 upstream.

In an event where the platform running the device control plane
is rebooted, reset is detected on the driver. It releases
all the resources and waits for the reset to complete. Once the
reset is done, it tries to build the resources back. At this
time if the device control plane is not yet started, then
the driver timeouts on the virtchnl message and retries to
establish the mailbox again.

In the retry flow, mailbox is deinitialized but the mailbox
workqueue is still alive and polling for the mailbox message.
This results in accessing the released control queue leading to
null-ptr-deref. Fix it by unrolling the work queue cancellation
and mailbox deinitialization in the reverse order which they got
initialized.

Fixes: 4930fbf419a7 ("idpf: add core init and interrupt request")
Fixes: 34c21fa894a1 ("idpf: implement virtchnl transaction manager")
Cc: stable@vger.kernel.org # 6.9+
Reviewed-by: Tarun K Singh <tarun.k.singh@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Tested-by: Krishneil Singh <krishneil.k.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/idpf/idpf_lib.c      |    1 +
 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -1799,6 +1799,7 @@ static int idpf_init_hard_reset(struct i
 	 */
 	err = idpf_vc_core_init(adapter);
 	if (err) {
+		cancel_delayed_work_sync(&adapter->mbx_task);
 		idpf_deinit_dflt_mbx(adapter);
 		goto unlock_mutex;
 	}
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -3063,7 +3063,6 @@ init_failed:
 	adapter->state = __IDPF_VER_CHECK;
 	if (adapter->vcxn_mngr)
 		idpf_vc_xn_shutdown(adapter->vcxn_mngr);
-	idpf_deinit_dflt_mbx(adapter);
 	set_bit(IDPF_HR_DRV_LOAD, adapter->flags);
 	queue_delayed_work(adapter->vc_event_wq, &adapter->vc_event_task,
 			   msecs_to_jiffies(task_delay));


