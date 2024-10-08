Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FBF1DED4B;
	Tue,  8 Oct 2024 13:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392931; cv=none; b=iHgxsl2lrf44pl2TYv1qQjAzErBZkZ/cdJ6IcEk6h/A2htvM7iX+b2zoWwcTpO5YmyDxGJfC6dmPTSYcxcHRqIrOI4WdRpQnYucJcajm4OprNq1M3t+7vLehXzuTjwpe/oEN4SdCXA/MaSzRmNifuHY9/GKW23g+nDZRIilifS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392931; c=relaxed/simple;
	bh=E4eeiVB9uoNs7RpASWB10LqD5NPujA2OlzXHkVpuS4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hpdlrO1OrVCf2JeqWPTQ4R4XmQeTwffpdQE1U46BtYE/i16PxhaZ8xoJ7aMvJIh98YEuYd/wh3m6/ijgLT8chKtbgRGQBt32i8EvLPIfhkhvQiqqTK8veYFJ/Z1w+fKCemxLnRT2pjtkJjYnmYKnx9welc07W0Eih/MDzo1kwSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7pf3a81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7pf3a81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88386C4CEC7;
	Tue,  8 Oct 2024 13:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392931;
	bh=E4eeiVB9uoNs7RpASWB10LqD5NPujA2OlzXHkVpuS4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7pf3a81WQN6Q9kb4fXyTurkKkScYx3fLq1M634y5tkWhc4XpBT6ZAMXpn/IU3zuP
	 bcynFHl2LXKJmkblX2VFKOv0+12ElPApzt+VLnl1hI1gbAxDLhYRuYtWbWaHlI82Wl
	 n6zuj9PgDCVA0Wiq47xAgqMIZuie5S9wlqYsjaeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Akshata Jahagirdar <akshata.jahagirdar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>
Subject: [PATCH 6.11 549/558] drm/xe/vram: fix ccs offset calculation
Date: Tue,  8 Oct 2024 14:09:39 +0200
Message-ID: <20241008115723.837735190@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit ee06c09ded3c2f722be4e240ed06287e23596bda upstream.

Spec says SW is expected to round up to the nearest 128K, if not already
aligned for the CC unit view of CCS. We are seeing the assert sometimes
pop on BMG to tell us that there is a hole between GSM and CCS, as well
as popping other asserts with having a vram size with strange alignment,
which is likely caused by misaligned offset here.

v2 (Shuicheng):
 - Do the round_up() on final SW address.

BSpec: 68023
Fixes: b5c2ca0372dc ("drm/xe/xe2hpg: Determine flat ccs offset for vram")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Cc: Akshata Jahagirdar <akshata.jahagirdar@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Shuicheng Lin <shuicheng.lin@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: stable@vger.kernel.org # v6.10+
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Tested-by: Shuicheng Lin <shuicheng.lin@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240916084911.13119-2-matthew.auld@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 37173392741c425191b959acb3adf70c9a4610c0)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_vram.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/xe/xe_vram.c
+++ b/drivers/gpu/drm/xe/xe_vram.c
@@ -182,6 +182,7 @@ static inline u64 get_flat_ccs_offset(st
 		offset = offset_hi << 32; /* HW view bits 39:32 */
 		offset |= offset_lo << 6; /* HW view bits 31:6 */
 		offset *= num_enabled; /* convert to SW view */
+		offset = round_up(offset, SZ_128K); /* SW must round up to nearest 128K */
 
 		/* We don't expect any holes */
 		xe_assert_msg(xe, offset == (xe_mmio_read64_2x32(gt, GSMBASE) - ccs_size),


