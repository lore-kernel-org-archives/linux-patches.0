Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79FB04766B8;
	Mon, 31 Aug 2026 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184365; cv=none; b=FKOWMIB+g5+t5duzyYikFpKN+raFyJf6OKa0l6ZW9ITgElhrQlP9efWoQciwdNu/YFSOvK2L6dhQ79Ls//bGcweqpHHm5rh9D1FE8ifrJ9iYu7rQLfTfO8IGroTX0xRkyYb0JUHHFAC72ICqd4aTc6s1dj6IS3bip5CaJQG8Cz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184365; c=relaxed/simple;
	bh=cIip9Z66Yiy0Xwq6y1y7qtFx/jql0j9kuQpAH7Ihcdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pvdoVg4G6FKq3c9U+8k9X3CwmUSCyrMGcLpHtoeP8Lz/5SPfKavYbYOB3nG4sBqSV/zOzSq4AYm2PXcIR9rxlS7ggXA48KshMBSZjSWhhm5tgd2/VQKyIaZSjGXF+XPbDZIbgA4aJwaBr2JQJ5J7McKAl6yjPp0V95hgWThr0XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g0W64eLU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g0W64eLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986971F00ACF;
	Mon, 31 Aug 2026 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184364;
	bh=M3ArXLpvvpK2406PiFlTgTKded0BNHL3d2lE6hA0x2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0W64eLU9QJpWLKQJDU4JVXkmuTtQ8PmDt0ycrbZjrsvVIJ9+aDve3XcXbTK5RSlq
	 ezRXzJFLuW9hjXaXqIH+pDDnzFsXY4mT1vCgdaaLqf256V3ArLfVmOExLJubgCh+vX
	 6CHyR+cZ8n6wyoCIL2wZNlLWc5Ow3Xzt6g/I80jSXsW9a7vqJJAqW/zeGicDZzJ8Ky
	 NiTMEeRonY+8574BHslDDQvwJ3krSDJPqPkQg2e1lilR5viZLp2/gOGBKQTTZLMLVB
	 pPWmELZoWPKRC33zX5FBoEijYJZPvQ+7ODu221ZdnLWXOu9R/Js08n5sKfBf/LdxwS
	 thVqQODErH+xA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jie Wang <jie.wang@intel.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] gfs2: move quota_init qc iterator increment
Date: Mon, 31 Aug 2026 09:31:18 -0400
Message-ID: <20260831133314.4125787-650-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jie Wang <jie.wang@intel.com>

[ Upstream commit 942202677f8f2ee448a6a2feb06aeeaf520342e3 ]

Move qc++ from the loop body into the for-loop increment
expression in gfs2_quota_init().

This keeps iterator progression explicit and avoids mixing pointer
advance with duplicate-slot handling in the loop body.

Signed-off-by: Jie Wang <jie.wang@intel.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `git log -S` search between v6.10 and v6.11 finished
(~75s) but only surfaced merge/release commits, not the actual GFS2
change — typical for this shallow stable checkout.

What we could pin down: duplicate-slot zeroing first appears in
**v6.11** (absent in v6.10, present in v6.11), so the `qc++` /
`memset(qc)` ordering bug has been in 6.18.y since then. That’s enough
context for the **YES** backport call; the exact introducing SHA isn’t
available from this tree’s history.

 fs/gfs2/quota.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 7a36a3fe5e6e6..4620f586411a6 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1447,7 +1447,7 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 
 		qc = (struct gfs2_quota_change *)(bh->b_data + sizeof(struct gfs2_meta_header));
 		for (y = 0; y < sdp->sd_qc_per_block && slot < sdp->sd_quota_slots;
-		     y++, slot++) {
+		     y++, slot++, qc++) {
 			struct gfs2_quota_data *old_qd, *qd;
 			s64 qc_change = be64_to_cpu(qc->qc_change);
 			u32 qc_flags = be32_to_cpu(qc->qc_flags);
@@ -1455,7 +1455,6 @@ int gfs2_quota_init(struct gfs2_sbd *sdp)
 						USRQUOTA : GRPQUOTA;
 			struct kqid qc_id = make_kqid(&init_user_ns, qtype,
 						      be32_to_cpu(qc->qc_id));
-			qc++;
 			if (!qc_change)
 				continue;
 
-- 
2.53.0

