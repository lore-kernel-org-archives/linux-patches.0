Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98A33B9D91;
	Fri, 15 May 2026 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862383; cv=none; b=ccOHYAEuhDK84lzHZxg2U1gg77QzBhDKICeXSJcEo12NV4FVdTOPxt1MYc7tjlzvpukSz/utMw3599fGe84s4uoB0Pt1mLzg0H7Ufjvzkxsrbgp2KMbk9dPAvin3JqOcQpqWRfJUrLLPOCMQ8ao3YXJX5qgsJJsa9uNxO9hy0Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862383; c=relaxed/simple;
	bh=gSv5+V5pZ6S1kulaZmXhGh2AaZCLRQ/FIhZJUAlXLbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbhO4JvPycO9QzirQe9vySwcBNsut3NQJ8RdjKW/FAp4eQ2RyzG1/Y/tJ/JzqqDUHJ9cZSNLLA+FmXEEODcMRgxKws53bS/D2VgQw3/tsNK4C0ACAILnYSXogeyJFH5CZtigMI0XLOmTLpeNHmszfnyCdUGO0A904y/C1om++2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMyr+5ZX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMyr+5ZX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CDBC2BCB0;
	Fri, 15 May 2026 16:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862382;
	bh=gSv5+V5pZ6S1kulaZmXhGh2AaZCLRQ/FIhZJUAlXLbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMyr+5ZXBWa6utvQym+wUQ491ROhCLNKxWLCjCy323lCa7YEgFW7zrsAdteKZDV5k
	 CefckdHKF6N6O2JAUWJhgKuvz+5vUwk1J+JSCqQvVFymhHHH8yW5KMcpgOvWIgnxrJ
	 p9HrjYy6nkYqWwS6jln0MexV/fOAnFhu/rzoCZ5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH 7.0 027/201] drm/gpusvm: Force unmapping on error in drm_gpusvm_get_pages
Date: Fri, 15 May 2026 17:47:25 +0200
Message-ID: <20260515154659.121115023@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 556dba95473900073a6c03121361c11f646dc551 upstream.

drm_gpusvm_get_pages() only sets the local flags prior to committing the
pages. If an error occurs mid-mapping, has_dma_mapping will be clear,
causing the unmap function to skip unmapping pages that were
successfully mapped before the error. Fix this by forcibly setting
has_dma_mapping in the error path to ensure all previously mapped pages
are properly unmapped.

Fixes: 99624bdff867 ("drm/gpusvm: Add support for GPU Shared Virtual Memory")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Francois Dugast <francois.dugast@intel.com>
Link: https://patch.msgid.link/20260130194928.3255613-2-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_gpusvm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -1572,6 +1572,7 @@ set_seqno:
 	return 0;
 
 err_unmap:
+	svm_pages->flags.has_dma_mapping = true;
 	__drm_gpusvm_unmap_pages(gpusvm, svm_pages, num_dma_mapped);
 	drm_gpusvm_notifier_unlock(gpusvm);
 err_free:


