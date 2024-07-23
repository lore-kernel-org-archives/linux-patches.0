Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9E31581F4;
	Tue, 23 Jul 2024 18:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760152; cv=none; b=UAQUIurlx2VGuEg2EntUifqACatACN3S2wP8fsx3qfNCF0s41FaOi8Fz+RqSIBJeUgxx7da7Os6cbTpKc/ikyEfj5ce1RraQs2tQcJbFaSZBmiz092TQ80OAk4Ar35YNutfkdkAUfEPOTSWnjOF9ExB2he6v/2rH989uA5LTkxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760152; c=relaxed/simple;
	bh=igZJJG5b608FNv/W6tVMzLQ6Z6xzfJRgIv3UmO63eZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suFZWoof1IMhrKwbF5bqEINUoT9aodskr7sSvEvijHnBE4uSdwfN8itDkQ99vCVWCyHsNEx1SJU1K3YQzez7iSpxudqkVy9CHcWM0phYxdwH8CHLM4zw+mztxKxG64wzjKocf/GHJgHOU2zmu6docS9/P4cVk+yoaftoY7L6+m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EuNsW5mY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EuNsW5mY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75FB8C4AF09;
	Tue, 23 Jul 2024 18:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760151;
	bh=igZJJG5b608FNv/W6tVMzLQ6Z6xzfJRgIv3UmO63eZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuNsW5mYRfb90vUXhSMVGYfiFaxtNnMLxF4Gxe8bQCu7HZgcAtzj267I2JT10XIfj
	 ZZnXMgzJTVCw7MQgfiRO7hL50CF/+2wbR+Rl1JPCybr/LBPVFj9sCgXAz3O6Sw5+3F
	 XCu+8ED93egFHXR/U33sfaydkdq5E2aQs9rzFPb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boyang Yu <yuboyang@dapustor.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 102/163] nvme: fix NVME_NS_DEAC may incorrectly identifying the disk as EXT_LBA.
Date: Tue, 23 Jul 2024 20:23:51 +0200
Message-ID: <20240723180147.417642011@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boyang Yu <yuboyang@dapustor.com>

[ Upstream commit 9570a48847e3acfa1a741cef431c923325ddc637 ]

The value of NVME_NS_DEAC is 3,
which means NVME_NS_METADATA_SUPPORTED | NVME_NS_EXT_LBAS. Provide a
unique value for this feature flag.

Fixes 1b96f862eccc ("nvme: implement the DEAC bit for the Write Zeroes command")
Signed-off-by: Boyang Yu <yuboyang@dapustor.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/nvme.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index d7bcc6d51e84e..3f2b0d41e4819 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -503,7 +503,7 @@ static inline bool nvme_ns_head_multipath(struct nvme_ns_head *head)
 enum nvme_ns_features {
 	NVME_NS_EXT_LBAS = 1 << 0, /* support extended LBA format */
 	NVME_NS_METADATA_SUPPORTED = 1 << 1, /* support getting generated md */
-	NVME_NS_DEAC,		/* DEAC bit in Write Zeores supported */
+	NVME_NS_DEAC = 1 << 2,		/* DEAC bit in Write Zeores supported */
 };
 
 struct nvme_ns {
-- 
2.43.0



