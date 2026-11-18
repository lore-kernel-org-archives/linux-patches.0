Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045879;
	b=FS0PRJfwsV+OWBfQbnqCVlsW5wfLWzGBBqdiw1TR/sm1kgLJu4bJD4jvEPR5ziFESp11
	 VrBQGQrnSKYx10v5LxdL0qsKTra5irK4riTZC6BS91Z9FFpYMLDyHW6DHvH9JuVfMD9ab
	 ufozVVQVAa/kd8vVS9DsYmu+zgIIoVsSebTmLlOMv04ihgTNpAh4mLu5jPFKUev4aCSKQ
	 ga911PBTOV4xus6/T8zzdaRI99a53ePp8f8ro10N3cmJaeZ0iVtlksC6UhY7OoKtZUmeQ
	 DB7eloZxMspWpPm6X0TRe/UcaVnk4gahVD6YHqR6nsH+FfY6JL+KPpROsS8p1vVQqHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H403uhP+oyfWawpdFYgvmwBGE7XR8AGoqAYCsdub0LU=;
	b=H742Dhdb2MvZbwXe/wpns2fppPqn4VJrN8NW3UGdNPIRo34Ghvgdqp7J9F28tFw3YHJp
	 RXzZk2zynnYxOlpZVWdtSnjkdISCEc1BWbxlg966e/ozeT3Ue5ypIgin5sAp5zsTISqMt
	 WQRVY3F8ZblOyCQ1ey3NOCpCWnG5Zujckjt4aY/K1oTBVMlbNNE30uqP8vCuN4+gQH9nY
	 B/CbxeRCmH8Y58+rOaj5bd3J6icB3TNhA1Oil32KDfaFPcwUBzCxfeEUPKv0BTk6P4jY4
	 t/E58UVmfcezuwlsiFuBjO0Bs976MXzrY1lGqgcp7eyoi1wFisk2QURBVifipHM+VaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAsUgFtW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0B9606A32F;
	Wed, 18 Nov 2026 23:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAsUgFtW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FF71F000C9;
	Wed, 18 Nov 2026 23:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045879;
	bh=H403uhP+oyfWawpdFYgvmwBGE7XR8AGoqAYCsdub0LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAsUgFtWJKtOHXIUD51Z2KRwd9g8FKdGdmS1t+IQpDmWzaQUV0Ya759YTLhOA7pfc
	 /k0bzdqLvVS8KC+MAgp5IGvPeteXK8pBJGSDXsxp8Q4gLxX6XzfUlCSftKS5/suuhL
	 Hsr+aBseBCFEloxPvlyeFDLMNMBph6MCM1o06f0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1082/2857] nvmet-fc: only send read data for successful commands
Date: Wed, 18 Nov 2026 15:35:16 +0100
Message-ID: <20261118150240.578440545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



