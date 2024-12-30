Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009621ABED9;
	Mon, 30 Dec 2024 15:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573574; cv=none; b=NhVd1ZwUalaz+aS15zRE2JtfRq6fqLQqQmLWUX6Z7K+lfF4jTex6nW8bEJXOdQ2LGddmehW3vh4yMiBxdMl3wP17XPDFjwNE0KyvEEEEanTBbeqJ+4ZQqk5OLKknfTEhtZQ2uD1gkkUBRtD9xo5YZFXOQcY8m45KcfcXgfc6bKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573574; c=relaxed/simple;
	bh=pqontM9Rb2DqxQkcgWjZ48E9sET/qAFkq8KjCQ0bI2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWyIHprlmwURomrnhTPpLjqAw4LvyLleNW9HaHafd48Gp7tKP9YdXToP6GVkM8pVthDdvIuTkB75vcdbHvBJMRH7Pu+DC5KxqGCPhUqRJegac91vr+6RtyblSNQH28APzYNnVDsTjUCu6FbPkljvIKtDmo6TAG4NWBPf2UKymD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpmiyAcm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpmiyAcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B78C4CED0;
	Mon, 30 Dec 2024 15:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573573;
	bh=pqontM9Rb2DqxQkcgWjZ48E9sET/qAFkq8KjCQ0bI2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpmiyAcmkvoyWZxqJXYPTyCQ3wHXGLGW0HQppA3w8IIHFSRwVM+cP9jgWb5T59N7c
	 iWUV8wlw+blKffB/IVL4R9K1w/7QJkA1tYgPx10bEM3WPEqw5Y2tRiyULJX21MvPP1
	 1Z7hzy1dsF4uzM+2XVTsSDPRrd5duTxD3ANdf2jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/60] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Mon, 30 Dec 2024 16:42:44 +0100
Message-ID: <20241230154208.577290943@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 03fcaf735939..5c13358416c4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7061,11 +7061,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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
@@ -7155,6 +7156,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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



