Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5784E15AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2F9C433C8;
	Wed,  9 Aug 2023 10:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578035;
	bh=9VHrt+L8rNe4Qpv9B12Cut+rRuGtchd64uTYLUE4csY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnW9+mYp7fZcagP1sSlEDcTNkHSfZbd8sIbyqAFeBPEvRfyC7g4Peta5qjFcGUgrN
	 38oa9fyDGpHi58mRNsfMvMdvD9Ydqq4MksRSxJSuI+fzTP8v/PGoZNn8qWee4peim/
	 5CMDmlQtKs6A2VAB0w9mpHCbLiMOlKk57VfaPYtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 065/165] octeon_ep: initialize mbox mutexes
Date: Wed,  9 Aug 2023 12:39:56 +0200
Message-ID: <20230809103644.948716568@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 611e1b016c7beceec5ae82ac62d4a7ca224c8f9d ]

The two mbox-related mutexes are destroyed in octep_ctrl_mbox_uninit(),
but the corresponding mutex_init calls were missing.
A "DEBUG_LOCKS_WARN_ON(lock->magic != lock)" warning was emitted with
CONFIG_DEBUG_MUTEXES on.

Initialize the two mutexes in octep_ctrl_mbox_init().

Fixes: 577f0d1b1c5f ("octeon_ep: add separate mailbox command and response queues")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20230729151516.24153-1-mschmidt@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
index 035ead7935c74..dab61cc1acb57 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
@@ -98,6 +98,9 @@ int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
 	writeq(OCTEP_CTRL_MBOX_STATUS_INIT,
 	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS(mbox->barmem));
 
+	mutex_init(&mbox->h2fq_lock);
+	mutex_init(&mbox->f2hq_lock);
+
 	mbox->h2fq.sz = readl(OCTEP_CTRL_MBOX_H2FQ_SZ(mbox->barmem));
 	mbox->h2fq.hw_prod = OCTEP_CTRL_MBOX_H2FQ_PROD(mbox->barmem);
 	mbox->h2fq.hw_cons = OCTEP_CTRL_MBOX_H2FQ_CONS(mbox->barmem);
-- 
2.40.1



