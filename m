Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFF51DF258;
	Tue, 11 Nov 2025 00:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822442; cv=none; b=sQ3S2Sa6CSjVibVOuYNvTJeIsfsJv99mSI1tEEIJetnieiQJBEWAvgWcS9SZ5o2iZPqc4hR7sL9q6LMDl+Ez7xsMfWxVXVno/jHSaoo4Mg9j7Hi6kklfftf7aG5jJIkA9WFoNtd1gW6sBBcsg+uJj2+gumQ7GOhVDl5Xe9K4/vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822442; c=relaxed/simple;
	bh=xXpDNPWrOlnyiBz+JMhdey4hVDnLFhN2G8Hdi0oKTYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=okYe8NAiahBEkoEscS3m1YY8HY8orPr1nkpfg4e6zPWc2+WE/or8Kqp2a68AvTFh6ajBfRFojjFLyAk3mbJ/zOU8cPSP0BajJdkmmAnl3jzgyrp/zcwxzraWEqdYvd8thQ+j9piA4ZieQC/DT4Lx6fhxkMH8do/xnBFPtL3GfAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdHSc1JM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdHSc1JM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75B2C19424;
	Tue, 11 Nov 2025 00:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822442;
	bh=xXpDNPWrOlnyiBz+JMhdey4hVDnLFhN2G8Hdi0oKTYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdHSc1JM5vNMaSpfxrbOQKHO6Jt4GdlOYhlvofsmbLjQMgZ91ybeA7JGHt1U5rDyJ
	 1bLWEtm4KTZXSP9bG8gUe2nTjKv1woYwuvfoRGPH6KAHc+OcnS3MdCYIfbeO86KeA0
	 tSwSFqUg3mMUxQ/xqWbXTl6bXyj4lEW6zfDMkuik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edward Cree <ecree.xilinx@gmail.com>,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/565] sfc: fix potential memory leak in efx_mae_process_mport()
Date: Tue, 11 Nov 2025 09:38:27 +0900
Message-ID: <20251111004528.057191906@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

[ Upstream commit 46a499aaf8c27476fd05e800f3e947bfd71aa724 ]

In efx_mae_enumerate_mports(), memory allocated for mae_mport_desc is
passed as a argument to efx_mae_process_mport(), but when the error path
in efx_mae_process_mport() gets executed, the memory allocated for desc
gets leaked.

Fix that by freeing the memory allocation before returning error.

Fixes: a6a15aca4207 ("sfc: enumerate mports in ef100")
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20251023141844.25847-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/mae.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 10709d828a636..21d5596460732 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -1101,6 +1101,9 @@ void efx_mae_remove_mport(void *desc, void *arg)
 	kfree(mport);
 }
 
+/*
+ * Takes ownership of @desc, even if it returns an error
+ */
 static int efx_mae_process_mport(struct efx_nic *efx,
 				 struct mae_mport_desc *desc)
 {
@@ -1111,6 +1114,7 @@ static int efx_mae_process_mport(struct efx_nic *efx,
 	if (!IS_ERR_OR_NULL(mport)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "mport with id %u does exist!!!\n", desc->mport_id);
+		kfree(desc);
 		return -EEXIST;
 	}
 
-- 
2.51.0



