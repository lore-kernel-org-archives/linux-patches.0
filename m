Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E0F257C
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:05:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF4CC433D2;
	Thu, 23 Feb 2023 13:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157532;
	bh=bq7juG6ZPZ+eTRGOH+maY2oituv+3GGs4w80wdlurb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrPRmcB8kuB3IzxqcHf3uPHprxuw28k06r3sK5HwopRWvH2AsDqRgq6faLRoAcP82
	 loVLD7FfSXw7x4bD2RJXL1ItdJJaC86Wg/y+u/HEcdXG6NTXKbPac27Uenhy5B9AfT
	 +06nTH7KUeXqtN/e6ihIDdlr6SEJcL/THcXdIk+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Subject: [PATCH 4.19 07/11] drm/i915/gvt: fix double free bug in split_2MB_gtt_entry
Date: Thu, 23 Feb 2023 14:04:48 +0100
Message-Id: <20230223130424.340753788@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130424.079732181@linuxfoundation.org>
References: <20230223130424.079732181@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

commit 4a61648af68f5ba4884f0e3b494ee1cabc4b6620 upstream.

If intel_gvt_dma_map_guest_page failed, it will call
ppgtt_invalidate_spt, which will finally free the spt.
But the caller function ppgtt_populate_spt_by_guest_entry
does not notice that, it will free spt again in its error
path.

Fix this by canceling the mapping of DMA address and freeing sub_spt.
Besides, leave the handle of spt destroy to caller function instead
of callee function when error occurs.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20221229165641.1192455-1-zyytlz.wz@163.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/gtt.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1155,10 +1155,8 @@ static int split_2MB_gtt_entry(struct in
 	for_each_shadow_entry(sub_spt, &sub_se, sub_index) {
 		ret = intel_gvt_hypervisor_dma_map_guest_page(vgpu,
 				start_gfn + sub_index, PAGE_SIZE, &dma_addr);
-		if (ret) {
-			ppgtt_invalidate_spt(spt);
-			return ret;
-		}
+		if (ret)
+			goto err;
 		sub_se.val64 = se->val64;
 
 		/* Copy the PAT field from PDE. */
@@ -1177,6 +1175,17 @@ static int split_2MB_gtt_entry(struct in
 	ops->set_pfn(se, sub_spt->shadow_page.mfn);
 	ppgtt_set_shadow_entry(spt, se, index);
 	return 0;
+err:
+	/* Cancel the existing addess mappings of DMA addr. */
+	for_each_present_shadow_entry(sub_spt, &sub_se, sub_index) {
+		gvt_vdbg_mm("invalidate 4K entry\n");
+		ppgtt_invalidate_pte(sub_spt, &sub_se);
+	}
+	/* Release the new allocated spt. */
+	trace_spt_change(sub_spt->vgpu->id, "release", sub_spt,
+		sub_spt->guest_page.gfn, sub_spt->shadow_page.type);
+	ppgtt_free_spt(sub_spt);
+	return ret;
 }
 
 static int split_64KB_gtt_entry(struct intel_vgpu *vgpu,


