Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E74330B14;
	Sat, 12 Sep 2026 14:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223664; cv=none; b=ifkUQSj6OCZqq5eblhbkRRYWpyOm9yUcnhHl8whq6/+Yla0DA5Faf4HqJETQfWsHdq0CIgMEh+7w39zEpXbIk6dayBkyO2VPq4F8UjX5vTpGTUFqnge7iPSx88iuahNPf998EniIJqgx79fr/AUTW/VQ3HYgXGDmrwubDq+Ve+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223664; c=relaxed/simple;
	bh=pheyAIWI6vX0jp99I9oB3aVxfI7BXh1Mn4Ht8wN0YLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPxQfOa7anARFz3fiUiS5OYCxT2G7YEn3u092L/3GjCG3XuMR/H8XPmNU2MUJWMhlRsvMzlg/ACulzNOzM86ztWIrC1DZurqEZKDF33OAkJDgXhwoVGdyL3lTdVQOkUvEBNO5qPkFl8qRzkjQwOeYdWKhBbFoC+Xuy/5tOc+P/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PmYfsCFM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PmYfsCFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190DC1F00898;
	Sat, 12 Sep 2026 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223663;
	bh=N8YXIbEZm9mj2DcfIRY9/0vmipc1eERg1q9/KpTMe+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PmYfsCFM9QXMX0CYTFLWdN5U4ErL47o5aoYIxtaaOz3yLPGuKAX0fzfny2SV25us0
	 96Y6WiZPn7y9d14L0GzFGCzgiiu0glymcKd8MAlSSoOOhWsIXEenj0iUM6HCw90582
	 T5LjK99mp9mvMvqMigobU15x9376lE5bH+2+OpM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0835/1424] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
Date: Sat, 12 Sep 2026 08:54:27 +0200
Message-ID: <20260912065626.007858990@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 0ca79979384f031d710c4b3bae065dcb5d95aca3 ]

Each CEQ interrupt handler only schedules eqc->tasklet. The tasklet calls
erdma_ceq_completion_handler(), which reads the DMA-coherent EQ ring
through get_next_valid_eqe() and updates eq->dbrec through notify_eq().

erdma_ceqs_uninit() frees each CEQ IRQ and then destroys its EQ.
free_irq() prevents another hard IRQ and waits for an in-flight handler,
but it does not drain a tasklet that the handler already scheduled. The
tasklet can therefore access eq->qbuf or eq->dbrec after
erdma_eq_destroy() frees them.

Clearing ceq_cb->ready does not synchronize with a tasklet that already
passed the check at the start of erdma_ceq_completion_handler().

Kill the tasklet after free_irq(), when no handler can schedule it again,
and before erdma_ceq_uninit_one() releases the EQ buffers.

Fixes: f2a0a630b953 ("RDMA/erdma: Add event queue implementation")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260721082545.47395-1-mhun512@gmail.com
Acked-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/erdma/erdma_eq.c b/drivers/infiniband/hw/erdma/erdma_eq.c
index ea47cb21fdb8c..364bddbadd37a 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -204,6 +204,7 @@ static void erdma_free_ceq_irq(struct erdma_dev *dev, u16 ceqn)
 
 	irq_set_affinity_hint(eqc->irq.msix_vector, NULL);
 	free_irq(eqc->irq.msix_vector, eqc);
+	tasklet_kill(&eqc->tasklet);
 }
 
 static int create_eq_cmd(struct erdma_dev *dev, u32 eqn, struct erdma_eq *eq)
-- 
2.53.0



