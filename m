Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C6D52FE40;
	Wed, 23 Sep 2026 14:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172895; cv=none; b=tj/CqbrxODeHEO0chLQFWlKfxpeS6EzO41wWTq+M7qni8/z0DeHucm6jmQkFboIMPJobaCoesCT3NWQ3kaIwtN0nX7u5SJ8RnydKNvq7A+U2KkwhNrUp/LP1PxzqeFln9Qy+3dY97aQlBB7Crek7J6Y+Xqi4wUgcm2I6UNR2BLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172895; c=relaxed/simple;
	bh=AUigs4q18l73qWJe3DuwFhXtnKqcRQi7MdoNSVINbZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRd86Pl9k3nvScVREYA4s//1fncBtW8Lud5Zfpt3z7FYWfcLoa/7BLcCYgDNCtcLOB2RRR1haIJB7fUHcu+Xkuq/hVb//lxBnSyZDzMVbA6FrgIb12PdLb7jkJp0kdOlHdaTvYBplvDFcD3nR/S5Y5nbYGYO6wLhojgoUk0RnT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1eRUvL0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1eRUvL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4121F000FF;
	Wed, 23 Sep 2026 14:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172894;
	bh=sVJkvYidCONGnPc2Ov44NLI7Y535rL8QH5BAc5Qo6so=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1eRUvL0Ou6nRwwoJ93o/+qQsBl0c5s+qmfajqvCVKzUP+Mjw+xzVYaJBYwKkd/yv
	 yv966knTnl7h4YRc9RKUfu4T0wuIiBK24m10I76d00SJBmzww79gUDX+MsXHHysQWh
	 1ye9Ki0PBqcvoDyhM7Wy9vHz3KHFriUXy8b69lig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meijing Zhao <zhaomeijing@lixiang.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 092/438] mm: memblock: show all region flags in debugfs
Date: Wed, 23 Sep 2026 16:01:53 +0200
Message-ID: <20260923140647.163070363@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6349c48154f4b..a8d1992ba7a13 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2823,14 +2823,18 @@ static int memblock_debug_show(struct seq_file *m, void *private)
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



