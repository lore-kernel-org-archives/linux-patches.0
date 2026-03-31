Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062CB3016E3;
	Tue, 31 Mar 2026 17:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976557; cv=none; b=ddSri3xvdX69Gntf61cumn6Pcae4IPZs7UZffTZszEHDZwzzP9lBwLjiMmFTp5HJgX2iIhlugZatq0AgRA6Lw+SGW6ZURJ06MK/NJ0tdBHCXAnrERDGP/v2RcMtEZUOHbTu7Dq9wQmz0nPDi/Nr6YOCU3pgfxVCRFre6qZ1Zxkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976557; c=relaxed/simple;
	bh=/eBJ28zVPr4+1PGEAqeXYUHUtRNmklR65e/FZtKvl3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soSc06ml0c4CaYpeTxaWLzdoQ58e1Y9fedOvYKwolbjb4cUeW5uFVZpDnnx0BNLdUkak50Hh7Y6jXE7HwoKB2HCvyd3Jsq4ABg5/TqocknIGbnC/HloszJ4JN4lUDk1DBwMUG5uUN7K/6QZNG/nAeeY3dH58cwO3E97biO1zLvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hmk+OFeG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hmk+OFeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93334C19423;
	Tue, 31 Mar 2026 17:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976556;
	bh=/eBJ28zVPr4+1PGEAqeXYUHUtRNmklR65e/FZtKvl3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hmk+OFeGUUGGcp7LU/jy8wt1PUjEygYu45huhvAu7TbLzefUVfP2OcBxwz2/tk7fr
	 qZthQSzFVzVGUjV3s0GQyRw5coO1NyAhiKGjaBfiRuqxihwdCiTVh1ZceHaTWn6lFt
	 i0rIFf1JTpRyqI/bCUg3I1qbvqQELg2u/mJe538Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/309] RDMA/efa: Fix possible deadlock
Date: Tue, 31 Mar 2026 18:20:42 +0200
Message-ID: <20260331161758.592504301@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 0f2055db7b630559870afb40fc84490816ab8ec5 ]

In the error path for efa_com_alloc_comp_ctx() the semaphore assigned to
&aq->avail_cmds is not released.

Detected by Smatch:
drivers/infiniband/hw/efa/efa_com.c:662 efa_com_cmd_exec() warn:
inconsistent returns '&aq->avail_cmds'

Add release for &aq->avail_cmds in efa_com_alloc_comp_ctx() error path.

Fixes: ef3b06742c8a2 ("RDMA/efa: Fix use of completion ctx after free")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260314045730.1143862-1-ethantidmore06@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_com.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/efa/efa_com.c b/drivers/infiniband/hw/efa/efa_com.c
index 56caba612139f..e97b5f0d70038 100644
--- a/drivers/infiniband/hw/efa/efa_com.c
+++ b/drivers/infiniband/hw/efa/efa_com.c
@@ -629,6 +629,7 @@ int efa_com_cmd_exec(struct efa_com_admin_queue *aq,
 	comp_ctx = efa_com_alloc_comp_ctx(aq);
 	if (!comp_ctx) {
 		clear_bit(EFA_AQ_STATE_RUNNING_BIT, &aq->state);
+		up(&aq->avail_cmds);
 		return -EINVAL;
 	}
 
-- 
2.53.0



