Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248B82AE68;
	Mon, 30 Dec 2024 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573825; cv=none; b=iyn9vG3XCaDmIonpnJ2QVE3bNWhQ/RygeXp0vbSNrrjF35ghMXY3gQ/UPIXcUhncdcVYmwGBudRHSZr0oXCfkcl5WmS9cl0ZzwtfY7FvL5ETRXKJ3P5OMN8PI/tox6f5f/OoUa/KXYQ0jmFIAYHdJI5wMo9zhyXS+AaaDjUIc1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573825; c=relaxed/simple;
	bh=d6xVKtxC+EiUhPKBbIHOpQH9+UDevNRT1F/xz1BLflY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZxtCXNELNT0HVOpkaxSSt0K9p6I2gDBKmJRUWaahs6Ix87LOnu23mtt9m3dfN3W64SVxBAyNCZyEtb6PaK/8JezdwRcMXexKS3Kr5vtnjmySPSxp1GMaUIHT+/trclX7p5dFt98XbbAkOAUzKfsdl4aDCKYAwgqT6QrqNVTvZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w15QUEN5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w15QUEN5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CCFC4CED0;
	Mon, 30 Dec 2024 15:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573825;
	bh=d6xVKtxC+EiUhPKBbIHOpQH9+UDevNRT1F/xz1BLflY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w15QUEN5QtN+fb/uvTZlG/TDxM41rpeE9U38iOiSfZqy2OVdKG0kRMW1kd6rDp6JU
	 QTwd8AWbgPycjoybTgW7nlayBcynnOBP4aS8imgqw8YHY2yh7bImPxT7D9xU/v9DmG
	 0N735WqiT4Pkejf7nuwCuZsNqs56NDBz5EnO5Mbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 45/86] scsi: mpt3sas: Diag-Reset when Doorbell-In-Use bit is set during driver load time
Date: Mon, 30 Dec 2024 16:42:53 +0100
Message-ID: <20241230154213.426670877@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8acf586dc8b2..a5d12b95fbd0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -7050,11 +7050,12 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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
@@ -7144,6 +7145,10 @@ _base_handshake_req_reply_wait(struct MPT3SAS_ADAPTER *ioc, int request_bytes,
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



