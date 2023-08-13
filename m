Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CDA9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1D8C433C7;
	Sun, 13 Aug 2023 21:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962202;
	bh=Pgcw3N54tL+sWquBCVfFx6nLtmYeczE7L2bOtp0Sueo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJsW/xeqApjsa5nsI2u5jbqDxiabPll2dneE1xrU862SXECxgXO3AlmFC1sNTDec8
	 MEtmLWyJvcDV8lIbBow3XH5BT6mr1jtRPhd4LjbyFGNBQE0WBHqc8gO/dee2OC1OED
	 vb7/iGIanUT2POXA4E2GZK3Qb2YiBuX+dXVgc4Jw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.4 150/206] RDMA/bnxt_re: Properly order ib_device_unalloc() to avoid UAF
Date: Sun, 13 Aug 2023 23:18:40 +0200
Message-ID: <20230813211729.325118514@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Selvin Xavier <selvin.xavier@broadcom.com>

commit 5363fc488da579923edf6a2fdca3d3b651dd800b upstream.

ib_dealloc_device() should be called only after device cleanup.  Fix the
dealloc sequence.

Fixes: 6d758147c7b8 ("RDMA/bnxt_re: Use auxiliary driver interface")
Link: https://lore.kernel.org/r/1691642677-21369-2-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1425,8 +1425,8 @@ static void bnxt_re_remove(struct auxili
 	}
 	bnxt_re_setup_cc(rdev, false);
 	ib_unregister_device(&rdev->ibdev);
-	ib_dealloc_device(&rdev->ibdev);
 	bnxt_re_dev_uninit(rdev);
+	ib_dealloc_device(&rdev->ibdev);
 skip_remove:
 	mutex_unlock(&bnxt_re_mutex);
 }


