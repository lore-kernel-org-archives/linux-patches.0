Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32BC31AF24;
	Wed, 25 Feb 2026 06:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002769; cv=none; b=FnuUG3N/rkeSTuNL5kkeBnHZceY3Md362S8fRYMtBSYdkQujsuYS22cXRKMzwvaei74dpu53dZ3R9NsxIqgGalqKcBF4CHr4fMOm88UzLxTsCtCKV/0JMoDy/Gasj/bQsP+2KVcTCN0Pi9pNGT3DCGR0RA6TKDJQS7oz0Ba7A7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002769; c=relaxed/simple;
	bh=8rz51A8IYMxlQMscsLO0r/TtSFFPp2gim2bcl76axYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rkkm3t9VRVvx99PI9brZNNC0KFNwDrMCdgwaJiRz8LWykLjSJ9VCjKYrJf7XHYUpD6kygKhKlbcXQrlTWgf1H57rDoSMMeey8j0CWGfHXZOCA+u8tOgUtFcR4fmrIASwGvkd2+JB7yc6DPPjVyG8N9sFT/6ZdX2iDL1fjRQU+/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+D9enZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+D9enZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5DAC116D0;
	Wed, 25 Feb 2026 06:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002769;
	bh=8rz51A8IYMxlQMscsLO0r/TtSFFPp2gim2bcl76axYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+D9enZ53ap1UqfQ1mDB1u9t8iCaI/P7WAwXkjqAsKosjxo0UUHWWkMBW9gzH0PBz
	 vAZVLifgXPXv3VjAmDZ5Z8+Wv1EsslKLU6Cy/0sH8hNj1B+oQuYvqJSJYlwI/f9kJB
	 FTJVqXnQIl9BOXA78mgPYs5vO79h+bcms9LHVX+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 596/641] drm/xe/mmio: Avoid double-adjust in 64-bit reads
Date: Tue, 24 Feb 2026 17:25:22 -0800
Message-ID: <20260225012402.956211410@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index ef6f3ea573a2c..6752881af093a 100644
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



