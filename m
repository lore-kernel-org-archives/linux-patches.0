Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449C618E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT3byc0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F4FC433C7;
	Mon,  9 Oct 2023 13:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858608;
	bh=+iFhSFM6paddAXr3xH6LaBVSFFywpXPkodnbf4rgKJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vT3byc0lV/lW24/QYvDZi4kwAp0d0Tqoi0eEYP+3/vokl6dQuHr4+GEJnUIAngpMz
	 Fr0o74nijP/KNfhrq4aqO30NoNmorZozvv+PndYzjAeZKdVPMVbTQ32q3nofaKTSjT
	 la6KZTtzTS5W0S5t21LeICXxKXpyiIvGR5v2khpk=
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
Subject: [PATCH 5.10 044/226] platform/x86: intel_scu_ipc: Check status upon timeout in ipc_wait_for_interrupt()
Date: Mon,  9 Oct 2023 15:00:05 +0200
Message-ID: <20231009130127.948383919@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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
index 0b5029bca4a45..4c053c715cde0 100644
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



