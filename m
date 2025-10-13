Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27A630DD1E;
	Mon, 13 Oct 2025 15:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369967; cv=none; b=uNODEXW5w43rwrvOY8blS8hdHZ+B4WCdGWw7HLo6Lklu7+rmMNdP74PTKLg3VfEVoHKvRlsOzUY32lX9Vf9RPbbD4ReKtX52vDkoto3oePhXIFPleg7cGk2gesYOV589XsN2A3dKjiGBZGKDFYtSmxsO2CGIRgv2Uw+gHr5upUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369967; c=relaxed/simple;
	bh=4X7OlA04FHKQvjSo7TX8RniNKBq8VO/MmJ25jJnmIQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+Pn3Q3xFRme4WhXwDMN4zuhb0RJOZ13cRa10J6gRKX8fReTLBpEb/kWK8QlF1xh0YW0JVHHA2Ch6X6lw5vcNEXFDoaCT3CWSURz5RuJ0Zmfmx+wfvZGFVdnk+WAxzg8fczU/l7PXIG2JmyYC2AfqmWW+b2DO6sW5U6PObro75s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0rC6B5rZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0rC6B5rZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34558C4CEE7;
	Mon, 13 Oct 2025 15:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369967;
	bh=4X7OlA04FHKQvjSo7TX8RniNKBq8VO/MmJ25jJnmIQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0rC6B5rZchAkQrdPNxFlamwtFZZ9GEagGZs7SzX1MX2yzlcntAsfSio8QF+WjqfxR
	 jS/s8OhEP3tdbvjF5tPOELwgFH8p0+Q6Tq7p+8S3E/X3b21QtcIF4XMhEXNcA5RClq
	 GxbP+lzTF4bNKSwDh3THhmLaAK+pNdFKzPJ1yq2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamas Zsoldos <tamas.zsoldos@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 431/563] coresight: trbe: Return NULL pointer for allocation failures
Date: Mon, 13 Oct 2025 16:44:52 +0200
Message-ID: <20251013144426.899310438@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 8a55c161f7f9c1aa1c70611b39830d51c83ef36d ]

When the TRBE driver fails to allocate a buffer, it currently returns
the error code "-ENOMEM". However, the caller etm_setup_aux() only
checks for a NULL pointer, so it misses the error. As a result, the
driver continues and eventually causes a kernel panic.

Fix this by returning a NULL pointer from arm_trbe_alloc_buffer() on
allocation failures. This allows that the callers can properly handle
the failure.

Fixes: 3fbf7f011f24 ("coresight: sink: Add TRBE driver")
Reported-by: Tamas Zsoldos <tamas.zsoldos@arm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20250904-cs_etm_auxsetup_fix_error_handling-v2-1-a502d0bafb95@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-trbe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-trbe.c b/drivers/hwtracing/coresight/coresight-trbe.c
index f78c9b9dc0087..3dd2e1b4809dc 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -749,12 +749,12 @@ static void *arm_trbe_alloc_buffer(struct coresight_device *csdev,
 
 	buf = kzalloc_node(sizeof(*buf), GFP_KERNEL, trbe_alloc_node(event));
 	if (!buf)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	pglist = kcalloc(nr_pages, sizeof(*pglist), GFP_KERNEL);
 	if (!pglist) {
 		kfree(buf);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 
 	for (i = 0; i < nr_pages; i++)
@@ -764,7 +764,7 @@ static void *arm_trbe_alloc_buffer(struct coresight_device *csdev,
 	if (!buf->trbe_base) {
 		kfree(pglist);
 		kfree(buf);
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 	}
 	buf->trbe_limit = buf->trbe_base + nr_pages * PAGE_SIZE;
 	buf->trbe_write = buf->trbe_base;
-- 
2.51.0



