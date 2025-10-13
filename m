Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D997530C639;
	Mon, 13 Oct 2025 15:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368303; cv=none; b=sbpWYyETocVGvGea22zY9R1Z19Tkvyg7ngtFecIXIe9dUa9reT3seUUtgszXukmiRgNgBiAHxL0ZWTVaV4C9f3KfgBuQd3vt+7TdSYNr2yRq4jEHNo5S8IDun4IqTChwz69qWKVfYD+MLHVizjkqMKpCVzHNk8j8rOsGX6Xhun4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368303; c=relaxed/simple;
	bh=iCOAajrBgIwcJ0oEzyPXZQhOSuEU5xrzYGy65zbJY1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVJ51S2wzujw+lvxK127GWWM+yMzMOHMoptWrUhAGmLpBOdO9+zOs+1/slJFIHbpWGWMW5KfeZ4d4XRRM83qrErPLJqxHjsPK+sg1rhuSkIKhJJE1g4JlgbcQl38inhi++qoT9P4foJs2Ie7IVaSBdV4TOlpZncKMNr08lDoEis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRHdfyUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRHdfyUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046CAC4CEE7;
	Mon, 13 Oct 2025 15:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368303;
	bh=iCOAajrBgIwcJ0oEzyPXZQhOSuEU5xrzYGy65zbJY1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRHdfyUt0TQ9jv6TubCOcpl00Jz50VIPBeA8MWAQXxsgT2MoNnseYdsbq3mEN0uEm
	 po4Yb7uiUGluwutFUAMvS8BIFjdn52TCMVxW+sE/w7hBm9S8otxuTd9A9WEaxKT2UJ
	 M7phniVlmWpWATIKhpjgkcSYq7TuzoDQXp3ZrpHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanfang Zhang <quic_yuanfang@quicinc.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/262] coresight: Only register perf symlink for sinks with alloc_buffer
Date: Mon, 13 Oct 2025 16:44:17 +0200
Message-ID: <20251013144330.267443604@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index b7941d8abbfe7..f20d4cab8f1df 100644
--- a/drivers/hwtracing/coresight/coresight-core.c
+++ b/drivers/hwtracing/coresight/coresight-core.c
@@ -1200,8 +1200,9 @@ struct coresight_device *coresight_register(struct coresight_desc *desc)
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



