Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6762D8376;
	Tue, 21 Jul 2026 18:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660007; cv=none; b=b6SlG9baim08qG3P5ntKMCms+pJY2RSs9ABGlpSYwm3Ci7fXLgFVQAs44lO0yQ8NJqo+NSPdAtipOUiM1DYfpIvdB801Tj9dKL4e++B5mbeRjGZs2rxnbZ5/97Xghdg3v21Uc+NLWM+xsBmsAHWwM/wfAPruylQgSUEAU6eGpNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660007; c=relaxed/simple;
	bh=KHoekzLF4cbiUpkVp4QpHWB4Qt/XF86v3UxOk/SJL/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPzevRlrop89uozJl+DJj8dob4XIKPIxqyMBD5bQZ6U+1kMamGdYp0ZgzTMTf5WQmKaCKeUoxJNjLbhwnRKCBMA2pQrI6LKqWcqglLFgxiMyNX/Cgz6hLKDeK5lgDOi2Sw9f28Q8fc+B9zfONAD5xWUiLU/xHxpFrat6G0clWRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qja155c/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qja155c/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE6D1F00A3D;
	Tue, 21 Jul 2026 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660006;
	bh=1utGATBR/bnunn6P4f52HctaTJ9FN9kvckLSSjQcp5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qja155c/FH1oTVtAHfd4o0088fW0nczw6PPLo3J1gNHK5Ay2HLRw1dt01engnL5X9
	 mzT+dRoSv18RLk0uIBkRHpI5jYgdW2ZQVICIbBkOK+pnFyvZL8B89zPFZa0Y8GT9e5
	 DglOcxhrKZY3zeq5AQXU6JHF2XfZry6i6QhzAPPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0815/2077] RDMA/bnxt_re: Fail DBR related page allocation UAPIs if the feature is disabled
Date: Tue, 21 Jul 2026 17:08:08 +0200
Message-ID: <20260721152612.014402455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit a57592c6392a8e333c9c2731701297a5a279313a ]

No need to support the DBR related page allocations if the pacing feature
is disabled. Fail the request if pacing is disabled.

Fixes: ea2224857882 ("RDMA/bnxt_re: Update alloc_page uapi for pacing")
Link: https://patch.msgid.link/r/20260615224751.232802-15-selvin.xavier@broadcom.com
Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/uapi.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/uapi.c b/drivers/infiniband/hw/bnxt_re/uapi.c
index 5b0215eb4f58ff..2891b18b9437f5 100644
--- a/drivers/infiniband/hw/bnxt_re/uapi.c
+++ b/drivers/infiniband/hw/bnxt_re/uapi.c
@@ -121,12 +121,16 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_ALLOC_PAGE)(struct uverbs_attr_bundle *
 
 		break;
 	case BNXT_RE_ALLOC_DBR_BAR_PAGE:
+		if (!rdev->pacing.dbr_pacing)
+			return -EOPNOTSUPP;
 		length = PAGE_SIZE;
 		addr = (u64)rdev->pacing.dbr_bar_addr;
 		mmap_flag = BNXT_RE_MMAP_DBR_BAR;
 		break;
 
 	case BNXT_RE_ALLOC_DBR_PAGE:
+		if (!rdev->pacing.dbr_pacing)
+			return -EOPNOTSUPP;
 		length = PAGE_SIZE;
 		addr = (u64)rdev->pacing.dbr_page;
 		mmap_flag = BNXT_RE_MMAP_DBR_PAGE;
-- 
2.53.0



