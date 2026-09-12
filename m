Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B233D41B355;
	Sat, 12 Sep 2026 09:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206635; cv=none; b=CdLf0IhPiFc/P/Mbh5gMYD7QOMBSELLWaXuAbjZQ/4+crVbNDHI6WT9i3f9osyUeql1dom6bJ/FLkdypBq3+MgFU2yr1Pw+4AyG9AnVKV2aFhTDWL+hoXRsBkEmGnKKTQhaOtd6KYPwtvFvTFkPn9y4bd9z48SPubuvYJYy90Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206635; c=relaxed/simple;
	bh=3MJHeWz9CYYkOs+T8f/h1WSIDa0e6KV0Eq8+1S6oVN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDMtPvZAS37Dp+dtMkqBYTgDLqWkvDjT3e+Lw9c0Ttv4yXhqtYEAw+1l3EcQ2XOgFJ9pX1Nok1FXZZCBqz7guiTfUbzfpXPI/sRptS6q4bwCuf8CQhr4OOdVOIVkpWCM5DFpWbDw/8eVfpvxCnh6MQ10B57rW4WqgWYCr5b8pv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvZiEqIx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvZiEqIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4EF1F000FF;
	Sat, 12 Sep 2026 09:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206633;
	bh=4hL27pYDbgSr/rMTlrmwFnV5PMSqnuMJAj02c/BZQE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvZiEqIxAkDqj6zD6aGZGneAWHp2C8AT2qLzx4B9PYpXxxS7/OTIgdjGfqXh4dNv/
	 +gT9OQf/igTanxwuLE0QGSED83Pv/MVDPZJPWWgUB9bwHraZWBUHcawtuMAsn+C6YB
	 tqYBcy3jqX+2gghcaHDxY6gqjQo7+T0xOv9R+6b4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0230/1518] staging: octeon: add missing tasklet_kill in cvm_oct_tx_shutdown
Date: Sat, 12 Sep 2026 08:39:59 +0200
Message-ID: <20260912065628.689916938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index f5bbedac6a653..1b30fe1bcf43b 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -670,4 +670,6 @@ void cvm_oct_tx_shutdown(void)
 {
 	/* Free the interrupt handler */
 	free_irq(OCTEON_IRQ_TIMER1, cvm_oct_device);
+
+	tasklet_kill(&cvm_oct_tx_cleanup_tasklet);
 }
-- 
2.53.0



