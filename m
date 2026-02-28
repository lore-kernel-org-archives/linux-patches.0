Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE9733F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301144; cv=none; b=Rx2aI0UY0mQfinZ+G/7/h35wGnnGQtQsjxdykY+o4gegLIGyXLspLonECgjcZ6BLqJooS/RfsRCyViQRJXMeQ/u4tr0rzTaL28HTbJpUpoGqwjSz9dmM9xX2dewPFWOy/oJRJJidxiuwRyat426aFC8EYpaW82I2qgbYkjft2Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301144; c=relaxed/simple;
	bh=vKFYXOQmrz68V3Mdx2r/LwhN9YLy57iFoBXg0zOps+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4EaKomGvz2DyBP11Mq8Cls/0Rf123pMAlwXhmvQG2CMswgAfc3Tk/ivc3SJNrz5k8PTkd6gLjGjiSP+wRalDQwZ1iuRViCmyjmu7PygYcNIVfbDXVkvL7EO64Phld5vX1ELs9QYaJD1MIZM7Zu1GIcXxT9PdMKQ7eKyQvCmxv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aL3gnXxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aL3gnXxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0E3C116D0;
	Sat, 28 Feb 2026 17:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301144;
	bh=vKFYXOQmrz68V3Mdx2r/LwhN9YLy57iFoBXg0zOps+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aL3gnXxPBARX39cYIy4bd8eEFZxXo5xM/DwKKRHAUc3JZ0Q1eSf2nUNdH1f+iRH/a
	 DuG5xCaj9vWsH/2mCjF7BRJbgUz5qUKareqPHeesp7wa7xo+s93y/xFNIFJVVGYITs
	 3aDCbh2quChdO0T2fnB2lj4ge2Bn7pCKr6Sr3O7l218f6PDyHhzHw8T+vMPQc3R0tv
	 ZSqRFXtKf4ynoYq9xQalXbC5CvdCM5d0xvzED3IPU0UDaQuAdCUgWuFyZIxDDrUv/W
	 wpUSZ4zxLaA3YTBxLSrH/sGPFOpV1ZKyIj+5qCxmayMg7N2y77OWlecl8mzoJ1imdl
	 w+0IKzu8cyDHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Keita Morisaki <keita.morisaki@tier4.jp>,
	Peter Wang <peter.wang@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 306/752] scsi: ufs: mediatek: Fix page faults in ufs_mtk_clk_scale() trace event
Date: Sat, 28 Feb 2026 12:40:17 -0500
Message-ID: <20260228174750.1542406-306-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Keita Morisaki <keita.morisaki@tier4.jp>

[ Upstream commit 9672ed3de7d772ceddd713c769c05e832fc69bae ]

The ufs_mtk_clk_scale() trace event currently stores the address of the
name string directly via __field(const char *, name). This pointer may
become invalid after the module is unloaded, causing page faults when the
trace buffer is subsequently accessed.

This can occur because the MediaTek UFS driver can be configured as a
loadable module (tristate in Kconfig), meaning the name string passed to
the trace event may reside in module memory that becomes invalid after
module unload.

Fix this by using __string() and __assign_str() to copy the string contents
into the ring buffer instead of storing the pointer. This ensures the trace
data remains valid regardless of module state.

This change increases the memory usage for each ftrace entry by a few bytes
(clock names are typically 7-15 characters like "ufs_sel" or
"ufs_sel_max_src") compared to storing an 8-byte pointer.

Note that this change does not affect anything unless all of the following
conditions are met:

 - CONFIG_SCSI_UFS_MEDIATEK is enabled

 - ftrace tracing is enabled

 - The ufs_mtk_clk_scale event is enabled in ftrace

Signed-off-by: Keita Morisaki <keita.morisaki@tier4.jp>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Link: https://patch.msgid.link/20260202024526.122515-1-keita.morisaki@tier4.jp
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-mediatek-trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek-trace.h b/drivers/ufs/host/ufs-mediatek-trace.h
index b5f2ec3140748..0df8ac843379a 100644
--- a/drivers/ufs/host/ufs-mediatek-trace.h
+++ b/drivers/ufs/host/ufs-mediatek-trace.h
@@ -33,19 +33,19 @@ TRACE_EVENT(ufs_mtk_clk_scale,
 	TP_ARGS(name, scale_up, clk_rate),
 
 	TP_STRUCT__entry(
-		__field(const char*, name)
+		__string(name, name)
 		__field(bool, scale_up)
 		__field(unsigned long, clk_rate)
 	),
 
 	TP_fast_assign(
-		__entry->name = name;
+		__assign_str(name);
 		__entry->scale_up = scale_up;
 		__entry->clk_rate = clk_rate;
 	),
 
 	TP_printk("ufs: clk (%s) scaled %s @ %lu",
-		  __entry->name,
+		  __get_str(name),
 		  __entry->scale_up ? "up" : "down",
 		  __entry->clk_rate)
 );
-- 
2.51.0

