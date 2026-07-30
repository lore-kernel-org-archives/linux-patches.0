Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D22839C00E;
	Thu, 30 Jul 2026 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424303; cv=none; b=QLA+9d7ikA4Zk9230hAaRHzGHeFei0Yb8wy3J0FY7/lz3GsYa9qAJhOIrJS2wyO75SnPvCvtwpn3t/hbUkdviyC99ZnXNjZZ5dg+PdKVKWfvi+xbmhvEOE/7GeILc3TMRIIat0rgJpODrbypqfo63yxsGq4yrtC2LZF7/+kihAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424303; c=relaxed/simple;
	bh=phfhJla3FVHyIz0lWNgBzEWwchkc5oygbwGTz+v198A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q+VWEbq4WmpryUyGzflczSdVSZ4yZWopYmxSQwo9sKU6MdekI2AR525Y9KJg9xnzi0oz8CmlmzM3GSzbA74qDjv9hteuNNm9s41MR+/rMgS7w7JGi+6nNZhcpV1MiVL2pKnPMlTcc8JZrn1JyZwuznEH2Q4x1FPJIsSuN1u6+MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlgavLXj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlgavLXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728F61F000E9;
	Thu, 30 Jul 2026 15:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424302;
	bh=S5FxtaBM3AR6PHbGi3aaDGkWy7Nuv5ZPeqjvwEOr/SE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jlgavLXj85VMV07ozU8LzWBj33y99Ui+TKsjCBfIxij8orD5VYgrA2paViPwYEfaX
	 2ZGfnLbm8/VQ38MVecgpWxHrtpnqBK0CdYx8eSGJN4ycKh1JUBsxGreltURNK+MxmN
	 sbz1Al/CBnYhBTsl4RiQOMcldWwBgdaD4HSbWeJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 345/675] drm/xe: Return error on non-migratable faults requiring devmem
Date: Thu, 30 Jul 2026 16:11:15 +0200
Message-ID: <20260730141452.465342143@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit 136fb61ba8571076dc5d49350a0e6d002d740b74 upstream.

Non-migratable faults that require devmem incorrectly jump to the 'out'
label, which squashes the error code intended to be returned to the
upper layers. Fix this by returning -EACCES instead.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 4208fac3dce5 ("drm/xe: Add more SVM GT stats")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Link: https://patch.msgid.link/20260617135101.1245574-1-matthew.brost@intel.com
(cherry picked from commit c4508edb2c723de93717272488ea65b165637eac)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_svm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -1074,10 +1074,8 @@ retry:
 
 	xe_svm_range_fault_count_stats_incr(gt, range);
 
-	if (ctx.devmem_only && !range->base.pages.flags.migrate_devmem) {
-		err = -EACCES;
-		goto out;
-	}
+	if (ctx.devmem_only && !range->base.pages.flags.migrate_devmem)
+		return -EACCES;
 
 	if (xe_svm_range_is_valid(range, tile, ctx.devmem_only)) {
 		xe_svm_range_valid_fault_count_stats_incr(gt, range);


