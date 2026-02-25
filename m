Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E663D26560A;
	Wed, 25 Feb 2026 01:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983641; cv=none; b=lrNT/27I+/LzyHYx4XD9/DSw031oXUQOjE9k501aR8uUcPXCXU84Yy7+BmZlYQ3Eh9ZY30twE7oFE8u/deHG0QjYTd6NZF66LHzZkEt1tSnFVp8NkeNpjIobTelcbVmGELk1bt471Stmwvxpx4PnH/U1V90ofeCMW7ww3H2bu84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983641; c=relaxed/simple;
	bh=qiqsdTmyQwU5G4YSFaHL/wB1SM0xM536phsWPuTLaos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lD5xaMR7djfCWf640NekBryGjAX6v+C9Ax2LOn3SjjCBxseB/G2fkxbg/Kv5VlZSzcwRMK+ROYR+4znRPl+uTejTDNYQZyD55ckQpwwPTp28B88007y2zvYmuA1puh1+rDiLbQzAZ9keBGbF7zYR08U1b3J8WY63Bx9LkWFRZgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=px8Sn9kg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="px8Sn9kg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7ACC116D0;
	Wed, 25 Feb 2026 01:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983640;
	bh=qiqsdTmyQwU5G4YSFaHL/wB1SM0xM536phsWPuTLaos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=px8Sn9kgqgs5/jkdSrjRtRWxz4VXbQ+BAUnyYWEK6DUTEKIj0nUZ1IgtuKBuzj51x
	 3nSLnBFpoxQUBHik2ZJ9H7weHBCxg/Z9G5jvJSBsyDB42T81ivzL9IkWo2KFAKOQQd
	 tr+ijfsLDNVuG6z0Rw3/lWlQY+D0/bEMz/1bNjhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 729/781] drm/xe/mmio: Avoid double-adjust in 64-bit reads
Date: Tue, 24 Feb 2026 17:23:58 -0800
Message-ID: <20260225012417.614296933@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

[ Upstream commit 4a9b4e1fa52a6aaa1adbb7f759048df14afed54c ]

xe_mmio_read64_2x32() was adjusting register addresses and then
calling xe_mmio_read32(), which applies the adjustment again.
This may shift accesses twice if adj_offset < adj_limit. There is
no issue currently, as for media gt, adj_offset > adj_limit, so
the 2nd adjust will be a no-op. But it may not work in future.

To fix it, replace the adjusted-address comparison with a direct
sanity check that ensures the MMIO address adjustment cutoff never
falls within the 8-byte range of a 64-bit register. And let
xe_mmio_read32() handle address translation.

v2: rewrite the sanity check in a more natural way. (Matt)
v3: Add Fixes tag. (Jani)

Fixes: 07431945d8ae ("drm/xe: Avoid 64-bit register reads")
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
Link: https://patch.msgid.link/20260130165621.471408-2-shuicheng.lin@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit a30f999681126b128a43137793ac84b6a5b7443f)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_mmio.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_mmio.c b/drivers/gpu/drm/xe/xe_mmio.c
index 350dca1f09259..3d59440ec44dd 100644
--- a/drivers/gpu/drm/xe/xe_mmio.c
+++ b/drivers/gpu/drm/xe/xe_mmio.c
@@ -260,11 +260,11 @@ u64 xe_mmio_read64_2x32(struct xe_mmio *mmio, struct xe_reg reg)
 	struct xe_reg reg_udw = { .addr = reg.addr + 0x4 };
 	u32 ldw, udw, oldudw, retries;
 
-	reg.addr = xe_mmio_adjusted_addr(mmio, reg.addr);
-	reg_udw.addr = xe_mmio_adjusted_addr(mmio, reg_udw.addr);
-
-	/* we shouldn't adjust just one register address */
-	xe_tile_assert(mmio->tile, reg_udw.addr == reg.addr + 0x4);
+	/*
+	 * The two dwords of a 64-bit register can never straddle the offset
+	 * adjustment cutoff.
+	 */
+	xe_tile_assert(mmio->tile, !in_range(mmio->adj_limit, reg.addr + 1, 7));
 
 	oldudw = xe_mmio_read32(mmio, reg_udw);
 	for (retries = 5; retries; --retries) {
-- 
2.51.0



