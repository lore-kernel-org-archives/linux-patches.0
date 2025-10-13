Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6288530BBAE;
	Mon, 13 Oct 2025 15:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369597; cv=none; b=qlKtdBrLzwo2l8je4pVNH85GgI/RgV7b7aP9YHIME7Xp4J/XkUeW1sW0v04r1bFry7zM5OKR+XeV4rXK9ozVKGfKVdbcx2LuIUOOGTdX30uhewSC24xtLu1OI5ACGPdtH2CuVhBmGIU5eDYY7vX9hJy/EJpT+yTmq07y5EZJhY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369597; c=relaxed/simple;
	bh=vmwHNiNZT+vfR7uxm+6EsPLVHBvfQmGu2IhcxYR6DpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zv4MVU2b1s2Rt1j1J5QhjPSDXkqgdG0xM/r1K56TU5jHSf5sUsFqdqiOk2VvZc7pCVokPPHP0uVfhqp2VpLSvn1RyO0Wx5fUTQedytzM27+tMaT6PTTmV7WfPON1jBUOTOQydzrgI2W+H4ineb+lg2dOKszxm9R2pphuRzjdLbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUZ6aSCn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUZ6aSCn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3770C4CEE7;
	Mon, 13 Oct 2025 15:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369597;
	bh=vmwHNiNZT+vfR7uxm+6EsPLVHBvfQmGu2IhcxYR6DpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUZ6aSCnNKoU9FdYv/gIQ3fo8apBFmnRfop5LGp/n21mZenZvAPBk3ScbxbbPzzDL
	 iS/NQI2j06gUnTJt9rFDBJNqeq0WLs8jUlgRW2pzjjVMmsyIV9nktEw0ixBBUXhJmN
	 iE04Wk7cWSgLPZOUOwdozb75VkBbDBeaJqlRZhKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfang Zhang <quic_yuanfang@quicinc.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 301/563] coresight: Only register perf symlink for sinks with alloc_buffer
Date: Mon, 13 Oct 2025 16:42:42 +0200
Message-ID: <20251013144422.172318119@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanfang Zhang <quic_yuanfang@quicinc.com>

[ Upstream commit 12d9a9dd9d8a4f1968073e7f34515896d1e22b78 ]

Ensure that etm_perf_add_symlink_sink() is only called for devices
that implement the alloc_buffer operation. This prevents invalid
symlink creation for dummy sinks that do not implement alloc_buffer.

Without this check, perf may attempt to use a dummy sink that lacks
alloc_buffer operationsu to initialise perf's ring buffer, leading
to runtime failures.

Fixes: 9d3ba0b6c0569 ("Coresight: Add coresight dummy driver")
Signed-off-by: Yuanfang Zhang <quic_yuanfang@quicinc.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250630-etm_perf_sink-v1-1-e4a7211f9ad7@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-core.c b/drivers/hwtracing/coresight/coresight-core.c
index c2db94f2ab237..1accd7cbd54bf 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1375,8 +1375,9 @@ struct coresight_device *coresight_register(struct coresight_desc *desc)
 		goto out_unlock;
 	}
 
-	if (csdev->type == CORESIGHT_DEV_TYPE_SINK ||
-	    csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) {
+	if ((csdev->type == CORESIGHT_DEV_TYPE_SINK ||
+	     csdev->type == CORESIGHT_DEV_TYPE_LINKSINK) &&
+	    sink_ops(csdev)->alloc_buffer) {
 		ret = etm_perf_add_symlink_sink(csdev);
 
 		if (ret) {
-- 
2.51.0



