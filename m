Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A57B2E9721;
	Mon, 13 Oct 2025 15:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369044; cv=none; b=bkLL5z0QNtCpF1DjGulmuRaVDyrLD8UzGJXs4a7Qcb2eEAkjdvcRFg7wljDPpYJXI7GC8gPyHNmwvnwLWb+iAzZ8KoxEo7bqYS0f8N5e53S7Ta7qEFTGH6txhrBLp88Wcfbuc/0hmPr79h4lJawiY0olh1/n0n/OepWAIKQc3oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369044; c=relaxed/simple;
	bh=Is/iS5LzG0GIizmBLWnmeTWQvnG6jT8sfL7VgOlq97c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fweDLyTqPA3SKjF7zfLiu2L13XJoys5EndLxm09cdUrsF2aQ8PHhSQjgqWus6TxX5vh21tQyFzjgsvLOkPEUJYM09GSz7wx3ltzQxL44FxCaShHz4kEqbTrFcsAo+zNeSD6APTMcVA/Dg7kgqfAUXK/5O4v9GNvD6lbMDsm79TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3P+jdbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3P+jdbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C061DC4CEE7;
	Mon, 13 Oct 2025 15:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369044;
	bh=Is/iS5LzG0GIizmBLWnmeTWQvnG6jT8sfL7VgOlq97c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3P+jdbeB7/zqFtNWlsfXbI62w+kZCebPUFuro6bFFzFmY69s3RPDJT020DlzDASp
	 EI3BuouePF98fOqa7FiZ34Zi6iNhJMnRfSQh4XV7R7EWpKJyjZV1J/vC+3MeUuXsqZ
	 6aAuXi95Geq3kKNEZ1IIGO0GxscDf+xo6HXs+DEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 108/563] irqchip/gic-v5: Fix loop in gicv5_its_create_itt_two_level() cleanup path
Date: Mon, 13 Oct 2025 16:39:29 +0200
Message-ID: <20251013144415.206585120@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit bfcd1fdaae92faa8cae880eb4c3aaaa60c54bf0d ]

The "i" variable in gicv5_its_create_itt_two_level() needs to be signed
otherwise it can cause a forever loop in the function's cleanup path.

[ lpieralisi: Reworded commit message ]

Fixes: 57d72196dfc8 ("irqchip/gic-v5: Add GICv5 ITS support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/all/20250908082745.113718-3-lpieralisi@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-its.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v5-its.c b/drivers/irqchip/irq-gic-v5-its.c
index 9290ac741949c..4701ef62b8b27 100644
--- a/drivers/irqchip/irq-gic-v5-its.c
+++ b/drivers/irqchip/irq-gic-v5-its.c
@@ -191,9 +191,9 @@ static int gicv5_its_create_itt_two_level(struct gicv5_its_chip_data *its,
 					  unsigned int num_events)
 {
 	unsigned int l1_bits, l2_bits, span, events_per_l2_table;
-	unsigned int i, complete_tables, final_span, num_ents;
+	unsigned int complete_tables, final_span, num_ents;
 	__le64 *itt_l1, *itt_l2, **l2ptrs;
-	int ret;
+	int i, ret;
 	u64 val;
 
 	ret = gicv5_its_l2sz_to_l2_bits(itt_l2sz);
-- 
2.51.0



