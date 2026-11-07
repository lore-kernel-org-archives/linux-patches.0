Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063732;
	b=Ap7o7IobF7yz8ulxTDvLpclfihOVbMYJsbjMqLObgruqAdr3NPg6RmlQHt7dMuKy9kpV
	 Of1LfSraeBS6X8SnmSC7cdNrDdf17NJCxIaZkhULfQ2Xz7DadcYsqPg1gKMOFCS9IIZEC
	 n2O7uxJeIAj3ljfK8dEYPeJZiz7GWZ7Rlb4t4cqclpdOPKGNwaJjueZEtjEVsRhZuM9xD
	 K3G/tTSJxTROjI3n4Da1HKE8Q49YUxJ3YPyCtt+kV4XYAEOsQ2Y57yD5j+oAFfAzHAnBC
	 QrRQSwLi/usKmUazZBvLI9nvHmOZIFCk44R+oxOF4OFq8s9HmTbUBc+cTgVkSLwcUFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oU9S3KHybpBbGAmaWhF0McqqvJ86JKYulrmr2YfP0WI=;
	b=Jhj3/7g5jmgYgpiQbczcsSBMa4Z1EC5kdbSjryY5w3SsNR2YwcxHiNW4izJdd8VBToJs
	 LmAQC6D1XzT8xoeIaD+miuLyUs+z4ic9NlwXDkRIj17i01EBKNx+fnP96C9ZQFA9CFMd7
	 MyL78KYCD6Su/7cBpiWdtwSnmh/wfNiDA9jgzTMvk4c/Tytbyh2zISWs4UDuG/qcQ8I7n
	 KdJefkQq1q0iNo+x9QlGC62+83Kr+MglP88+RB0NwaWE+UjaDBFcuje3M5ioliH0DXcH5
	 balFuQk7ue0wciwuMhnzKpSxrzK/Q2iDCRZYl/UWbg4ZV2m+l+Z6DY81see/UAR30Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WfAq8Axu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15CD6606EEB8;
	Sat,  7 Nov 2026 15:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WfAq8Axu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DB21F008A5;
	Sat,  7 Nov 2026 15:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063731;
	bh=oU9S3KHybpBbGAmaWhF0McqqvJ86JKYulrmr2YfP0WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfAq8Axuf0/68XaZ/y0pIa0EWy1YUZNWDrwvG7KTJv1SMmAdWAszhLAWA0GcI6mZQ
	 oAcJFOU8YGLLWj9CDRA0nS3VMiAD8ksodDmv9GAxSCcsXXODdOx7Ewvq3y6wv848p8
	 3tECD5W9JstZPsfrlGIQ2zPIU9Mng+TZkYdxkAKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 829/869] nvmet-fc: only send read data for successful commands
Date: Sat,  7 Nov 2026 08:58:31 -0500
Message-ID: <20261107134921.044160471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 94f93c61b1a5dd08d011be58172ce4392b849008 ]

When a read command completes with an error,
__nvmet_fc_fcp_nvme_cmd_done() still pushes the whole data buffer to
the host before the response. nvmet_fc_alloc_tgt_pgs() allocates that
buffer with sgl_alloc() and no __GFP_ZERO, and a command rejected by
nvmet_check_transfer_len() leaves it untouched, so the host receives
stale target memory.

The buffer is as large as the data length in the command IU, so the
amount of stale memory returned is up to the host.

The tcp and rdma targets send data only when cqe->status is zero (see
nvmet_tcp_need_data_out() and nvmet_rdma_need_data_out()), so no nvmet
command can rely on returning data with an error status. Do the same
for fc. The ERSP then reports a transferred length of fod->offset,
which is 0, matching what nvme_fc_fcpio_done() checks on the host.

Tested over nvme-fcloop: a failed read command no longer transfers
data and still completes with its error status, and successful reads
are unaffected.

Fixes: c53432030d86 ("nvme-fabrics: Add target support for FC transport")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 1880fc7804326..ec08992668b99 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2493,11 +2493,11 @@ __nvmet_fc_fcp_nvme_cmd_done(struct nvmet_fc_tgtport *tgtport,
 	} else {
 
 		/*
-		 * try to push the data even if the SQE status is non-zero.
-		 * There may be a status where data still was intended to
-		 * be moved
+		 * A failed command may not have filled its read buffer, so
+		 * only push data for success, as the tcp and rdma targets do.
 		 */
-		if ((fod->io_dir == NVMET_FCP_READ) && (fod->data_sg_cnt)) {
+		if (fod->io_dir == NVMET_FCP_READ && fod->data_sg_cnt &&
+		    !cqe->status) {
 			/* push the data over before sending rsp */
 			nvmet_fc_transfer_fcp_data(tgtport, fod,
 						NVMET_FCOP_READDATA);
-- 
2.53.0



