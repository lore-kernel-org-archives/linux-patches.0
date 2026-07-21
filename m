Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1938471243;
	Tue, 21 Jul 2026 19:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660781; cv=none; b=mSSfPVyceDRtsMwWjd25JIb2z0xPm/gd/tlGPI13Z5rthNul/G8MKpL5h7UD72kUnHAvMKNEWuiwgSdwwleAb7LMOJzkVK1bYUKieznJxkADfZk76qtGkjoeiVIomtHKvap4wF81MknN0DHxUaVYuZo3qclbPC7xDWZ3nkXGHX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660781; c=relaxed/simple;
	bh=XHapLeiwSXarwqqZNat4eALcerKl4WPDXdChr+Djbkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhNlQJjorbXzL2kxZPwwrsg0B9h4WI5Yo+54d/i16LAqLF2USZS53wx4Hr/PA1QmJUyaXNCtcEkpOYZORFTPSkm5piAYX0SHwrJCy47v9Z8kH1mC0hRaKGwxoXewLN/sGBFaTaUqDgw49vR5SurQ4ap+K2ktejGYbAYTtHGuDaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGdRhUHy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGdRhUHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D201F000E9;
	Tue, 21 Jul 2026 19:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660779;
	bh=DIt/myFOkagHyZOaKSw6OjWQHPNdvOfacNJpmYlDVIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGdRhUHy9wybRiFTHbz1UNzhhuPdV4olwwdu96uWVEJjj+M80TPUQN71l1IG4nFde
	 nDuav9GIGv331NlDiOxyADrT8uqJDAoPQB6NvqSXadBUcnN0P9vCtJ4M7AreElLW5u
	 PP45dm8OXQPB3k7c5SAveC0V/FMEWV7qXD/8P5d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1066/2077] accel/ivpu: fix HWS command queue leak on registration failure
Date: Tue, 21 Jul 2026 17:12:19 +0200
Message-ID: <20260721152617.962856274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@linux.intel.com>

[ Upstream commit e7ab91e2bf01b024691d6ce488546533943e7a6b ]

A command queue is considered valid and usable by the driver only when
it has a doorbell ID assigned (db_id != 0), meaning both the FW cmdq
creation and doorbell registration completed successfully.

However, when either ivpu_register_db() or set_context_sched_properties()
fails after ivpu_hws_cmdq_init() has already created the cmdq in FW,
the command queue is left registered in FW while the driver treats it as
uninitialized (db_id remains 0). On the next submission attempt the
driver tries to register the same cmdq again, which fails because FW
already has an entry for it.

Fix by calling ivpu_jsm_hws_destroy_cmdq() on error paths to properly
unwind FW state and allow subsequent registration attempts to succeed.

Fixes: 465a3914b254 ("accel/ivpu: Add API for command queue create/destroy/submit")
Reviewed-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260611055140.948684-1-karol.wachowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index 521931d1f7fcaf..b24f31a8b5672b 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -208,9 +208,9 @@ static int ivpu_hws_cmdq_init(struct ivpu_file_priv *file_priv, struct ivpu_cmdq
 	ret = ivpu_jsm_hws_set_context_sched_properties(vdev, file_priv->ctx.id, cmdq->id,
 							priority);
 	if (ret)
-		return ret;
+		ivpu_jsm_hws_destroy_cmdq(vdev, file_priv->ctx.id, cmdq->id);
 
-	return 0;
+	return ret;
 }
 
 static int ivpu_register_db(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cmdq)
@@ -281,10 +281,10 @@ static int ivpu_cmdq_register(struct ivpu_file_priv *file_priv, struct ivpu_cmdq
 	}
 
 	ret = ivpu_register_db(file_priv, cmdq);
-	if (ret)
-		return ret;
+	if (ret && vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
+		ivpu_jsm_hws_destroy_cmdq(vdev, file_priv->ctx.id, cmdq->id);
 
-	return 0;
+	return ret;
 }
 
 static int ivpu_cmdq_unregister(struct ivpu_file_priv *file_priv, struct ivpu_cmdq *cmdq)
-- 
2.53.0



