Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35898BED;
	Sat, 30 Dec 2023 12:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmgypVv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02CFC433C8;
	Sat, 30 Dec 2023 12:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937852;
	bh=j/ulLeD53Wf5m7M/be9K2Aqb2lvEujnipbau7T9xEi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tmgypVv4qcfhG/XPgxvXjnGKKVLSaUgkqNulIjVZnoN/a/Jv7fw5dX8fAPuUmhfTC
	 ytZnOW4uxwoptFV7XaISq03jcOU5CSSkGBaUdBPGbVvJiYEJAgAgtjVfcL97mWvrQW
	 cs21pzDqs2yV20C1pRnxJQuL1cqbAWytsOXWOj7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 088/156] scsi: ufs: core: Let the sq_lock protect sq_tail_slot access
Date: Sat, 30 Dec 2023 11:59:02 +0000
Message-ID: <20231230115815.232271354@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Can Guo <quic_cang@quicinc.com>

[ Upstream commit 04c116e2bdfc3969f9819d2cebfdf678353c354c ]

When accessing sq_tail_slot without protection from sq_lock, a race
condition can cause multiple SQEs to be copied to duplicate SQE slots. This
can lead to multiple stability issues. Fix this by moving the *dest
initialization in ufshcd_send_command() back under protection from the
sq_lock.

Fixes: 3c85f087faec ("scsi: ufs: mcq: Use pointer arithmetic in ufshcd_send_command()")
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Link: https://lore.kernel.org/r/1702913550-20631-1-git-send-email-quic_cang@quicinc.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 170fbd5715b21..a885cc177cff7 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2172,9 +2172,10 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag,
 	if (is_mcq_enabled(hba)) {
 		int utrd_size = sizeof(struct utp_transfer_req_desc);
 		struct utp_transfer_req_desc *src = lrbp->utr_descriptor_ptr;
-		struct utp_transfer_req_desc *dest = hwq->sqe_base_addr + hwq->sq_tail_slot;
+		struct utp_transfer_req_desc *dest;
 
 		spin_lock(&hwq->sq_lock);
+		dest = hwq->sqe_base_addr + hwq->sq_tail_slot;
 		memcpy(dest, src, utrd_size);
 		ufshcd_inc_sq_tail(hwq);
 		spin_unlock(&hwq->sq_lock);
-- 
2.43.0



