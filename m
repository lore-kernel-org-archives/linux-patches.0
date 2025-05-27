Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DF3266592;
	Tue, 27 May 2025 17:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365202; cv=none; b=V34G5mNwddB5jpfMrfoW+QBrjYCsfFZJBaJCpTCIO8ERgaErXrPkI672q+z4nvF2MFWIK/o225YGauRb6ajqY+ZCM052YV9qdGXUqUGc2H0TTtPj2JVBCz5AW9eU5bmx5DUPI9xiDnyl6L9GLzaAurQuhubjQdX31BIWePy6O08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365202; c=relaxed/simple;
	bh=SzQfNzvcZ4dQDf/L0eP5JAYPtlO3a/Yb3wqkug7E9I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auUsL6OjvsiHJpLpHZ82L/TiddLX/0Fv1PnG7X7T8gtKT+uewDqQhlBTr0XZc9WcGrdwMRun35FMRtjS6j9D6h7kl/ix/krQ0UYXh0YVrgMxoM0X8pdyGagWad6j8dmkVei39SXIIJmzMTcDuFW1sFf4v6VnFrD5G+2JrIf6sts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKYZ8w+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKYZ8w+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7E5C4CEE9;
	Tue, 27 May 2025 17:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365202;
	bh=SzQfNzvcZ4dQDf/L0eP5JAYPtlO3a/Yb3wqkug7E9I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKYZ8w+KPRkcGtKHM+Jg/zcFhPoao6jvw75QcMAusJasgchKmYWPbPhaUgjt3x8lk
	 SWN4W5jokHsf2SIrZ3hpVgp0+cwn7+CmO5ltZdQ5EXfZ7GxPll+w6RY+7nvNzjfD8Y
	 X2ytXZ65H8ES83cElxONUqzujyjnm6Ga+zaB8FuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/626] scsi: mpi3mr: Update timestamp only for supervisor IOCs
Date: Tue, 27 May 2025 18:23:12 +0200
Message-ID: <20250527162457.178149218@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

[ Upstream commit 83a9d30d29f275571f6e8f879f04b2379be7eb6c ]

The driver issues the time stamp update command periodically. Even if the
command fails with supervisor only IOC Status.

Instead check the Non-Supervisor capability bit reported by IOC as part of
IOC Facts.

Co-developed-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250220142528.20837-3-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f6d3db3fd0d8e..604f37e5c0c35 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -2747,7 +2747,10 @@ static void mpi3mr_watchdog_work(struct work_struct *work)
 		return;
 	}
 
-	if (mrioc->ts_update_counter++ >= mrioc->ts_update_interval) {
+	if (!(mrioc->facts.ioc_capabilities &
+		MPI3_IOCFACTS_CAPABILITY_NON_SUPERVISOR_IOC) &&
+		(mrioc->ts_update_counter++ >= mrioc->ts_update_interval)) {
+
 		mrioc->ts_update_counter = 0;
 		mpi3mr_sync_timestamp(mrioc);
 	}
-- 
2.39.5



