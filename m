Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E85F8C13;
	Tue,  5 Dec 2023 03:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsmGTcIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79894C433C7;
	Tue,  5 Dec 2023 03:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747020;
	bh=2enEgm/JqbtNuZA2beX6VVYFIoiXv8VBB0HCa06ImPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsmGTcIQr8iBFMr0EX7BJiOQm8oU7cPeR5571yDXGn6gMmzNj5wQr+H2w7tvd3MGl
	 f7cEtKN868nOuRgL+nVkHj3VjKK/puWZ41YGqT8Gg39SNkyJIp5E6zHXCIt5dXFG6R
	 8fxfw/wIDSrkpQ9DrkcelAPMfUF9Y6iwxRBTOjEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Avri Altman <avri.altman@wdc.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 011/107] mmc: block: Do not lose cache flush during CQE error recovery
Date: Tue,  5 Dec 2023 12:15:46 +0900
Message-ID: <20231205031532.280544756@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit 174925d340aac55296318e43fd96c0e1d196e105 upstream.

During CQE error recovery, error-free data commands get requeued if there
is any data left to transfer, but non-data commands are completed even
though they have not been processed.  Requeue them instead.

Note the only non-data command is cache flush, which would have resulted in
a cache flush being lost if it was queued at the time of CQE recovery.

Fixes: 1e8e55b67030 ("mmc: block: Add CQE support")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Link: https://lore.kernel.org/r/20231103084720.6886-2-adrian.hunter@intel.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1505,6 +1505,8 @@ static void mmc_blk_cqe_complete_rq(stru
 			blk_mq_requeue_request(req, true);
 		else
 			__blk_mq_end_request(req, BLK_STS_OK);
+	} else if (mq->in_recovery) {
+		blk_mq_requeue_request(req, true);
 	} else {
 		blk_mq_end_request(req, BLK_STS_OK);
 	}


