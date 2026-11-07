Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065594;
	b=Uq2VmcT1/0g5qV2aMHOQkC9QAB4U9MYMnzFQuhARwL7B26oAXkE/XFOcA2gv1d+KGRb0
	 aXTkNAw3b/ExGJKCFo9XC5mreACTy09hpLzqDixpx+4f9iMm+vtYGbpIeSiNZxnD+KVZM
	 Tnfdxf4HLqWdQJEnyqd8gvAikw4EW9iAI8WkGm4ciBs4yQTnRk9F5zOcuk9zvJw4oIJO4
	 ObkTJEi2xG5WBdrygIJwIisrMiz2dFdsjdW6oYx3Pf3X1an1YofiiBFDMhuUET6EN56t0
	 1Bbga9V2NW1eby3WBVs5JcHES18TxJB5q5qAC5EacapFdD2IUsFQ9d+D3vROzl6qbCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ZYlAfQHlm/Bk+TOSJXMw2HB+19AmBAgZE3xedTenWs=;
	b=R1jUq5ZszeO1+blrDOqfzd0+cCeUsluuKLyZIoxm/py4jj0Xg5TU0QvAGIkAG6NuKPcK
	 P8bJncciiJv6GwGNWw/DgaeU7ybqTrPI58htodwg2T/JD7wwPKU0lUQkjrEWkdICJEO5E
	 mUT0YivtO7mb+6tSaq9Z7Gk+oIDfYUdqbPFW3cNWdhrmpw8IkYAORQbAQ1SrPEzDrz2nn
	 xL6TQLb/WuwthewBzbrN4Jv1AI7JiZ9TYLs53IA14FREWSjaWad8drXkAWTHFZ4BgfQfu
	 U9H3IIx9Q+GmhoTc+bi+B94Fvw9nR97iIcLyewqq7PbRUdOzYqwl9YA7UeuTuh0StYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkI4Ejyn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6AE606A337;
	Sat,  7 Nov 2026 15:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkI4Ejyn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E6A1F0089F;
	Sat,  7 Nov 2026 15:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065594;
	bh=1ZYlAfQHlm/Bk+TOSJXMw2HB+19AmBAgZE3xedTenWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkI4Ejyngupy0PRiQHnBO/jIDtIHUMXgORrEDeyQ5COdWYqM/AHaoUXRPy+ISl4cd
	 qrBcqqbz8V2HIOawnnDfLuYPo4zOuVrvXiWnoViWLhTxDYp2oyqlc8xrwxAPy7KP4F
	 GHDNOFmDi1z0f2wpQrRTZOj76Z8a07iUsctfYARs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1203/1257] nvmet-fc: only send read data for successful commands
Date: Sat,  7 Nov 2026 08:58:19 -0500
Message-ID: <20261107135012.579041202@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f3e80095d7d16..c45a98cc094bb 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2486,11 +2486,11 @@ __nvmet_fc_fcp_nvme_cmd_done(struct nvmet_fc_tgtport *tgtport,
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



