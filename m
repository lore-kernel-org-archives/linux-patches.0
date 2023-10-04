Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30EF1D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:03:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33702C433C7;
	Wed,  4 Oct 2023 18:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442618;
	bh=5yLxM3fBIIxYWP001dHYg9GuygKZs79GWsFDOBX907E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnuh1YfsWO/3OQg+FuH5Pfj7Wqb3ad2ZbC/EmRrMfa6BTkacQ7qO3uu1tE7Lt9jP3
	 FD5NvI8pzNRr3WDbKgzxLj01DySANKVq3NV3c/D9mn4UHiP2Asr/oQ9VAEUpmA73fJ
	 fu0uG0XhXBPqUumNP6tXiBySwPOFhGk2Daym8a6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Malani <pmalani@chromium.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/183] platform/x86: intel_scu_ipc: Check status upon timeout in ipc_wait_for_interrupt()
Date: Wed,  4 Oct 2023 19:54:40 +0200
Message-ID: <20231004175206.011395750@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 427fada620733e6474d783ae6037a66eae42bf8c ]

It's possible for the completion in ipc_wait_for_interrupt() to timeout,
simply because the interrupt was delayed in being processed. A timeout
in itself is not an error. This driver should check the status register
upon a timeout to ensure that scheduling or interrupt processing delays
don't affect the outcome of the IPC return value.

 CPU0                                                   SCU
 ----                                                   ---
 ipc_wait_for_interrupt()
  wait_for_completion_timeout(&scu->cmd_complete)
  [TIMEOUT]                                             status[IPC_STATUS_BUSY]=0

Fix this problem by reading the status bit in all cases, regardless of
the timeout. If the completion times out, we'll assume the problem was
that the IPC_STATUS_BUSY bit was still set, but if the status bit is
cleared in the meantime we know that we hit some scheduling delay and we
should just check the error bit.

Cc: Prashant Malani <pmalani@chromium.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Fixes: ed12f295bfd5 ("ipc: Added support for IPC interrupt mode")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20230913212723.3055315-3-swboyd@chromium.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel_scu_ipc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 96675bea88b10..be97cfae4b0f3 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -249,10 +249,12 @@ static inline int ipc_wait_for_interrupt(struct intel_scu_ipc_dev *scu)
 {
 	int status;
 
-	if (!wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT))
-		return -ETIMEDOUT;
+	wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT);
 
 	status = ipc_read_status(scu);
+	if (status & IPC_STATUS_BUSY)
+		return -ETIMEDOUT;
+
 	if (status & IPC_STATUS_ERR)
 		return -EIO;
 
-- 
2.40.1



