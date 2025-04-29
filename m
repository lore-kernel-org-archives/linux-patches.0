Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69AF25334B;
	Tue, 29 Apr 2025 16:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945853; cv=none; b=Zcfxn8B4WcSbWCBpUQ4YaNXCSrNDNxwj3HawZD4dZ5iMiu0cyzI3/a4kgHKdLuSYZkTkvxdqQPL+PdPQx3cnrTaVgrs1EMQ4qW9EcDZsRjQSUF2z1sxdd8dbbkggLkIQS3E7gF/STu3H8ULaEA+7z320Ng8gfxPGsnfzhx7FcdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945853; c=relaxed/simple;
	bh=/yI8lnZ6/PJjsnpokehn/uJPAentbOtcoKPJc/jHtNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzMETLtmul+n+qCYuaYWzPjC3B4ESrp/7SaLoBisCdxkph3f4PP9xwCefGUgtHWzHdtAhF+5daD2ORRjRQS4LgnTRN3kyN6aMx/m4XvYbWb1IU4dwFR3dyYe/JVYTLJD0eGi3VlpinAdNB+o2g58Z9ANjzEWR2EOJGSoHrx1FpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQf6Ru5Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQf6Ru5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE75EC4CEE3;
	Tue, 29 Apr 2025 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945853;
	bh=/yI8lnZ6/PJjsnpokehn/uJPAentbOtcoKPJc/jHtNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQf6Ru5QJhCDX53LszVrGzvVAfjRUpRSTZY1T0vfzOLBEJ8mEjQjYvJwKgW2RZjEb
	 CsnsJOAZ+aEzlY527j7tyypqyUkPh+5pTiugCMiX60y7WUgaHmBBf1wAFoWeNuYfBs
	 Bwr7AXL4oQQQmqFxpUfieuN9LwHBJo3ogdGnSmAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 071/311] pds_core: Prevent possible adminq overflow/stuck condition
Date: Tue, 29 Apr 2025 18:38:28 +0200
Message-ID: <20250429161123.950869732@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brett Creeley <brett.creeley@amd.com>

[ Upstream commit d9e2f070d8af60f2c8c02b2ddf0a9e90b4e9220c ]

The pds_core's adminq is protected by the adminq_lock, which prevents
more than 1 command to be posted onto it at any one time. This makes it
so the client drivers cannot simultaneously post adminq commands.
However, the completions happen in a different context, which means
multiple adminq commands can be posted sequentially and all waiting
on completion.

On the FW side, the backing adminq request queue is only 16 entries
long and the retry mechanism and/or overflow/stuck prevention is
lacking. This can cause the adminq to get stuck, so commands are no
longer processed and completions are no longer sent by the FW.

As an initial fix, prevent more than 16 outstanding adminq commands so
there's no way to cause the adminq from getting stuck. This works
because the backing adminq request queue will never have more than 16
pending adminq commands, so it will never overflow. This is done by
reducing the adminq depth to 16.

Fixes: 45d76f492938 ("pds_core: set up device and adminq")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250421174606.3892-2-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 5 +----
 drivers/net/ethernet/amd/pds_core/core.h | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 536635e577279..4830292d5f879 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -325,10 +325,7 @@ static int pdsc_core_init(struct pdsc *pdsc)
 	size_t sz;
 	int err;
 
-	/* Scale the descriptor ring length based on number of CPUs and VFs */
-	numdescs = max_t(int, PDSC_ADMINQ_MIN_LENGTH, num_online_cpus());
-	numdescs += 2 * pci_sriov_get_totalvfs(pdsc->pdev);
-	numdescs = roundup_pow_of_two(numdescs);
+	numdescs = PDSC_ADMINQ_MAX_LENGTH;
 	err = pdsc_qcq_alloc(pdsc, PDS_CORE_QTYPE_ADMINQ, 0, "adminq",
 			     PDS_CORE_QCQ_F_CORE | PDS_CORE_QCQ_F_INTR,
 			     numdescs,
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 14522d6d5f86b..543097983bf60 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -16,7 +16,7 @@
 
 #define PDSC_WATCHDOG_SECS	5
 #define PDSC_QUEUE_NAME_MAX_SZ  16
-#define PDSC_ADMINQ_MIN_LENGTH	16	/* must be a power of two */
+#define PDSC_ADMINQ_MAX_LENGTH	16	/* must be a power of two */
 #define PDSC_NOTIFYQ_LENGTH	64	/* must be a power of two */
 #define PDSC_TEARDOWN_RECOVERY	false
 #define PDSC_TEARDOWN_REMOVING	true
-- 
2.39.5



