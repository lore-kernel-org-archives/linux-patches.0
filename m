Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A64424A063;
	Mon, 13 Oct 2025 15:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367647; cv=none; b=V2rSC4Wmw2lJ9xbfL3NSC6/RTtNr4mylEm9g2w5eLq8FBmNoaotV/20kO+g2dbFaoSc+/5NLh0Ue8yYxvP6d3S2odkV9ZBqO5ykwcFmVVAo1vDGdGyBJOSke8S7Q/kSrkqdu3S6W2iHPbRE9q8Fm6zEmvC7ifG7OOj6Bsrt60ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367647; c=relaxed/simple;
	bh=Ejs6OJfUJ5Lmv/NgJxD2LZ0IxwJPlY2ZV7weqN1p9qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYhxT1c9wCrjf018NrB2/KPnQbktF5ZuJIFBKX7uAXIL6gKIW/gvd05yLrpkJN18Qv+FSZgxesXvzBvy+K/o1GiYe8tHh2bBRcm3RkLxIU5EBF48WRBk2nivtGmhOM/U9TBrFTEdBYzC2MoMXjFnPqjvNMxLUZSCteoh35RTXpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li1bIZCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li1bIZCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3612C4CEE7;
	Mon, 13 Oct 2025 15:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367647;
	bh=Ejs6OJfUJ5Lmv/NgJxD2LZ0IxwJPlY2ZV7weqN1p9qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=li1bIZCee7YCjfD9tSwl/isvWg7XaGYUxPwg7IEe3JAcvHXEuzFHeGjBxDmdN/kXP
	 PQ82V5zEVIDJWP/44yIbTeMlsq1QUXV/8uGZIPDnMw4uaTNCkT8+Dxx8og02ioGL4D
	 wkib89GghtC/vB/PwKggu5Oe0opzKi8lRd0VYeM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfang Zhang <quic_yuanfang@quicinc.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/196] coresight: Only register perf symlink for sinks with alloc_buffer
Date: Mon, 13 Oct 2025 16:44:35 +0200
Message-ID: <20251013144318.357472043@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3b57851869eaa..a836952737209 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1638,8 +1638,9 @@ struct coresight_device *coresight_register(struct coresight_desc *desc)
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



