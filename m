Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B6C38B15B;
	Sat, 12 Sep 2026 18:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238393; cv=none; b=uN/rybDkJumH7l8U8F+Lyhv5g4JuOIAzXhhFRTx4OC4SKTWhi829aAUc8gzde2HJlBkVss3ieQTl91AHFv5kPuSg4BfXCDWXPNlgGns6x8q4B4dOsOf89mHwuqQhnWilUA4Lop3AuDrnCL1BVrBfS9ZcQjzLgk3BqJEeMDvyiDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238393; c=relaxed/simple;
	bh=9txdC3DKccZouEB7VZHczcRonSAIV4tOJCL7aEzlse0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTo0zenE4oNKFt6TxZHzzqGMVAy/46E+BsY141DB0i1b2/xso2xIqNES42h2dCI5Xcc8IIHZceICgMjuU8afVW0aKBIg23Z7URZKssJDTmQBInAdCJNuguwwig6GOcc+x3K2lTp9/jiJBkF9ppby9WwdLdDJfLkRY9pgVZoexVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZV1euJ4J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZV1euJ4J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA1F1F000FF;
	Sat, 12 Sep 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238389;
	bh=5AOUwB+Cr4oQTDu+2RXtMvk98KliVwziv2Q9jl/kxW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZV1euJ4JtSe7MPp0xIN4TUYX5bI4UZtdpJfqzGVqxr9SBNp6u9UVsqIbOucolK3lc
	 R0xHj1D2pRKnVvbQFhK3EwaFgA33CMAdFKsI+pXVTyKrJoDnWp0tUQE5CKI8ZPxn5e
	 +cRdvItqVcQAw2mi19cBUbEHGlLSdtTbChavVMs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 453/935] staging: octeon: add missing tasklet_kill in cvm_oct_tx_shutdown
Date: Sat, 12 Sep 2026 08:58:03 +0200
Message-ID: <20260912065537.217524038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ayush Mukkanwar <ayushmukkanwar@gmail.com>

[ Upstream commit b9af44b0d20b2247c4eb0ea5cfca907d643eea50 ]

The TX cleanup tasklet can be scheduled by the watchdog IRQ handler
to execute cvm_oct_tx_do_cleanup. There can be a pending tasklet in
the queue which might run after the cvm_oct_remove() frees net_device
structures, causing a use-after-free in cvm_oct_tx_do_cleanup() as it
iterates cvm_oct_device[] which is an array of netdevice pointers.
Add tasklet_kill() after free_irq() to ensure the tasklet is no longer
scheduled or running before teardown proceeds.

Fixes: 4898c560103f ("Staging: Octeon:  Free transmit SKBs in a timely manner")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260511150931.93382-1-ayushmukkanwar%40gmail.com
Signed-off-by: Ayush Mukkanwar <ayushmukkanwar@gmail.com>
Link: https://patch.msgid.link/20260615172734.42038-1-ayushmukkanwar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 1ad94c5060b52..11ed0787c83ee 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -713,4 +713,6 @@ void cvm_oct_tx_shutdown(void)
 {
 	/* Free the interrupt handler */
 	free_irq(OCTEON_IRQ_TIMER1, cvm_oct_device);
+
+	tasklet_kill(&cvm_oct_tx_cleanup_tasklet);
 }
-- 
2.53.0



