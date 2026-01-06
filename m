Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A562F5A29;
	Tue,  6 Jan 2026 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722522; cv=none; b=ULZ/oTPBE3E3cUWt3tb182ebVF/WzQ6uRre4RGIJBd1YgJWnr2HblSmZ2H09EfW2PEAnqv6EzLokXaNcW1XBcOEuboCx9be7zNUzztwV48doHLyfgMOTRP2Q1REfKWPwUbnJHj0T4URiaDKoDGwJvzE2/LfKNcaL3DskxoR/3BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722522; c=relaxed/simple;
	bh=04yWbFchua011NiNQVfSQtmYOZXP4JIsgyqgWDCttGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OiyoApKgunTJFrEAkeRGNjI7rY+OuYim4LiGXowUBsZmnWfkLoafxFR2d6iPija2qvD0FZqJxbP1iyglLTjLgYaLMNBSyNWftW8HnEx+Z2ynm3TF8x06BdURMOl8Qeoojemg/W8TnlxeBXYlxoFSuOtGkNNgVafm22cZ+yoBUfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsSmc5Dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsSmc5Dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D38C116C6;
	Tue,  6 Jan 2026 18:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722521;
	bh=04yWbFchua011NiNQVfSQtmYOZXP4JIsgyqgWDCttGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsSmc5DwTKEhUMdYxJwfB42D5tRSwDhBinJxQ/Cdtr8uJ/GK2q1jK4234Hp3UrrxS
	 jmCun8rbgfTvwKjxifAl7BQ7FlBvm0Ya0lVU4dlWynKUInHJ9bYYUZJzFidfkB4rBr
	 B3bXGb3DcdYWy7ce7GyLOr60egj6ZcOcvWsCzIBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Richter <Simon.Richter@hogyros.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.18 289/312] drm/ttm: Avoid NULL pointer deref for evicted BOs
Date: Tue,  6 Jan 2026 18:06:03 +0100
Message-ID: <20260106170558.309013054@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Richter <Simon.Richter@hogyros.de>

commit 491adc6a0f9903c32b05f284df1148de39e8e644 upstream.

It is possible for a BO to exist that is not currently associated with a
resource, e.g. because it has been evicted.

When devcoredump tries to read the contents of all BOs for dumping, we need
to expect this as well -- in this case, ENODATA is recorded instead of the
buffer contents.

Fixes: 7d08df5d0bd3 ("drm/ttm: Add ttm_bo_access")
Fixes: 09ac4fcb3f25 ("drm/ttm: Implement vm_operations_struct.access v2")
Cc: stable <stable@kernel.org>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/6271
Signed-off-by: Simon Richter <Simon.Richter@hogyros.de>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251013161241.709916-1-Simon.Richter@hogyros.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_bo_vm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -434,6 +434,11 @@ int ttm_bo_access(struct ttm_buffer_obje
 	if (ret)
 		return ret;
 
+	if (!bo->resource) {
+		ret = -ENODATA;
+		goto unlock;
+	}
+
 	switch (bo->resource->mem_type) {
 	case TTM_PL_SYSTEM:
 		fallthrough;
@@ -448,6 +453,7 @@ int ttm_bo_access(struct ttm_buffer_obje
 			ret = -EIO;
 	}
 
+unlock:
 	ttm_bo_unreserve(bo);
 
 	return ret;


