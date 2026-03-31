Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD4E36AB47;
	Tue, 31 Mar 2026 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974508; cv=none; b=WcfUzZAzhceWOK3shFOX4fAYRw4p0CjxPBoszZ/0sgyByJaKWSEc90CU152qO5kJRJ+V5X59TEAIQNFqWmNBC5PT51T8A1DGfnbNUkxK2UtuOyrYwkEGAJtBAMTEwgsoyKlAv6h5PLsd3sofHstwSlVFnZxAlCQiGBYhyRsqv0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974508; c=relaxed/simple;
	bh=i/x35riVpPCKtLKzYeV5Jy5UWuTgeCqrbaw4aH+H4yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZuXcjAhIaJuPhVxmLEhCvyxdJ1HklNDxZTKkkXjYwW8Ic8CwZo0kksGyu3JOEyfRa0Gh+6UFs2rv/HO1p+LJgipzshsCwO7Nvjx9jzblOukOxabgxnjEJ7Owdlazkx0HadBsUlDz5+a55qL8sRXllnzRifTpLEf6bUBzLNyOhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U2W1l0jH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U2W1l0jH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43951C19423;
	Tue, 31 Mar 2026 16:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974508;
	bh=i/x35riVpPCKtLKzYeV5Jy5UWuTgeCqrbaw4aH+H4yU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U2W1l0jHIIkDvgwKI3K//ga+ToZ00rkUviN8PSMIIUHW8M7kkgFXlRyG3nxo2OOcd
	 33JNhlZWExGW0a7bHFWTlu92r3ExYeezxufikDg8Yx4UOyC//Btkm9G8jlN3VOpKpr
	 NfLtwTyty0AXoilDNPCZKDrLx4SNSv2/sXWQ0dnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/175] RDMA/irdma: Remove a NOP wait_event() in irdma_modify_qp_roce()
Date: Tue, 31 Mar 2026 18:21:03 +0200
Message-ID: <20260331161732.676826933@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

[ Upstream commit 5e8f0239731a83753473b7aa91bda67bbdff5053 ]

Remove a NOP wait_event() in irdma_modify_qp_roce() which is relevant
for iWARP and likely a copy and paste artifact for RoCEv2. The wait event
is for sending a reset on a TCP connection, after the reset has been
requested in irdma_modify_qp(), which occurs only in iWarp mode.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index b9996d36358b1..cc8c6e8586252 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1364,8 +1364,6 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			roce_info->rd_en = true;
 	}
 
-	wait_event(iwqp->mod_qp_waitq, !atomic_read(&iwqp->hw_mod_qp_pend));
-
 	ibdev_dbg(&iwdev->ibdev,
 		  "VERBS: caller: %pS qp_id=%d to_ibqpstate=%d ibqpstate=%d irdma_qpstate=%d attr_mask=0x%x\n",
 		  __builtin_return_address(0), ibqp->qp_num, attr->qp_state,
-- 
2.53.0



