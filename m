Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09BE3563C7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300978; cv=none; b=IHdHZY5k/KLMYGHLIFLnFdcCYw7ijG/dxT6UGlIhYKfeSLGEf9sLP+B449kBb+7r4t6wQVNatHzzBNs5nNyoazwgIPN+y6mnFz32aKHp75pb4PI7AQWxaXXVIzkDdyPgE8iAd4lX5lv5cH7gFCc6qC+z6uAXrTQQRYuLN+Ns9r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300978; c=relaxed/simple;
	bh=YwzkTUapR3rN6EhfIZD15cvrV5UM/CkNF2kJYNiMxGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG+h6Xs5xZ00fMdDPccOdID8L2KnyiLyc56ivHZBhZboDxT1KFA01Lp1d4j4fFO0McdOARZHhmb7gx2NUOySKKTtaEIWJiFwTyaEXYO76UF09M36AoUACXfdIsj6GJ0r62obFNCDcpS9ZaWYQH6co6JUaSvrwpfhSGKqcNd/TFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WCnlFRYz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WCnlFRYz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7D9C19425;
	Sat, 28 Feb 2026 17:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300977;
	bh=YwzkTUapR3rN6EhfIZD15cvrV5UM/CkNF2kJYNiMxGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WCnlFRYz4p+wWO7IhWHxum5jCLKweE1gnhCzvj0rByelp45V+RBzVcW6nfd3YJqHY
	 20dyQnV/8+qS4+c8sgmwb6Yg9MkVxh8uGrLvZO4FHpcAkjtscrcmlvj2Q2ebC1aK90
	 BDp9+e7oWdmKdMjHBipEOY7ObB8gaqDzB9EwxHnLwHjFAkSUwQa6d8F5O/s3MjpY/s
	 2aS1z4w+a3M6eTAF6OcvT9gxSF9543sDYAgi+giIYRtHyyDviUE0Atfd9jLVjy3yEF
	 B+FpVwT63dwzRdlgghUjbyJ6ZkhhVl9ktJ+11Sk+tqEtNrnua9+Ff/QW/eQkk2qmh1
	 GPaC3fMAM3ZDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/752] drm/xe: Covert return of -EBUSY to -ENOMEM in VM bind IOCTL
Date: Sat, 28 Feb 2026 12:36:57 -0500
Message-ID: <20260228174750.1542406-106-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 6028f59620927aee2e15a424004012ae05c50684 ]

xe_vma_userptr_pin_pages can return -EBUSY but -EBUSY has special
meaning in VM bind IOCTLs that user fence is pending that is attached to
the VMA. Convert -EBUSY to -ENOMEM in this case as -EBUSY in practice
means we are low or out of memory.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patch.msgid.link/20251122012502.382587-2-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_vm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 145cd9ffa36b3..2444800d0fd35 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -2422,8 +2422,17 @@ static struct xe_vma *new_vma(struct xe_vm *vm, struct drm_gpuva_op_map *op,
 		if (IS_ERR(vma))
 			return vma;
 
-		if (xe_vma_is_userptr(vma))
+		if (xe_vma_is_userptr(vma)) {
 			err = xe_vma_userptr_pin_pages(to_userptr_vma(vma));
+			/*
+			 * -EBUSY has dedicated meaning that a user fence
+			 * attached to the VMA is busy, in practice
+			 * xe_vma_userptr_pin_pages can only fail with -EBUSY if
+			 * we are low on memory so convert this to -ENOMEM.
+			 */
+			if (err == -EBUSY)
+				err = -ENOMEM;
+		}
 	}
 	if (err) {
 		prep_vma_destroy(vm, vma, false);
-- 
2.51.0

