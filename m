Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037048;
	b=SfD1nalRbaUq33m6QwvXWqb1cdkVIHiFqF/2dxyYIHL1Zb6ooOO5lAjz/0Uvh8QI8RmW
	 QLEcu4iYoYCiAcVf+MQJ7iosT46Osv34aXX8WwtaI4QrSgrbqeJHoamSGR55ej34/uJX3
	 Llrz7VE/XtDJcI4Pl17QHKsoh2JuPwcA0VJJO/OLUuKImV2wHKpnCe2vVnIFocUfnuj0n
	 dZk3+mKf5Y2uBxVAH2/iTiGremuS+Y6mNLRYZ3BvmxZwGMensDJZdQpfakSVK/cDcr5aN
	 Wj9dkO4jvOguMZ32B1GrKbOCeLRKhfdnELuKrwQKNi62zjFh2S65LxMHe4RQCmv+3gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BwbAxGib1t/j4Pga2nnki1Kj6oLm/vt3F1vgZEJ6Ezs=;
	b=XUz0IjtbwK3TFOQmuDLv2RKBkTywg6NG+W2l47wj0y4eE8zglfB3RZwiMO5TKobhgkrH
	 u/KSyeXk5A+gUw+wXCgZuMgMuHTsv3qHOUDYbtrfXnHGSZOwZ8j6JsbPXiay+2YQ2p+L5
	 +YX7dTSb6qxHZrcjNSc6XQytgkkth7BhWqxAN2tLZNW/2dfahtJfwuZG3hE1IRoLLx76U
	 0TEM1bS3/AytlG+6YFxjBjSZCjphUbCCfci9ApZtQaqFxXxxqIkV5HHctVGK+08OstblQ
	 0FIQZ3u8uDO8QCDIHOpvhjcStJrf27OChvr0uEOJ2PieKCs+BEklzuJIxaBurXUpK3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DMbfoqju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A504606A320;
	Wed, 18 Nov 2026 21:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DMbfoqju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DDF1F000C4;
	Wed, 18 Nov 2026 21:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037048;
	bh=BwbAxGib1t/j4Pga2nnki1Kj6oLm/vt3F1vgZEJ6Ezs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DMbfoqjuTEusM/fqGo/OOiMkSegct+lEGy0mV+HLtW+l8T4CxeMAbei8ruWnTc9HQ
	 G7ze3BPO/67XFRvTCUJfRRjGc17j9swMQIZcfL6fVKzNKztEW33cJq2Yi1/uwmb2S7
	 p3/wwjJdpKpDUHx7mgvAupBVWbmog2oVmLQoM1OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1274/3318] nvmet-fc: only send read data for successful commands
Date: Wed, 18 Nov 2026 15:31:36 +0100
Message-ID: <20261118150358.453468255@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2ef185e0bc535..217637d2f8ae8 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2464,11 +2464,11 @@ __nvmet_fc_fcp_nvme_cmd_done(struct nvmet_fc_tgtport *tgtport,
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



