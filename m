Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E204D3164B7;
	Thu, 28 May 2026 20:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998965; cv=none; b=nSI/U4aH4oUsPApsq8UTdrzYCaqAcGY5oUxxH89uhfDnElBKEdMNwWHpibL/nxG3JjfawWeIUofMOqH6S1aETvf+/PtnCeuZoxqQLMoygTJjHVpUzz/aRgTcptufSAf7QNbB8IMssj3Pu5BN6QPLKY3ZLMhd2gcN0WXbWuugnf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998965; c=relaxed/simple;
	bh=5kTryJXGD3w1uRRdPWnQ7UkkfQK+Ic135cQxhuTIJs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCfQoGj/glbIpIZ9Kide8kB2owEIawKjHlEq309TU8SruCtqwmdF/xrp2Wt9HPLqAc+VsMpeXZSWmPi5FQkqmo3NlU5vuzVaiu7clzlqx9JLkk8F5siWdi9p6qagtGNAfzQUl5fXDoqFXErG4GrjAFlppuKGZMDxQhq4xDUWtyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GP+g+3pu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GP+g+3pu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C05D1F000E9;
	Thu, 28 May 2026 20:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998964;
	bh=HQSffuFsqSakRlONyeXfmGleLbiPgHwFKgZzDPoCh8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GP+g+3puUaS2TOXxmebbi0RVigbcWDZ+S2NoDMRHmDvFoXXlmQUHGJuAbixpTW/hf
	 u2WgWUv/DfdU4rvWCwBrvAGg0q4UsXR6z5KcBzlA1kdHDJYP/LoDgvHrPTXmECBg2T
	 KxsuG8wJYSjf4TuslJWw5FNEM/Y15oZ1qeZ5xPsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohanram Meenakshisundaram <mohanram.meenakshisundaram@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 361/461] drm/xe/pf: Fix CFI failure in debugfs access
Date: Thu, 28 May 2026 21:48:10 +0200
Message-ID: <20260528194657.881971267@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Mohanram Meenakshisundaram <mohanram.meenakshisundaram@intel.com>

[ Upstream commit 96bf49b526e2d03a2b7f6e861925a08f46ed0d28 ]

Reading debugfs file (/sys/kernel/debug/dri/0/gt*/pf/adverse_events)
with CFI (Control Flow Integrity) enabled, the kernel panics at
xe_gt_debugfs_simple_show+0x82/0xc0.

xe_gt_debugfs_simple_show() declare a function pointer expecting int
return type, but xe_gt_sriov_pf_monitor_print_events() is void return
type, leading to CFI failure and kernel panic.

[507620.973657] CFI failure at xe_gt_debugfs_simple_show+0x82/0xc0 [xe]
(target: xe_gt_sriov_pf_monitor_print_events+0x0/0x130 [xe]; expected
type: 0xd72c7139)

Fix xe_gt_sriov_pf_monitor_print_events() function by updating to return
an int type.

Fixes: 1c99d3d3edab ("drm/xe/pf: Expose PF monitor details via debugfs")
Signed-off-by: Mohanram Meenakshisundaram <mohanram.meenakshisundaram@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Link: https://patch.msgid.link/20260514174918.1556357-2-mohanram.meenakshisundaram@intel.com
(cherry picked from commit ff1d386a8359746d9699ac30336e3b0684c68958)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.c | 6 +++++-
 drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.c
index 7d532bded02a8..a85ba44353789 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.c
@@ -114,8 +114,10 @@ int xe_gt_sriov_pf_monitor_process_guc2pf(struct xe_gt *gt, const u32 *msg, u32
  * VFs with no events are not printed.
  *
  * This function can only be called on PF.
+ *
+ * Return: always 0
  */
-void xe_gt_sriov_pf_monitor_print_events(struct xe_gt *gt, struct drm_printer *p)
+int xe_gt_sriov_pf_monitor_print_events(struct xe_gt *gt, struct drm_printer *p)
 {
 	unsigned int n, total_vfs = xe_gt_sriov_pf_get_totalvfs(gt);
 	const struct xe_gt_sriov_monitor *data;
@@ -144,4 +146,6 @@ void xe_gt_sriov_pf_monitor_print_events(struct xe_gt *gt, struct drm_printer *p
 #undef __format
 #undef __value
 	}
+
+	return 0;
 }
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.h
index 7ca9351a271b7..0b8f088d3a16a 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_monitor.h
@@ -13,7 +13,7 @@ struct drm_printer;
 struct xe_gt;
 
 void xe_gt_sriov_pf_monitor_flr(struct xe_gt *gt, u32 vfid);
-void xe_gt_sriov_pf_monitor_print_events(struct xe_gt *gt, struct drm_printer *p);
+int xe_gt_sriov_pf_monitor_print_events(struct xe_gt *gt, struct drm_printer *p);
 
 #ifdef CONFIG_PCI_IOV
 int xe_gt_sriov_pf_monitor_process_guc2pf(struct xe_gt *gt, const u32 *msg, u32 len);
-- 
2.53.0



