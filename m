Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298A22D8793;
	Mon, 27 Oct 2025 19:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593357; cv=none; b=r4Q7FUO7E6dyF1y8o7FaDlBzkLWbsj+mJjEAdJipQCwDjvmndupUi8xsBSW7YgyWnPVUv7AvWNvyPrazSW0MhN68CaWfgsT/y+kWFJagTvTvkArhDiaySuSXWMwUU1k3QPNHqeu2k3UKXOL8fTJwVjt2gECn6UBnPZwU6+TSFHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593357; c=relaxed/simple;
	bh=yBRS6bLoLnShApop7VJQAzw5WxdFbyNAZ+TIoJLqXgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiKYV4gLbHK7k8Sl4s8Q8ecSTb+GsijCjO69PcnLEGC3Zo3680znM86XmizM29Z6qc60xsXmnsA2XgtW9Vk5vEUqsRCpokb9E5u1aJ4T1OUiUGuw/d84yfKnWEpJ4Iijtk+z1mlV4jz/v1B3tzHQNGGNX94KVy2Lc+j2vBq6fQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JGxR1Ls+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JGxR1Ls+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B8DC4CEF1;
	Mon, 27 Oct 2025 19:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593357;
	bh=yBRS6bLoLnShApop7VJQAzw5WxdFbyNAZ+TIoJLqXgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JGxR1Ls+ScpHhEESoS6226Wu8EMk4fSQc0TMy/QEnNypZlvf6V5YsVjwcmeSHJcu5
	 s+7MKNpiocira9g6gfl73Jthzuj8mvc4EuoCiNEKOJGASpNcwZYBfIz1H2Si/CZ4J6
	 bkI49Xxo6wqXEsv08ZLHdQD1yF67KUDEPZvEERTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.17 107/184] drm/xe: Check return value of GGTT workqueue allocation
Date: Mon, 27 Oct 2025 19:36:29 +0100
Message-ID: <20251027183517.803246330@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Matthew Brost <matthew.brost@intel.com>

commit ce29214ada6d08dbde1eeb5a69c3b09ddf3da146 upstream.

Workqueue allocation can fail, so check the return value of the GGTT
workqueue allocation and fail driver initialization if the allocation
fails.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20251022005538.828980-2-matthew.brost@intel.com
(cherry picked from commit 1f1314e8e71385bae319e43082b798c11f6648bc)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_ggtt.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/xe/xe_ggtt.c
+++ b/drivers/gpu/drm/xe/xe_ggtt.c
@@ -291,6 +291,9 @@ int xe_ggtt_init_early(struct xe_ggtt *g
 		ggtt->pt_ops = &xelp_pt_ops;
 
 	ggtt->wq = alloc_workqueue("xe-ggtt-wq", 0, WQ_MEM_RECLAIM);
+	if (!ggtt->wq)
+		return -ENOMEM;
+
 	__xe_ggtt_init_early(ggtt, xe_wopcm_size(xe));
 
 	err = drmm_add_action_or_reset(&xe->drm, ggtt_fini_early, ggtt);


