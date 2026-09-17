Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA25B4FDA63;
	Thu, 17 Sep 2026 17:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664907; cv=none; b=SWQtQ+zi4CJZTi+v/fql6xrcuSCV8VO2hPna7KhqwBJqtwkcFbc+xn7L9AfkaQRrPwRddqpTLMVRsoUWb9ePFrn2OMT2rjkWDgenqCy2RAxyNELfutBpHX0dP3guTJyfXVhyjHpHb2KCtWFXd8s4Koz2yMElZDWAQ7jH8bjs0T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664907; c=relaxed/simple;
	bh=SXnfV8ETajzL4vs/rXWsYrb6GukT3gkHeG/JGojvbWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7MdcJebLOzj9VmxNQBilTo5T1qKOJ2KI8116tNgPnzb1RwPfN/qxBIOzlHQ1YM6+JXh+tv8CputkuGldPXU0L0U9xFPkg5cu9sOwtLK2mETNtOMJIkabJOGmu5jV6Om+N0Y288j7zrQ+7Pb1O/TidRamFBGRVSfR8CKUhIVIbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwx8Fh4z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwx8Fh4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C701F000FF;
	Thu, 17 Sep 2026 17:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664906;
	bh=JOODK5WwtHYhXNPHeGdSEuxq9sQoN20nSmrMpeccS1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwx8Fh4zuNh7ZxzIw5q3QbItbbXLPZwTQOMsPOkjsj+/mgJme62dI8snG4DjUs28j
	 +uqN5rftc5k2nYkJmg2mhibMRumtj+7Ta8oRN+X+7Au75KScCOD89rY3pI8tF/OVgz
	 0x+ff3N6jEQ540NzOBh+qpIsxim06v7SmC7NwXOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Peng <pengyu@kylinos.cn>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0529/1250] arm64: fixmap: Allow 256K early_ioremap() at any offset
Date: Thu, 17 Sep 2026 16:05:24 +0100
Message-ID: <20260917151606.279593625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Yu Peng <pengyu@kylinos.cn>

[ Upstream commit 21fc7ec93f8b633b60d5bddef2f1529ff6b36185 ]

NR_FIX_BTMAPS is the per-slot page limit for early_ioremap(). Since
__early_ioremap() maps the page-aligned physical range, a 256K request
can require one extra page when the physical address is not page-aligned.

Reserve one extra page per slot so the 256K mapping budget is usable
regardless of the initial page offset.

Link: https://lore.kernel.org/r/08fd96fa-ee3a-4904-bd11-bb08bd90436f@kylinos.cn
Signed-off-by: Yu Peng <pengyu@kylinos.cn>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/fixmap.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 635a43c4ec85b..9288021ba93b1 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -78,8 +78,12 @@ enum fixed_addresses {
 	/*
 	 * Temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
+	 *
+	 * Reserve one extra page so a 256K mapping may start at any
+	 * offset within a page. early_ioremap() maps the page-aligned
+	 * physical range, so the initial offset can consume an extra page.
 	 */
-#define NR_FIX_BTMAPS		(SZ_256K / PAGE_SIZE)
+#define NR_FIX_BTMAPS		((SZ_256K / PAGE_SIZE) + 1)
 #define FIX_BTMAPS_SLOTS	7
 #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
 
-- 
2.53.0



