Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F999443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853B5C433C8;
	Sun, 13 Aug 2023 21:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962204;
	bh=wXT+SuCdLrZhpCZTgn2OQu56utFFQ/y5yNhZdGV1OmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xj0sCsRupy77I+jaL1Pyw/EiHfCyQzHiIXwlv3vUrLgeQdTkF8q8tGjGDUw5r8dk1
	 dhj8ZYPFrYA0QwNT4RZyJ06vO44lQLQw2Rmy4LKYRIviGaKm0Qpspr2zpKJdlKrwaQ
	 Lvtr7lx6NWn0fPUosQLgYsb0CegU1Bja2hXzyZFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 6.4 151/206] RDMA/bnxt_re: Fix error handling in probe failure path
Date: Sun, 13 Aug 2023 23:18:41 +0200
Message-ID: <20230813211729.353036405@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

commit 5ac8480ae4d01f0ca5dfd561884424046df2478a upstream.

During bnxt_re_dev_init(), when bnxt_re_setup_chip_ctx() fails unregister
with L2 first before bailing out probe.

Fixes: ae8637e13185 ("RDMA/bnxt_re: Add chip context to identify 57500 series")
Link: https://lore.kernel.org/r/1691642677-21369-3-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -1152,6 +1152,8 @@ static int bnxt_re_dev_init(struct bnxt_
 
 	rc = bnxt_re_setup_chip_ctx(rdev, wqe_mode);
 	if (rc) {
+		bnxt_unregister_dev(rdev->en_dev);
+		clear_bit(BNXT_RE_FLAG_NETDEV_REGISTERED, &rdev->flags);
 		ibdev_err(&rdev->ibdev, "Failed to get chip context\n");
 		return -EINVAL;
 	}


