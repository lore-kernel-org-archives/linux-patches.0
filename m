Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4032C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF581C433D2;
	Tue,  7 Feb 2023 13:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775475;
	bh=DWj+O7moT18+ZTe+Ogcv2iDKxrxaudaFhD+wXevmfXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PI6wj1tX759LawGQwwQdSb60ivWrez9yn6WHE207bfTNzqJex2eMJymyrXsm+1jUL
	 R00IuizH6G4PdJr+WMt0CnCcXWsTctv8wQ/B4ET6CUu1CVqwRD5X3fzap1X15PEC5q
	 S7mflOixXqfoi0z8D3wlQK63qlnqpX5NEHuyxL/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/120] scsi: target: core: Fix warning on RT kernels
Date: Tue,  7 Feb 2023 13:57:04 +0100
Message-Id: <20230207125621.028143746@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 84ed64b1a7a7fcd507598dee7708c1f225123711 ]

Calling spin_lock_irqsave() does not disable the interrupts on realtime
kernels, remove the warning and replace assert_spin_locked() with
lockdep_assert_held().

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230110125310.55884-1-mlombard@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_tmr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index bac111456fa1..2b95b4550a63 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -73,8 +73,8 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 {
 	struct se_session *sess = se_cmd->se_sess;
 
-	assert_spin_locked(&sess->sess_cmd_lock);
-	WARN_ON_ONCE(!irqs_disabled());
+	lockdep_assert_held(&sess->sess_cmd_lock);
+
 	/*
 	 * If command already reached CMD_T_COMPLETE state within
 	 * target_complete_cmd() or CMD_T_FABRIC_STOP due to shutdown,
-- 
2.39.0



