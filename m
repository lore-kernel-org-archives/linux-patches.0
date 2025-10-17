Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6540C330B2D;
	Fri, 17 Oct 2025 15:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716155; cv=none; b=ieDhJ8G/ZWN9hrkykrsFnDUQhgxzbzkRjtdwtOolKHOLgOQ0ODqV4HBCX9nc61fn8oD1CmDnDCpxO5Tb4JBCgipy4qkb0XsTCG9F+PDY9LJVb9/mW4PIlnrRiN4U9nBqXrUnR7LZlGvk5Ifx2cblzIZ7Gk0WL3KZylwA7NfFOZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716155; c=relaxed/simple;
	bh=4hTX4CVoyzrHK+QJbnyUiCfJibAO/ZVtwGjtphCxwRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LI4w8q0gKO04ekF5fjqhEDv70D+v+UCO+Clr1jedTwg/7b5aipRbSb1a/sbCwQ+kQEnXKBq3CbFFG7e4sQLFrEiRgTGbYBmhU/qMCLQDBzdf4RDIycFFZFv+rMPWynTu8pxNxHbG12Wr7zHVad+OL8aDO3dlaxlH6HiNQ+keg8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPsOscxY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPsOscxY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4AAC4CEFE;
	Fri, 17 Oct 2025 15:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716155;
	bh=4hTX4CVoyzrHK+QJbnyUiCfJibAO/ZVtwGjtphCxwRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPsOscxY0hLnSvlqe7Q/DZVZmvsqo/sW0xSf2WCvnHAxvjsFqaF2pWP63iQTVaDax
	 aiV4BPcXPrBNFs8qffmFr9BmUQifFVzq/N5gcWbJaoLjd5DJotx9vZ4TrJbS6bxhG1
	 a2f7a6wLOJn7SXj44cA+EAgzxALz3U/PYv6Rgqe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamas Zsoldos <tamas.zsoldos@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/276] coresight: trbe: Return NULL pointer for allocation failures
Date: Fri, 17 Oct 2025 16:53:05 +0200
Message-ID: <20251017145145.845752980@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 732a4bed3f207..dfdb5d4263259 100644
--- a/drivers/hwtracing/coresight/coresight-trbe.c
+++ b/drivers/hwtracing/coresight/coresight-trbe.c
@@ -503,12 +503,12 @@ static void *arm_trbe_alloc_buffer(struct coresight_device *csdev,
 
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
@@ -518,7 +518,7 @@ static void *arm_trbe_alloc_buffer(struct coresight_device *csdev,
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



