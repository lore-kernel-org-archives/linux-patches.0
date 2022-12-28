Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C978A1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47123C433EF;
	Wed, 28 Dec 2022 16:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244101;
	bh=l9HWFXL6iqJaCWp0n0E1sik/5WoiJBg7NENzeQiWgc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKfM7PJQMKi8jl/Zx6Y7SnfB1dvuEPtGHD+RGCxX2jCz/IIhEmpJX5vfH00KC8ZdN
	 YHuSjWfBEx+veNoMz0AdgW3ETpR2Ajr+7TAh4d0YSUIjXf5dEuccXUj6pSoVhlz5gF
	 oI3dImJbXJdp39UnY1Q1K78ssjpy0DiTTTUqJnFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0611/1146] RDMA/siw: Set defined status for work completion with undefined status
Date: Wed, 28 Dec 2022 15:35:50 +0100
Message-Id: <20221228144346.766092435@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bernard Metzler <bmt@zurich.ibm.com>

[ Upstream commit 60da2d11fcbc043304910e4d2ca82f9bab953e63 ]

A malicious user may write undefined values into memory mapped completion
queue elements status or opcode. Undefined status or opcode values will
result in out-of-bounds access to an array mapping siw internal
representation of opcode and status to RDMA core representation when
reaping CQ elements. While siw detects those undefined values, it did not
correctly set completion status to a defined value, thus defeating the
whole purpose of the check.

This bug leads to the following Smatch static checker warning:

	drivers/infiniband/sw/siw/siw_cq.c:96 siw_reap_cqe()
	error: buffer overflow 'map_cqe_status' 10 <= 21

Fixes: bdf1da5df9da ("RDMA/siw: Fix immediate work request flush to completion queue")
Link: https://lore.kernel.org/r/20221115170747.1263298-1-bmt@zurich.ibm.com
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_cq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_cq.c b/drivers/infiniband/sw/siw/siw_cq.c
index acc7bcd538b5..403029de6b92 100644
--- a/drivers/infiniband/sw/siw/siw_cq.c
+++ b/drivers/infiniband/sw/siw/siw_cq.c
@@ -88,9 +88,9 @@ int siw_reap_cqe(struct siw_cq *cq, struct ib_wc *wc)
 
 			if (opcode >= SIW_NUM_OPCODES) {
 				opcode = 0;
-				status = IB_WC_GENERAL_ERR;
+				status = SIW_WC_GENERAL_ERR;
 			} else if (status >= SIW_NUM_WC_STATUS) {
-				status = IB_WC_GENERAL_ERR;
+				status = SIW_WC_GENERAL_ERR;
 			}
 			wc->opcode = map_wc_opcode[opcode];
 			wc->status = map_cqe_status[status].ib;
-- 
2.35.1



