Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60E850B429;
	Wed, 23 Sep 2026 14:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174340; cv=none; b=Knk8IcQ8JE/AsTuXHqmr3IEa/kY3IPSOuxmaMv97I6/Vw+R6bYyN7+/WaiiGoPxYzfEDu/OjS0o6LxcY6r3Uo4MEjzhyPQePW7EjsMn5JXKIRyyNvt6hoS5mX1DoZEW8U7Z53OCnUToKjeLKgO/NUQP6E8f8tyWra23CuTPUMe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174340; c=relaxed/simple;
	bh=OmqjJ9cRkP+8Bxn6jIKCCekU7bgXeSzj7y9gfJ5wNfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR95eBb/uoy5DEKDfcE6jJzQURC7WMF/tEOrjBAzg+RvnHCyVI31gsWvMERNt1a58qLdmPk7NJoisKf/I2Wf+aWyRwsfd1tav8RlqKs6bRL3XvXYPtMbcfRL8bwmuCSU6Xvdk1UmhVIPLFbp4VMe2sY1vN7MI16KrpTAAzezZzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5qUvo7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5qUvo7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3D11F000FF;
	Wed, 23 Sep 2026 14:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174338;
	bh=i4w1dB+XbkhB4mKuazm3DVJqEBFsEysAUsp1ZDxXXHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5qUvo7/bQScBRFifHyKY6G2vqz5vA0OKGbNAfysnSP6bxZEpKFnHSXCnMgMt+ClW
	 vN7Zr7WTQR6zZP1451OTMynCcy1Z5oceXD7+CZNmL7Y3yAOt5MY27YL0YnL5DlBrac
	 w79MYwYU8/CQPOWF8VeB0pqy5KiRClbwX5h2QeSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meijing Zhao <zhaomeijing@lixiang.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/398] mm: memblock: show all region flags in debugfs
Date: Wed, 23 Sep 2026 16:02:37 +0200
Message-ID: <20260923140645.586954715@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 757258d68425a..e2f15bbc274b5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2727,14 +2727,18 @@ static int memblock_debug_show(struct seq_file *m, void *private)
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



