Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D3818EFC9;
	Mon, 28 Oct 2024 06:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098016; cv=none; b=robPJz96eKMEslEvyTwsUFP3lSEieoUtH9Gt27+G8h7fert4Oc2DRaV5+lPyENB4Pxo74cImEsrUIjSfdBe/RXhr3hVLS4VqJizOvquEEtWPMDI5sZZ7zvFqm5+Y3BjmbRzG4XwQPT+r/CqdATar55kc0oTY0FsZC0jv2LRFZps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098016; c=relaxed/simple;
	bh=H0SykPdyB/8GKGoEzzqPhQEk0qrsWvZm8z7ZfD/1WEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoYQ0c17anvTirGiDkQ0HK/+QSlicPOy2txtPwl4YHX73uFP2S78oQa4JFP2cIHQ7JFfmA/Sh08ReTZIt7VLVI5pH2utiY1MzpW9UziUFI+i1LdXAGD71HsfcoB633gKVDQLrmDgu8eIGDTfCXMfk7LR3fbdnOfar87GdaHCgK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSTw7y6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSTw7y6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0FAC4CEC3;
	Mon, 28 Oct 2024 06:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098016;
	bh=H0SykPdyB/8GKGoEzzqPhQEk0qrsWvZm8z7ZfD/1WEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSTw7y6PL6nB3NCZOiN2E42ysLnRSsoaDe/D3iaM5VEGl9YORN5QlebhE1q77f1m1
	 0MHQVC9bTb7Cc9oFg83iyS8nz9mSG8gslpIY3dW7/mtiolahsnEX0TEEOsalBv8ZbM
	 mn45DO1T+vTm9E2iePrWtKIvLLijFgTfQ00WT4Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 040/261] RDMA/bnxt_re: Fix out of bound check
Date: Mon, 28 Oct 2024 07:23:02 +0100
Message-ID: <20241028062313.012790528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit a9e6e7443922ac0a48243c35d03834c96926bff1 ]

Driver exports pacing stats only on GenP5 and P7 adapters. But while
parsing the pacing stats, driver has a check for "rdev->dbr_pacing".  This
caused a trace when KASAN is enabled.

BUG: KASAN: slab-out-of-bounds in bnxt_re_get_hw_stats+0x2b6a/0x2e00 [bnxt_re]
Write of size 8 at addr ffff8885942a6340 by task modprobe/4809

Fixes: 8b6573ff3420 ("bnxt_re: Update the debug counters for doorbell pacing")
Link: https://patch.msgid.link/r/1728373302-19530-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/hw_counters.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/hw_counters.c b/drivers/infiniband/hw/bnxt_re/hw_counters.c
index 128651c015956..1e63f80917483 100644
--- a/drivers/infiniband/hw/bnxt_re/hw_counters.c
+++ b/drivers/infiniband/hw/bnxt_re/hw_counters.c
@@ -366,7 +366,7 @@ int bnxt_re_ib_get_hw_stats(struct ib_device *ibdev,
 				goto done;
 			}
 		}
-		if (rdev->pacing.dbr_pacing)
+		if (rdev->pacing.dbr_pacing && bnxt_qplib_is_chip_gen_p5_p7(rdev->chip_ctx))
 			bnxt_re_copy_db_pacing_stats(rdev, stats);
 	}
 
-- 
2.43.0



