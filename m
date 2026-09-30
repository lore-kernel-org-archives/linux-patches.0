Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB03A51993C;
	Wed, 30 Sep 2026 17:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788307; cv=none; b=HK2LWknBrVyDWHy59OGxd0Xf0sOTYinuNN1T2C4YdFJ9oavpMKRf2z/qolgp500T6uznxw2K8l3eNlM22Ig3+g4i8QbQ0hMb807aBffwVY9pgiNRDTG3/kAWts1pQljJcFuHOmlsRJAzNWi8HDSq9MCYDDGcOYUEQu9Ov1zCJrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788307; c=relaxed/simple;
	bh=H1xu1Gfz9y8pNmNRKhAnuffSn0r+cqJ7FsQmh4uAtxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bflGCVqzhXF7HyBfx4yeYqxhycMtLox7kqawz1a+LeX9MHv+2gB8dlUZRRTvx0nQIuQihwA7xj6Rc+QrOvTb8eBnb1AZb4xAaUG7b6IEK/gqPR9yNvlM7kKdfZaxverp5zOLoA7Cnr/c1OpNvY2qkzcfQ+3nrJntfW1HmOzFzi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlMMixmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlMMixmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D901F000FF;
	Wed, 30 Sep 2026 17:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788305;
	bh=luL50C9KdKxa/FspgVwFrOpH0gaJEfW/3DXBFRyrWiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlMMixmk3zaNU4c+Nnq4HxhXoPHg09hhV0drjdLfqlAagMQCdFw3VaCiqP4+w6Wvb
	 gsCChzqSWMN63soC2DdPaSZSRkZK0gB+dmoEG6kwUfhyQ+QmaLUKvstliDI7F1TAUd
	 P7FX/KT0JZQ1z8g/GVnfWpfjpOq0b23/g52AF2Oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meijing Zhao <zhaomeijing@lixiang.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/877] mm: memblock: show all region flags in debugfs
Date: Wed, 30 Sep 2026 17:16:30 +0200
Message-ID: <20260930152416.445050998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meijing Zhao <zhaomeijing@lixiang.com>

[ Upstream commit e2d5b01f878d76bd1142e512a0b979a1d3cd0abf ]

Commit 493f349e38d0 ("memblock: Add flags and nid info in memblock
debugfs") made memblock_debug_show() stop after finding the first set
flag. A memblock region can carry multiple flags, so the remaining flags
are hidden from debugfs.

Walk all bits in the region flags and print every set flag separated by
"|". Keep walking beyond flagname[] so that a set flag without a known
name is reported as UNKNOWN rather than silently ignored.

Fixes: 493f349e38d0 ("memblock: Add flags and nid info in memblock debugfs")
Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
Link: https://patch.msgid.link/20260902075944.3742866-1-zhaomeijing100@gmail.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memblock.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 3d7b0114442c4..00ef6bea6fe8c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2416,14 +2416,18 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 		else
 			seq_printf(m, "%4c ", 'x');
 		if (reg->flags) {
-			for (j = 0; j < count; j++) {
-				if (reg->flags & (1U << j)) {
-					seq_printf(m, "%s\n", flagname[j]);
-					break;
-				}
+			unsigned int flags = reg->flags;
+			bool first = true;
+
+			for (j = 0; flags; j++, flags >>= 1) {
+				if (!(flags & 1))
+					continue;
+				if (!first)
+					seq_putc(m, '|');
+				seq_puts(m, j < count ? flagname[j] : "UNKNOWN");
+				first = false;
 			}
-			if (j == count)
-				seq_printf(m, "%s\n", "UNKNOWN");
+			seq_putc(m, '\n');
 		} else {
 			seq_printf(m, "%s\n", "NONE");
 		}
-- 
2.53.0



