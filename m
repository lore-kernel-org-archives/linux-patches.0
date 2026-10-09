Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464BB2BE7CD;
	Fri,  9 Oct 2026 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556074; cv=none; b=A8LXQG0ggf8aXPx5e3exr2ircrYR2SrQt4wIjz8TU+zd2v/sJsu3MiO6qQW0U2bD4pfVx1yI1TontA/sqMQUZj28gF5Liyx8Nv01QnVqo5hKlW/BXQ3AYv96Ax+/GUdR+KrYV+enbnwdfqE0WmWSMY0jP3ZMILRgKGWtc8kjMzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556074; c=relaxed/simple;
	bh=PRIQeW1JLH/e7WKY9SU/PDW/F5dfNH7V9ziE0qZIm1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lfCbUl3/vnwHIfljt3nT45CSPfo+4sOuoVZyefrAGH+o4CMRYF2Iy4ve/i17Wry63Ddu8CHmPNbXtwFrm7EsdiufIRCeryEmVMjsaNiK9NL8WgEUnYU4pDYcLKIiVkd2+2jtzOLm24x1lQAqQPc4aWbL8acjhOXN95UFwiKjwVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bunZhxqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bunZhxqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39111F000FF;
	Fri,  9 Oct 2026 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556073;
	bh=lQXMdpkLv3NVqOU1EORWKEaQI36yiWA8TtOYszTDdu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bunZhxqC/bt5mUhGwwigE6nmiiDU1yqBdNx9DaZ5q687iI7D7lYFJkQOUTLODzCUd
	 vDfoeLDqqDMzk66Ap3TE7TBQGS1tbZxiVDClWGuSHPe+D2AMzNaLPSuO8sMpWjAk9l
	 ib4kiGVMQOCyrKoAvuFo1yoSLTEaY8Zz8uhrVTLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 116/428] drm/xe/pf: Refactor VF LMEM BAR resize helper function
Date: Fri,  9 Oct 2026 16:07:33 +0200
Message-ID: <20261009140948.745556355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 74dae5f33c0c64d3ca12710bfd845721d73fe2e5 ]

Improve and move diagnostics messages to the helper function to
keep the caller function tidy.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Michał Winiarski <michal.winiarski@intel.com>
Link: https://patch.msgid.link/20260911182306.14973-1-michal.wajdeczko@intel.com
(cherry picked from commit 10628c52a3732a10426499a3d462cc2e6bc371ae)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Stable-dep-of: 72207463f7a4 ("drm/xe/pf: Keep VF LMEM BAR size low if no VFs enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_pci_sriov.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_pci_sriov.c b/drivers/gpu/drm/xe/xe_pci_sriov.c
index 35e6b53e18ce2..c023a2a1fc171 100644
--- a/drivers/gpu/drm/xe/xe_pci_sriov.c
+++ b/drivers/gpu/drm/xe/xe_pci_sriov.c
@@ -82,16 +82,33 @@ static void pf_engine_activity_stats(struct xe_device *xe, unsigned int num_vfs,
 	}
 }
 
-static int resize_vf_vram_bar(struct xe_device *xe, int num_vfs)
+static int pf_resize_vf_vram_bar(struct xe_device *xe, int num_vfs)
 {
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
+	char buf[10];
 	u32 sizes;
+	int size;
+	int err;
+
+	if (!IS_DGFX(xe))
+		return 0;
 
 	sizes = pci_iov_vf_bar_get_sizes(pdev, VF_LMEM_BAR, num_vfs);
 	if (!sizes)
 		return 0;
 
-	return pci_iov_vf_bar_set_size(pdev, VF_LMEM_BAR, __fls(sizes));
+	size = __fls(sizes);
+	string_get_size(pci_rebar_size_to_bytes(size), 1, STRING_UNITS_2, buf, sizeof(buf));
+
+	err = pci_iov_vf_bar_set_size(pdev, VF_LMEM_BAR, size);
+	if (err) {
+		xe_sriov_notice(xe, "Failed to resize VF BAR %u to %s (%pe)\n",
+				VF_LMEM_BAR, buf, ERR_PTR(err));
+		return err;
+	}
+
+	xe_sriov_dbg(xe, "VF LMEM BAR resized to %s\n", buf);
+	return 0;
 }
 
 static int pf_prepare_vfs_enabling(struct xe_device *xe)
@@ -142,11 +159,7 @@ static int pf_enable_vfs(struct xe_device *xe, int num_vfs)
 	if (err < 0)
 		goto failed;
 
-	if (IS_DGFX(xe)) {
-		err = resize_vf_vram_bar(xe, num_vfs);
-		if (err)
-			xe_sriov_info(xe, "Failed to set VF LMEM BAR size: %d\n", err);
-	}
+	pf_resize_vf_vram_bar(xe, num_vfs);
 
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err < 0)
-- 
2.53.0



