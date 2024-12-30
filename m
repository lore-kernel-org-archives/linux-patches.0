Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70E915E8B;
	Mon, 30 Dec 2024 15:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574199; cv=none; b=aVofJqEBsc0QNqerMBZ2lQVgDSb1xlBiSZhqiy4N3FCodAAfycZ/eVIuuzmEf9wuI+bqJglV962N0A0TyY6N0uM7Ske14ZArmD5kk1p2RAPnE2zO25L2txY9OiOymE7T/XvYHzajUWpAmXnVFN0YaIMYP7do0mB0T12Bwa0sRxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574199; c=relaxed/simple;
	bh=K8+6JtIHjyBBxajcT6U8MVYAT7TdDMhjqEmy2eQ3x4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGZW7eq67g1oCQBke0vxKPAnpnhR1keZnRUaq51bZEjC7RNm4EB5K3jFQ6uzhQEDUCpvkPqMPN8fPFxXXPYKxJo+3WC2G2Lh4ww9qjp7M1CFVDxnF4wQ0N8kEHZs19gkkLp8FRifdWb124QKF7F7P0M2V4vYJ0JAK8zWYqkSP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f7a0dKsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f7a0dKsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABD8C4CED0;
	Mon, 30 Dec 2024 15:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574198;
	bh=K8+6JtIHjyBBxajcT6U8MVYAT7TdDMhjqEmy2eQ3x4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7a0dKsWAJn/SAwmwz0bZ0AboZk6ZNSGdAtZPvab1GXhWvZsbQMLxojWZl8ySOIZS
	 zkGrnSdwA9x/ri7eZdL58XFDTPoaAP2dsjaHctwM/AL5O8hVwXeg5WYJMPPOZ+Xi7f
	 i2YQmsxfbE3FgM8PygsEGCuJGP7l8VvPFCukjajA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/114] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Mon, 30 Dec 2024 16:43:03 +0100
Message-ID: <20241230154220.642936572@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ed5046593fda..16ac2267c71e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7041,11 +7041,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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
@@ -7135,6 +7136,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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



