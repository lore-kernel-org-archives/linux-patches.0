Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C1715ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:43:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40606C433C8;
	Tue, 25 Jul 2023 11:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285423;
	bh=jCyfVEhU6vEmeCWsgLq+jwpt/9NF9ZDiTroh/Zk4hLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKgbm9QGaqN4BRfqiz8Zg49wjDRwwmet8FvV4qkRJAMG6DObfB89FIHuiKM0DHFSb
	 aPLkD0VuyMO4cAL9pk4XZXV/W8pfNhcLTzFEwGwrbGiBpdnGuFAkUfjk6bBNxLYH7h
	 HXF3qzgiQk239IWKQVjG0GM3w+VCOcXjgMpksc5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/313] scsi: qla2xxx: Fix error code in qla2x00_start_sp()
Date: Tue, 25 Jul 2023 12:45:53 +0200
Message-ID: <20230725104529.664477600@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e579b007eff3ff8d29d59d16214cd85fb9e573f7 ]

This should be negative -EAGAIN instead of positive.  The callers treat
non-zero error codes the same so it doesn't really impact runtime beyond
some trivial differences to debug output.

Fixes: 80676d054e5a ("scsi: qla2xxx: Fix session cleanup hang")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/49866d28-4cfe-47b0-842b-78f110e61aab@moroto.mountain
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 103288b0377e0..cbdc84fdc52c1 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3665,7 +3665,7 @@ qla2x00_start_sp(srb_t *sp)
 	spin_lock_irqsave(qp->qp_lock_ptr, flags);
 	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
 	if (!pkt) {
-		rval = EAGAIN;
+		rval = -EAGAIN;
 		ql_log(ql_log_warn, vha, 0x700c,
 		    "qla2x00_alloc_iocbs failed.\n");
 		goto done;
-- 
2.39.2



