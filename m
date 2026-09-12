Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A132D0C75;
	Sat, 12 Sep 2026 12:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215903; cv=none; b=Lqexiv/k7Il/+c9oxkhfmOOrST/ihpZBRN7AYhWVNO4CU4maijQQnCsk5gpdW/F8SP3gZBoIgirPqFF3dODpaxNGUFg4QLtBiXPwM6qPZXkDmFYD0Rw1NLvYBDzkjydWn3eHVL/tSlDRaOPd12MjsdRYtdA7I28jE2jP4FRlHLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215903; c=relaxed/simple;
	bh=W6QaxB/QzvM5C82odJ/OAAaZdRZctGI3yui3DcN3tbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uzL2BPF3OtJWExarw8Llc+lVEYmlDElLlLF/tjVzxQ2aw0mo+h7gEM9QZyodorpV7jvFMebMQEMiNt+E5dscZ3ZihghM3nEPdoqIseQjT30s44coGmliAKVwGOPtp7C6/8j83UgI/TpvAAlhu7wbqXRSVEIvKhUc7ofuCOz7j0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCLs32xs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCLs32xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714391F000FF;
	Sat, 12 Sep 2026 12:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215902;
	bh=EUHZtcyyG/iaiU/flM/rl/e0qr47UnORav3qgCn0HR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCLs32xs8FBjcQmdAgoyy1iTMnaDoqdlDBrTUJSYmm1DZVjSdqHSiyTx2yGQrjsDg
	 jh/vk7sF/gy8pqxtwOLY0yR+um+yLkb/EMZYZDhuIZJJ8DU9ZyqnuHuoTkoxbvDo6v
	 PA1d+hLqLF2bmCB8tebUQmt2l0G9qBHUhyo+spT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0627/1376] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
Date: Sat, 12 Sep 2026 08:50:53 +0200
Message-ID: <20260912065621.518241056@linuxfoundation.org>
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
index 9a72fec6d5ccf..a238626c40d12 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -219,6 +219,7 @@ static void erdma_free_ceq_irq(struct erdma_dev *dev, u16 ceqn)
 
 	irq_set_affinity_hint(eqc->irq.msix_vector, NULL);
 	free_irq(eqc->irq.msix_vector, eqc);
+	tasklet_kill(&eqc->tasklet);
 }
 
 static int create_eq_cmd(struct erdma_dev *dev, u32 eqn, struct erdma_eq *eq)
-- 
2.53.0



