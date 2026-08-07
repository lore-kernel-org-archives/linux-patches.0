Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847B22E7377;
	Fri,  7 Aug 2026 15:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115026; cv=none; b=uA5YjbFHN3vVJ8a5TPAUqBnU+vqS8wpyTiZtASXtXmPowAL7EVVybdUWTXeraTgxfBvrepDwnAMvg6Qqu3qru5eD7izybKpfEWyeqCk1QttynaVH/jyG8PlOtTkSermGI2WBkRHn9bgP3WPYgm9UZtwUE/ureVrXtSEq/NvFlYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115026; c=relaxed/simple;
	bh=w0cK/7mVpd0cpEhZGmf43jdYwmOfc/+G0rhjzan45IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJpp0CkLtDWn5X5AWZLDxcHqQResiYfy6QXHv5oPZDrm9twou1OIcWZ1bNdRAMl9WdtOv7F4GAWNfoHMP1FD//OOQm/0jwiSO6xRgl/A9oo6Aoa1USESwdApW2hHqQ8n3oO7oNBYEqWCmMjxI6iUw9aY9ydwldst1OtwdKAXet8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WV8OYxXv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WV8OYxXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06211F000E9;
	Fri,  7 Aug 2026 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115025;
	bh=B6EYxY75i5yN8WOki0xW4B4fB7UaxKix8FKoS5+e6hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WV8OYxXvyrTk0srZkmM0E6H40FbLmQ/jJvb5cCxSHytBo8sfBfcf8M0SNLpfHesv6
	 tpxWuLQdsSQQ47FZMJWd4N1oNKQxbxXSrgX949UbjMOBwxgMZF9gJeXbKTcD0jhoQ6
	 NsGoZporo1y2kRnzsCjRHezdytWuCZXoEIP7ReUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 130/396] scsi: ufs: core: Avoid IRQ thread wakeup during active UIC command
Date: Fri,  7 Aug 2026 16:34:50 +0200
Message-ID: <20260807143427.110996590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

From: Peter Wang <peter.wang@mediatek.com>

[ Upstream commit 6475cfb81fc4f6175b6d15d1c205a5168dc10b46 ]

Only return IRQ_WAKE_THREAD when MCQ and ESI are not enabled and no UIC
command is active. The default UIC command timeout is 500ms, Using threaded
IRQs during an active UIC command increases the risk of timeout due to
possible preemption by other system IRQs.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260306054419.3816557-1-peter.wang@mediatek.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 8a309036f557 ("scsi: ufs: core: Revert "Delegate the interrupt service routine to a threaded IRQ handler"")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2545f7a51211b..482a9299a5894 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7190,8 +7190,12 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba)
 	struct ufs_hba *hba = __hba;
 	u32 intr_status, enabled_intr_status;
 
-	/* Move interrupt handling to thread when MCQ & ESI are not enabled */
-	if (!hba->mcq_enabled || !hba->mcq_esi_enabled)
+	/*
+	 * Handle interrupt in thread if MCQ or ESI is disabled,
+	 * and no active UIC command.
+	 */
+	if ((!hba->mcq_enabled || !hba->mcq_esi_enabled) &&
+	    !hba->active_uic_cmd)
 		return IRQ_WAKE_THREAD;
 
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
-- 
2.53.0



