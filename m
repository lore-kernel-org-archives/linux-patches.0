Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916EC1474CC;
	Tue, 21 Jul 2026 18:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657040; cv=none; b=RmRZFupIdYH9Ost3SKyQpp/HEG1N18U0UAaNd+JBePSrhNlN2fRIGalTwCq8Th4ORmjGwJCHZfT2XFto7yT6+VxMOtj0fi3MY98/kf1o46osj2YR0GQyle7IHz7Pd+qnZozytEnXXPJStILiwTf30z1AMp3aKgQSXK65AiwsmWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657040; c=relaxed/simple;
	bh=gdXGC/hTChvqkNaWJxoOgkKUmyh3j3pDOkv3Q0IT3fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaSzy2EYucXm5TVbCB1M9KneX7e5xp5XIXxFmaNbiyZJn9vS5yPk5Z9utNT/tEkBO24XLdH9xMicDt6IG+kMxI4TBaQhVTTosi4jnlFbOmlW4/rbyCIkvpI7368PwUWcbN4UVIwGnMRi9NwUTTdHFNee7RrFpiakO3zHg9wH8Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hzn1F/lA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hzn1F/lA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ABF1F000E9;
	Tue, 21 Jul 2026 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657039;
	bh=y8eRRz+pZadQ5JUMuajo+eH8YAX1J2VHKpCY7RmQnmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hzn1F/lAl0Ge6IUDgch+Z2rg6UkN/ZLF9sXw2Xg0yTlP7Vf5VUBaKvHgypoN0xW8u
	 /VIvL5g9QkdCjS2Jb+2WjQMD6VzeYDhelgg6Vea8HL8h2v8N93arK4P+VcHrSN/a+Y
	 F5AkxfYUEGhbGj1u/6a2ASrBaEGT/9kFb6Jgc56c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable <stable@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0615/1611] gpib: cb7210: Fix region leak when request_irq fails
Date: Tue, 21 Jul 2026 17:12:11 +0200
Message-ID: <20260721152529.217290950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Hongling Zeng <zenghongling@kylinos.cn>

[ Upstream commit 2eae90a457baa0048a96ed38ad93090ee38c8b2f ]

When request_irq() fails, the region allocated by request_region()
is not released. Fix this by adding an error handling path with
proper goto labels to release the region.

Fixes: e9dc69956d4d ("staging: gpib: Add Computer Boards GPIB driver")
Closes: https://lore.kernel.org/oe-kbuild-all/202605160620.ReBOadPX-lkp@intel.com/
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260518022939.16881-1-zenghongling@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 5ad284960558 ("gpib: cb7210: Fix region leak when request_irq fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/cb7210/cb7210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/gpib/cb7210/cb7210.c b/drivers/staging/gpib/cb7210/cb7210.c
index 3e2397898a9ba2..f6d9db02f03068 100644
--- a/drivers/staging/gpib/cb7210/cb7210.c
+++ b/drivers/staging/gpib/cb7210/cb7210.c
@@ -1061,6 +1061,7 @@ static int cb_isa_attach(struct gpib_board *board, const struct gpib_board_confi
 	// install interrupt handler
 	if (request_irq(config->ibirq, cb7210_interrupt, isr_flags, DRV_NAME, board)) {
 		dev_err(board->gpib_dev, "failed to obtain IRQ %d\n", config->ibirq);
+		release_region(nec7210_iobase(cb_priv), cb7210_iosize);
 		return -EBUSY;
 	}
 	cb_priv->irq = config->ibirq;
-- 
2.53.0



