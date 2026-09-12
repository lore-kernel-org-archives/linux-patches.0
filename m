Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B409309EEB;
	Sat, 12 Sep 2026 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229191; cv=none; b=XrSUruB3J+cEnEWLkhiqm8+AkxW6mm1n8S6a4C4X4ZThWx967y6Puh7CONsmYFTleqCDHpzSGiW88JpuQUqUr70CTK8RvNXpaPzE4EsQoovpe1PNW5YdFMRHl6JHQwKnZMote1PjIUadyQC7kgaCf4bem/UPpsw2b87DyeqP4gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229191; c=relaxed/simple;
	bh=011sTEpLNVbpLIR/nbXHGuBklLAp8X0kXn3u6k2O1u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaZYCsfiPi4xhBOwWacLuZqkPMGempeZtvJDf1hlxA8ehW6wU4gijGhSMY51weFiemE0QvIFMcNXFHXcRXXfopFomY0k/xjWk4UyR67M33lTUW9KPcp5w0Nkq4wvHCdaBJfpodmpvvDCzclG0vMWpdTiGomAb1GARbIivb+Zo+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXSJvO4U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXSJvO4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8D21F00893;
	Sat, 12 Sep 2026 16:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229186;
	bh=XLy2KbhYAk6zNd0keIX7vJiZAefUf1X4kAevMUiYnMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uXSJvO4U4+DptSCQT75XJLQWgw+l0O+i7si6HT+neKj+8QsfkRfO7qJuv1umDftdc
	 ItFpVQf/KKW7JI6YZ/ndCN49A0t7hEoVZaNtC1Ah7zYTOMFiMnGhLQeoqFpyuRCf2z
	 d20rBdYaoE9qFUM2nK0Dfiww8UpJKDrPflkd2NNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0538/1191] staging: octeon: add missing tasklet_kill in cvm_oct_tx_shutdown
Date: Sat, 12 Sep 2026 08:54:26 +0200
Message-ID: <20260912065600.333534051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a36e36701c743..9244bccc7afb9 100644
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



