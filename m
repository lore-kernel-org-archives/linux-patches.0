Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD092FD699;
	Fri,  9 Jan 2026 12:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961062; cv=none; b=VuwnNdsVrxo+wHCoUkxA93vucXih7JYyN31G8nFfVpbwDFUFlnWxHKlhN43rOI7yA24FrpIDbWpFhwdj3deqvI+NtMs8vRuexr5IiWvmLnwi3dB7FbcQbPKddkoro81pV5Ivs9emlzgoHrGhyq31xDz4pT+o/FQxLOOMyAvBWzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961062; c=relaxed/simple;
	bh=m6b6YGAHskvvDlv30da2myaSRIpbTqXIoLlsS3EV4wU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MzokI48agjPHABaNNelF9S5ZPtMig8HujqcH5heo06cg0NSVyaw/PNrHlY6/nNhNuGGifxFH/jESti2LWi0zJcgFXNcAdP3ZqMT8g4lc/2u03MSF46p7PsKCku71TADCRcQ0ZzkIE4t+/g9OUeZxqYwDTltsmAq8U6/hm0L7Enw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kn0cw4i1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kn0cw4i1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9188C4CEF1;
	Fri,  9 Jan 2026 12:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961062;
	bh=m6b6YGAHskvvDlv30da2myaSRIpbTqXIoLlsS3EV4wU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kn0cw4i1Eo8WP1ZwiGxOGKAGSWzuLQK7L33cQCIB44PIVPcuXr4SXRZeZduSxp+ku
	 WUKrPvG5MQJ57PJrlv0JkKvlJ5ZXRq6Lpqf69pcruRLsx7icHC+l2C2Z6TR1J3Jjq/
	 xoh2lYDDa8jpJTpA1B+EtL17QQvlEdGjNmv7WvBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Simon Richter <Simon.Richter@hogyros.de>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.6 621/737] drm/ttm: Avoid NULL pointer deref for evicted BOs
Date: Fri,  9 Jan 2026 12:42:40 +0100
Message-ID: <20260109112157.363718527@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -421,6 +421,11 @@ int ttm_bo_vm_access(struct vm_area_stru
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
@@ -435,6 +440,7 @@ int ttm_bo_vm_access(struct vm_area_stru
 			ret = -EIO;
 	}
 
+unlock:
 	ttm_bo_unreserve(bo);
 
 	return ret;


