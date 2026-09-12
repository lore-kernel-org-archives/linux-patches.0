Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86E047CC92;
	Sat, 12 Sep 2026 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217996; cv=none; b=PgjOa1mMJWhQv0kYmoctUxmvzSeJ+ITJRPIgDPxLEC/h5ox3AQdGQDSAb7dQtdGOP1Wt/j3Up3tKU8RgP/A+FGSh0TyEEGjalEj7w+gb0QejxZDo3Sq29c1DX/HOgMDkCSrHWZEcYC3c9bxLT9c9B3NCJTMjB7qKSTG5b5r/r4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217996; c=relaxed/simple;
	bh=ta7UYtrNrLWPW4RhDSKdqJndh8vQck+o+yTf3g+mFDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z5nJ312gnwxh3RKJMmPdOF1vxx9gqtRu1XxQsCQZY0VrUluEj1dXdf1nifd63JkNQEf81+pNHxHC0FYg84C/raICOgFt0p586hUIWdChso0HC6TW/1RvFQD40stHhGW8tYR1mkrUqfQE7uTEpjusYhtb5rEBteCP9kFLuxoVs+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5bNavME; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5bNavME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9741F000FF;
	Sat, 12 Sep 2026 12:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217995;
	bh=i+5q7Kv8WkZ9upBC1LCbMLPcVHM0+9GX1OegD3EvoYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5bNavMEovg2PpMUXW0dotuDPqGWzu5EfLn4LlPm6H8VKqSszwnjsvcOxVWXHMfbB
	 8eRNgu/fvVxakFniCNVHDOZU2wAQvOTHMw+vZd9Q7vTwMRh3MDT0UKqxJw+bs3zg6W
	 WSwZWq6lK1EVBjW0jk6lBkD8qtw1Vh1xY6b63qq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1053/1376] nvme: add reservation commands defines
Date: Sat, 12 Sep 2026 08:57:59 +0200
Message-ID: <20260912065631.029190133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 1900e1a4495b7376cb9b4e58f1d846660f4c9c4b ]

This is a preparation patch for NVMeOF target reservation
commands implantation.
Add the defines of reservation command, such as reservation log
and sub operations.

Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Tested-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 5bb96cc21883 ("nvmet: fix heap out-of-bounds read in nvmet_auth_negotiate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/nvme.h | 68 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 84d4f0657b7a8..0095ce3748a10 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -2038,4 +2038,72 @@ struct nvme_completion {
 #define NVME_MINOR(ver)		(((ver) >> 8) & 0xff)
 #define NVME_TERTIARY(ver)	((ver) & 0xff)
 
+enum {
+	NVME_AEN_RESV_LOG_PAGE_AVALIABLE	= 0x00,
+};
+
+enum {
+	NVME_PR_LOG_EMPTY_LOG_PAGE			= 0x00,
+	NVME_PR_LOG_REGISTRATION_PREEMPTED		= 0x01,
+	NVME_PR_LOG_RESERVATION_RELEASED		= 0x02,
+	NVME_PR_LOG_RESERVATOPM_PREEMPTED		= 0x03,
+};
+
+enum {
+	NVME_PR_NOTIFY_BIT_REG_PREEMPTED		= 1,
+	NVME_PR_NOTIFY_BIT_RESV_RELEASED		= 2,
+	NVME_PR_NOTIFY_BIT_RESV_PREEMPTED		= 3,
+};
+
+struct nvme_pr_log {
+	__le64			count;
+	__u8			type;
+	__u8			nr_pages;
+	__u8			rsvd1[2];
+	__le32			nsid;
+	__u8			rsvd2[48];
+};
+
+struct nvmet_pr_register_data {
+	__le64	crkey;
+	__le64	nrkey;
+};
+
+struct nvmet_pr_acquire_data {
+	__le64	crkey;
+	__le64	prkey;
+};
+
+struct nvmet_pr_release_data {
+	__le64	crkey;
+};
+
+enum nvme_pr_capabilities {
+	NVME_PR_SUPPORT_PTPL				= 1,
+	NVME_PR_SUPPORT_WRITE_EXCLUSIVE			= 1 << 1,
+	NVME_PR_SUPPORT_EXCLUSIVE_ACCESS		= 1 << 2,
+	NVME_PR_SUPPORT_WRITE_EXCLUSIVE_REG_ONLY	= 1 << 3,
+	NVME_PR_SUPPORT_EXCLUSIVE_ACCESS_REG_ONLY	= 1 << 4,
+	NVME_PR_SUPPORT_WRITE_EXCLUSIVE_ALL_REGS	= 1 << 5,
+	NVME_PR_SUPPORT_EXCLUSIVE_ACCESS_ALL_REGS	= 1 << 6,
+	NVME_PR_SUPPORT_IEKEY_VER_1_3_DEF		= 1 << 7,
+};
+
+enum nvme_pr_register_action {
+	NVME_PR_REGISTER_ACT_REG		= 0,
+	NVME_PR_REGISTER_ACT_UNREG		= 1,
+	NVME_PR_REGISTER_ACT_REPLACE		= 1 << 1,
+};
+
+enum nvme_pr_acquire_action {
+	NVME_PR_ACQUIRE_ACT_ACQUIRE		= 0,
+	NVME_PR_ACQUIRE_ACT_PREEMPT		= 1,
+	NVME_PR_ACQUIRE_ACT_PREEMPT_AND_ABORT	= 1 << 1,
+};
+
+enum nvme_pr_release_action {
+	NVME_PR_RELEASE_ACT_RELEASE		= 0,
+	NVME_PR_RELEASE_ACT_CLEAR		= 1,
+};
+
 #endif /* _LINUX_NVME_H */
-- 
2.53.0



