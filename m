Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76DF4657F4;
	Tue, 16 Jun 2026 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625458; cv=none; b=cV2AnbDVNi7ltvILbxWWI2Xdx5GCwSZ7pNR6V59wLMrHIEEl6Kbff/6SA83C56RYO3fMii1MSh9LvknT194hUfHOvh25EakHRMBr5m8BU/fEeDu1A6PGvFk0a6CCzQ4IfIhiw1qANo0R8AbYAm6IEdh3MnIMayq6IOYH6nQxyFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625458; c=relaxed/simple;
	bh=45JWa4cp3crATvYp9GpmC9nqhz6Qnpj02ptGw0eZGCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy+cb1s45HEHrosPXq4g3omXLDqxy6qazm6L8PvJoNLGXyX19Jcp50Sz62qJvlIV1RopkkBJ8T6T3mLjZl3I+xAGZ4kGY3VJyA75SLz8hLIVnre71jLlUU8B1k2p8dXFNYtSiRziGtcfbbSBb5JHoOFFYIinBqj9fJ5VtXYNiBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhc/SRQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhc/SRQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7911F00A3E;
	Tue, 16 Jun 2026 15:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625457;
	bh=i37fwSJQRvMXhwfAFVNpIx4fVBJRn3wlR3MW5MKE2tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhc/SRQMfqhsWGn2hf+fUkUkqNwSAd4wMMmDkS6cByJYlfF7Pl8rJmZff3B2DOkOh
	 CvvsJw29Kp5Aet96TN4c4hUK3q/cMCORiy9x5nUHZGNsfh8fuqkgeC9Q1Nh8F5KHnH
	 NYCTt3g1SvKO69A7SkkTpUrk/xiWB+Dx30j/NM34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/325] drm/xe: fix refcount leak in xe_range_fence_insert()
Date: Tue, 16 Jun 2026 20:29:01 +0530
Message-ID: <20260616145104.951147060@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ba36786b21d19082e696eda85bfcd49e7071944a ]

xe_range_fence_insert() acquires a reference on fence via
dma_fence_get() and stores it in rfence->fence.  It then calls
dma_fence_add_callback() and handles two cases: when the callback
is successfully registered (err == 0) the fence is transferred to
the tree for later cleanup; when the fence is already signaled
(err == -ENOENT) it manually drops the extra reference with
dma_fence_put(fence).

However, dma_fence_add_callback() can fail with other errors
(e.g. -EINVAL) and in that case the code falls through to the free:
label without releasing the acquired reference, leaking it.

Fix the leak by adding an else branch that calls dma_fence_put()
before jumping to free: for any error other than -ENOENT.

Fixes: 845f64bdbfc9 ("drm/xe: Introduce a range-fence utility")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260610172705.3450560-1-matthew.brost@intel.com
(cherry picked from commit 98c4a4201290823c2c5c7ba21692bd9a64b61021)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_range_fence.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_range_fence.c b/drivers/gpu/drm/xe/xe_range_fence.c
index 372378e89e9892..3d8fa194a7b0eb 100644
--- a/drivers/gpu/drm/xe/xe_range_fence.c
+++ b/drivers/gpu/drm/xe/xe_range_fence.c
@@ -77,6 +77,8 @@ int xe_range_fence_insert(struct xe_range_fence_tree *tree,
 	} else if (err == 0) {
 		xe_range_fence_tree_insert(rfence, &tree->root);
 		return 0;
+	} else {
+		dma_fence_put(fence);
 	}
 
 free:
-- 
2.53.0



