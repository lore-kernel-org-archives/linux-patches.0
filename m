Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDB47E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A97C433D6;
	Wed,  2 Nov 2022 02:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356923;
	bh=sxKMD5EUoNDvq9r/9csw9mekqWcWIfegZEhsz1W7AH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iz5M9X0SeWbddJIPmPVEWsYPt81hGsXjM9iuIOJbRfsXitT8i5nsqlyq0ZAgzZno
	 /9NP6oQFx/3a1WDTrAHkYfODT4aT5K+SNhcu+dm1/sBBkBTanApcCzZK0hVcT9Ozqi
	 ssj6TvVU/JAPp0U+qKdZk5A3YOJ/5dgmOj/O+m8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.0 082/240] mmc: core: Fix WRITE_ZEROES CQE handling
Date: Wed,  2 Nov 2022 03:30:57 +0100
Message-Id: <20221102022113.255363068@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

commit 028822b714bd3a159d65416c53f1549345b53d9e upstream.

WRITE_ZEROES requests use TRIM, so mark them as needing to be issued
synchronously even when a CQE is being used.  Without this,
mmc_blk_mq_issue_rq() triggers a WARN_ON_ONCE() and fails the request
since we don't have any handling for issuing this asynchronously.

Fixes: f7b6fc327327 ("mmc: core: Support zeroout using TRIM for eMMC")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221020130123.4033218-1-vincent.whitchurch@axis.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 86be55d7cf55..b396e3900717 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -48,6 +48,7 @@ static enum mmc_issue_type mmc_cqe_issue_type(struct mmc_host *host,
 	case REQ_OP_DRV_OUT:
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_WRITE_ZEROES:
 		return MMC_ISSUE_SYNC;
 	case REQ_OP_FLUSH:
 		return mmc_cqe_can_dcmd(host) ? MMC_ISSUE_DCMD : MMC_ISSUE_SYNC;
-- 
2.38.1



