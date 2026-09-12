Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3099E29B799;
	Sat, 12 Sep 2026 07:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199406; cv=none; b=n5TzkRw1tV4WANRKEXbyB5ockr/cH11X3xnZPCmmTfFPu+0VT/Ld4YI/1wHHMT1HmisD8hn97/vQ/8fnV7v3TRGoHSriAgFgGi4ydztF9Aeul4zB+lgohQlZ8KbclaKdoglIJeXq2o2zSlb5l4XiL3CjBlXApw9jJMK4xtK2Lpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199406; c=relaxed/simple;
	bh=CMj+I58ztNTEnrxk2xroi6Qm1qs/kxhJdN2bQxfbMzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buDW3QIt1KXPae9Usouo+3SWhutO6dNlimdgqrRHMnSlRJDY+nnvBehWFJNOtVxniOSV4eFVeNbUAA+BuRQfgu/0aVVwNgIOxN6LECzaUm+DpmMYyfhHnVms+qEOBEwLvHu/cGr6iXDlbdiCfQcdF75h65iAaO5nm+EZ7OJf0UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GB6UUaG8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GB6UUaG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347711F000FF;
	Sat, 12 Sep 2026 07:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199405;
	bh=uulzP76bgKco57AOid8jPboyhv59wkhHblH+DYaLTIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GB6UUaG8lzPpBliJ1FzGX/T+nF6jFAzG+5K2YDtyz4p+cm/U0THCuZPRPx3ZzXmlC
	 CK7+gOSzY4AN1EO1QdmH2i4n1jzWQYyT9SyNBp0RWHUnEvuSpCOdAfUjKPJmMLU2Y8
	 qlWUsD6zxqj4nxtleofmgv3Kr5lqCiZQdSqsp9GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0577/1815] RDMA/erdma: Fix CEQ tasklet use-after-free on removal
Date: Sat, 12 Sep 2026 08:38:47 +0200
Message-ID: <20260912065702.425736102@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index d5b9d19882b2a..a8784e07acd6b 100644
--- a/drivers/infiniband/hw/erdma/erdma_eq.c
+++ b/drivers/infiniband/hw/erdma/erdma_eq.c
@@ -220,6 +220,7 @@ static void erdma_free_ceq_irq(struct erdma_dev *dev, u16 ceqn)
 
 	irq_set_affinity_hint(eqc->irq.msix_vector, NULL);
 	free_irq(eqc->irq.msix_vector, eqc);
+	tasklet_kill(&eqc->tasklet);
 }
 
 static int create_eq_cmd(struct erdma_dev *dev, u32 eqn, struct erdma_eq *eq)
-- 
2.53.0



