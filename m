Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F3B14A617;
	Mon,  6 Jan 2025 15:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178277; cv=none; b=PfHxuVj4qZ3dEpoxvf8XYrpnTR6ron7qB9gWHfKkgZMz62IULR4AIE95Peyt3eRiaeG3581LXoe/IX7A0GfdCUTPqgPlrKKtE08o7oi5NsNPEjVoI3hrIyaBEL340PvYNu0nVzX1kLSwl3UtHhwBKm0L8K50CY1WyI/KCHNVwEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178277; c=relaxed/simple;
	bh=WJ9HQzIZABhFuiV0mb2jNMfBMyZ3BvNYjaWmt/7bJ0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cw6E5fgL+WlFdGEnFrpwNGLzuTDrg+C+HFIfvkuSRFmRFW8P9VrVUwB0Tn3z8ZpH8W5TwA2xlCEHz/IZ2bCgM8mqM6lObhLk438JOjE10MtRaZ5bGfjw8rgiGYpnE26AGpYhBp5oP7R6YPn/xsjJNqtnlBZXmIT7bwsnHWBSB6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3YoCSW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3YoCSW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B9BC4CEDF;
	Mon,  6 Jan 2025 15:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178277;
	bh=WJ9HQzIZABhFuiV0mb2jNMfBMyZ3BvNYjaWmt/7bJ0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3YoCSW6zH3YTBJEjLmcH1xAIdPr+fy64uF6n8DHM1EaQTridqthwNM/6WM8YZsSa
	 C8NBOFbTUORG0ViU+B/1MAgb0hBhOHlmMbXWHH1qLs5ADWpIcw8GBZBu20427WREti
	 rtIruwJ/Y+JiX+MbnJgWIhtroHCJQqAvZ7MQnJ3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/138] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Mon,  6 Jan 2025 16:16:29 +0100
Message-ID: <20250106151135.695148411@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 3f5eb062e8aa335643181c480e6c590c6cedfd22 ]

Issue a Diag-Reset when the "Doorbell-In-Use" bit is set during the
driver load/initialization.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110173341.11595-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 53528711dac1..768635de93da 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -6008,11 +6008,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 	int i;
 	u8 failed;
 	__le32 *mfp;
+	int ret_val;
 
 	/* make sure doorbell is not in use */
 	if ((ioc->base_readl_ext_retry(&ioc->chip->Doorbell) & MPI2_DOORBELL_USED)) {
 		ioc_err(ioc, "doorbell is in use (line=%d)\n", __LINE__);
-		return -EFAULT;
+		goto doorbell_diag_reset;
 	}
 
 	/* clear pending doorbell interrupts from previous state changes */
@@ -6102,6 +6103,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
 			    le32_to_cpu(mfp[i]));
 	}
 	return 0;
+
+doorbell_diag_reset:
+	ret_val = _base_diag_reset(ioc);
+	return ret_val;
 }
 
 /**
-- 
2.39.5



