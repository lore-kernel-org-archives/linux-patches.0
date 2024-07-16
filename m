Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2B11DDCE;
	Tue, 16 Jul 2024 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145673; cv=none; b=T6d26YPjhpxA0nE7qlHOWsgxWUOIpee3pr8gO0FxLZyO4NXTeGtio+IOu3fyA6kQ9UnoQFUZoJSB+zIFz7AfivZhu9tSIzCFPQ6kJ1Ab6DcS/zad9lQO+YMql7TIqjFOObtqZnWWj3m9HyKrT2sjevWsyBiSJjh9IVjzTbom5ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145673; c=relaxed/simple;
	bh=XgnCaaJvpXLJuY8VrMiRSCOr4i7sssUfmk0/uSUnKQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqG5ERRoYury+T11W2xKm8L1nbc6DfNjQX34AfPPXeaa0cGSwWDMI+7wAMJt+efMHZeWjyNipcNgZwHaWj0z5vU4+ipvG9OyANUTzA8hoouU0e8k3IbEbECuST1VJlDAN4ZQiMLnz+oRzntOcImV33hl2j+CRmt6nECn+rQFKfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGerbZnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGerbZnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71767C116B1;
	Tue, 16 Jul 2024 16:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145672;
	bh=XgnCaaJvpXLJuY8VrMiRSCOr4i7sssUfmk0/uSUnKQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGerbZnfJL5NaQyQqGW4CxOEqOF3GcZk3FabTlxFpbVvxa8nTz539k7/o6AL04Mpj
	 R6oiVezIrHrVihZqDL46mylP7M5Up5QMTv0fH3m6yP6x8hGFuMbZrSHcYRFclraB1x
	 RLBH27IxQhe4oAoDncf2faJ5wY7Gnngf7qaUY5RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kelvin Kang <kelvin.kang@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Tony Brelinski <tony.brelinski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/121] i40e: fix: remove needless retries of NVM update
Date: Tue, 16 Jul 2024 17:31:47 +0200
Message-ID: <20240716152753.058632248@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

[ Upstream commit 8b9b59e27aa88ba133fbac85def3f8be67f2d5a8 ]

Remove wrong EIO to EGAIN conversion and pass all errors as is.

After commit 230f3d53a547 ("i40e: remove i40e_status"), which should only
replace F/W specific error codes with Linux kernel generic, all EIO errors
suddenly started to be converted into EAGAIN which leads nvmupdate to retry
until it timeouts and sometimes fails after more than 20 minutes in the
middle of NVM update, so NVM becomes corrupted.

The bug affects users only at the time when they try to update NVM, and
only F/W versions that generate errors while nvmupdate. For example, X710DA2
with 0x8000ECB7 F/W is affected, but there are probably more...

Command for reproduction is just NVM update:
 ./nvmupdate64

In the log instead of:
 i40e_nvmupd_exec_aq err I40E_ERR_ADMIN_QUEUE_ERROR aq_err I40E_AQ_RC_ENOMEM)
appears:
 i40e_nvmupd_exec_aq err -EIO aq_err I40E_AQ_RC_ENOMEM
 i40e: eeprom check failed (-5), Tx/Rx traffic disabled

The problematic code did silently convert EIO into EAGAIN which forced
nvmupdate to ignore EAGAIN error and retry the same operation until timeout.
That's why NVM update takes 20+ minutes to finish with the fail in the end.

Fixes: 230f3d53a547 ("i40e: remove i40e_status")
Co-developed-by: Kelvin Kang <kelvin.kang@intel.com>
Signed-off-by: Kelvin Kang <kelvin.kang@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Tony Brelinski <tony.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20240710224455.188502-1-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_adminq.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_adminq.h b/drivers/net/ethernet/intel/i40e/i40e_adminq.h
index 80125bea80a2a..290c23cec2fca 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_adminq.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_adminq.h
@@ -116,10 +116,6 @@ static inline int i40e_aq_rc_to_posix(int aq_ret, int aq_rc)
 		-EFBIG,      /* I40E_AQ_RC_EFBIG */
 	};
 
-	/* aq_rc is invalid if AQ timed out */
-	if (aq_ret == -EIO)
-		return -EAGAIN;
-
 	if (!((u32)aq_rc < (sizeof(aq_to_posix) / sizeof((aq_to_posix)[0]))))
 		return -ERANGE;
 
-- 
2.43.0



