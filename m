Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDBA6FB0;
	Tue,  5 Dec 2023 03:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VpcqrbVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717E3C433C7;
	Tue,  5 Dec 2023 03:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747914;
	bh=r2Omb+yOna2xZMaDK6QbfSO5kFfVXJY8oTDfHhT/fm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VpcqrbVo/zC2vGDRwA2fSoNp6E+/0ETAu6oIkc3Jyj9nYWPiOhWczgHWz7JXlRIYS
	 y8om5/1PVivfqpX5MW2INiKnM0PTfWWWOLycUsA8Cykak0N9Gzmbr6g+ghcSf71gI1
	 LeR6i/WpBct01uWeFKIE1rlIs32GkwfmbK9JG+Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alon Zahavi <zahavi.alon@gmail.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/94] nvmet: nul-terminate the NQNs passed in the connect command
Date: Tue,  5 Dec 2023 12:16:49 +0900
Message-ID: <20231205031524.090834080@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031522.815119918@linuxfoundation.org>
References: <20231205031522.815119918@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 58544f9bbc20c..d4036508f32a7 100644
--- a/drivers/nvme/target/fabrics-cmd.c
+++ b/drivers/nvme/target/fabrics-cmd.c
@@ -182,6 +182,8 @@ static void nvmet_execute_admin_connect(struct nvmet_req *req)
 		goto out;
 	}
 
+	d->subsysnqn[NVMF_NQN_FIELD_LEN - 1] = '\0';
+	d->hostnqn[NVMF_NQN_FIELD_LEN - 1] = '\0';
 	status = nvmet_alloc_ctrl(d->subsysnqn, d->hostnqn, req,
 				  le32_to_cpu(c->kato), &ctrl);
 	if (status) {
@@ -237,6 +239,8 @@ static void nvmet_execute_io_connect(struct nvmet_req *req)
 		goto out;
 	}
 
+	d->subsysnqn[NVMF_NQN_FIELD_LEN - 1] = '\0';
+	d->hostnqn[NVMF_NQN_FIELD_LEN - 1] = '\0';
 	ctrl = nvmet_ctrl_find_get(d->subsysnqn, d->hostnqn,
 				   le16_to_cpu(d->cntlid), req);
 	if (!ctrl) {
-- 
2.42.0



