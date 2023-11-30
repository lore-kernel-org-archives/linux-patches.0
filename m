Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F3A524C2;
	Thu, 30 Nov 2023 16:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EESeyZJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1116C433C7;
	Thu, 30 Nov 2023 16:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361578;
	bh=FUUxMssgfH9mChtN3HZ2T6DRfqLki6P9dx6HE4v1i6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EESeyZJs7wwpSVrm4FAob0QEW4CQcdn3Rg4L18dD6Pexyms/GMCDWZLVpSabdLy5g
	 n5EnC6ZyyWbxqSMwrBSQ7ZQKwK9GUJznoRi2PmD3A4ycRSC4SEZ2C3GQ/8qtrL9kD7
	 r46HV8sLNSvujzAyycDFGcpXYFzKBofd+aEzIC7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alon Zahavi <zahavi.alon@gmail.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/112] nvmet: nul-terminate the NQNs passed in the connect command
Date: Thu, 30 Nov 2023 16:21:40 +0000
Message-ID: <20231130162142.009772119@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 1c22e0295a5eb571c27b53c7371f95699ef705ff ]

The host and subsystem NQNs are passed in the connect command payload and
interpreted as nul-terminated strings.  Ensure they actually are
nul-terminated before using them.

Fixes: a07b4970f464 "nvmet: add a generic NVMe target")
Reported-by: Alon Zahavi <zahavi.alon@gmail.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/target/fabrics-cmd.c b/drivers/nvme/target/fabrics-cmd.c
index 43b5bd8bb6a52..d8da840a1c0ed 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -244,6 +244,8 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 		goto out;
 	}
 
+	d->subsysnqn[NVMF_NQN_FIELD_LEN - 1] = '\0';
+	d->hostnqn[NVMF_NQN_FIELD_LEN - 1] = '\0';
 	status = nvmet_alloc_ctrl(d->subsysnqn, d->hostnqn, req,
 				  le32_to_cpu(c->kato), &ctrl);
 	if (status)
@@ -313,6 +315,8 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 		goto out;
 	}
 
+	d->subsysnqn[NVMF_NQN_FIELD_LEN - 1] = '\0';
+	d->hostnqn[NVMF_NQN_FIELD_LEN - 1] = '\0';
 	ctrl = nvmet_ctrl_find_get(d->subsysnqn, d->hostnqn,
 				   le16_to_cpu(d->cntlid), req);
 	if (!ctrl) {
-- 
2.42.0



