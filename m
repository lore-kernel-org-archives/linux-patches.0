Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBE43E7BA4;
	Fri, 15 May 2026 16:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861884; cv=none; b=GB9kbvSzTq74fgCE1bI+1uoClCghWChCZzoEVSCNPJCnyWaHoOzUzcYUaxtuepJiHCDdrTjZUqOOqnp32FxhTkD84RKpdoUPPIwIqsrEte5oitV817inkDAgT9QWKuf69UcI/ygMYVSlPSJSw8Yx66qq0nqubwclXzJSnL7cTOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861884; c=relaxed/simple;
	bh=2mNBC1Sp7MnoM18v5VT0ww/T4yTwCKOE1ngrX8nHFvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di00B7D9ksAJKqEGVQwNsdSBb6r/FutHfLEXzEnFg1rBUuHw4iL0zO0FsekqabIqZ580rlUAStzdHq0sXyGnVGD21ZnUK/ZXcK6CdxmfjU2nI4urexRybgC93c4DqPEzooTFDuxsWXs20o1i7/k6HhiXN6K9CJdPPxtMWZ/8qi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVQkJ5eQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVQkJ5eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638F0C2BCB0;
	Fri, 15 May 2026 16:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861884;
	bh=2mNBC1Sp7MnoM18v5VT0ww/T4yTwCKOE1ngrX8nHFvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVQkJ5eQ8qnSTo38Ya5nLI/e1TzylatSxJhsGAH2NMSZqaOshYSySMlJtWcPpzoJf
	 eqGEiNsw6FZt30nzWo45Qx1JWSClIC6MXTV8WRZhW+ZzVF63hppFq4p3ohJUn2Z1s6
	 hx0j6s5Ut69RbN1/BF1VoLKx2xYrM/vQtBBNOBMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH 6.18 018/188] drm/gpusvm: Force unmapping on error in drm_gpusvm_get_pages
Date: Fri, 15 May 2026 17:47:15 +0200
Message-ID: <20260515154657.702837243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
@@ -1443,6 +1443,7 @@ set_seqno:
 	return 0;
 
 err_unmap:
+	svm_pages->flags.has_dma_mapping = true;
 	__drm_gpusvm_unmap_pages(gpusvm, svm_pages, num_dma_mapped);
 	drm_gpusvm_notifier_unlock(gpusvm);
 err_free:


