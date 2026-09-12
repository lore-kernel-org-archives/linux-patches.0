Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222063AEF51;
	Sat, 12 Sep 2026 12:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215101; cv=none; b=iMH9zn+LN/SbqvMd8/65vDGUuzeSHc+7DfeCW2KUBiwJQbZFMjFwGV/sP0AwNsdX+FYX49Hw6gTjG93NWLEpnqjlsdn45U9AbCklEb+bTG7B2YINp3TimXET7U4wvgDcHo8ZvwEvrcr+z5G28QPgkco8ZqpRtoSA6oJg802h9qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215101; c=relaxed/simple;
	bh=dGYgbJjKvcvpg+D6AKC9Q3PuL5l/KcYj/89DTbl+ObA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdq5rbIrG88ITOAnLUCynYl65isyarWrgVOsFLhmWGN6OecY7aHaQ09gbj/9/TO+7il0Ipa+gE6eF+7TIg1I9i7GE8yduUkBEZWcf+ljJA8WrMMK3yW34kKJwjckV7nSNgmAFeE2JM/rfGM8PDYFbCXpRZ9Pr17ajpkq5sM+gWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5H59bQL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5H59bQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99CB1F000FF;
	Sat, 12 Sep 2026 12:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215100;
	bh=+YbdWh5jI/uBH6OeYXm5TZRJZSaku7afdt/ryoc+DSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5H59bQLaPBrTCLmCkyw/4znsxnVf+FSqySUN++4DwjAmCCgtexDf7Kr9S4SJlJtt
	 WveLZdzJ9IrlzB30ZlGfl554sHrXcGQFVUrKZDXIpFp3k3KyJgyKcoBTBWGuvGmpKy
	 eX3SM3iH4BOaoaylmXiIP3RLnKQJs5l6D7sUnmIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ayush Mukkanwar <ayushmukkanwar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0425/1376] staging: octeon: add missing tasklet_kill in cvm_oct_tx_shutdown
Date: Sat, 12 Sep 2026 08:47:31 +0200
Message-ID: <20260912065617.007914799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bbf33b88bb7c2..e54b4a413dc40 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -711,4 +711,6 @@ void cvm_oct_tx_shutdown(void)
 {
 	/* Free the interrupt handler */
 	free_irq(OCTEON_IRQ_TIMER1, cvm_oct_device);
+
+	tasklet_kill(&cvm_oct_tx_cleanup_tasklet);
 }
-- 
2.53.0



