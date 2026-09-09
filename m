Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E57549387;
	Wed,  9 Sep 2026 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961813; cv=none; b=Jr2CJ0O0xx1R+gB8W8ttyz9ylw8DOXPnYV6MznY6rlAxCla9Ivd3Vki43tXWjgWahh1vdpEitYQRK75kg3+1SjtsnmK28486vLtdgEyT7yRf+ByACGtSis1rV2rWKiB1D5fTQ9GwX+AoQTEEjftr4eASBfFXl+IVSzPJqnCdjs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961813; c=relaxed/simple;
	bh=BQrz9Cz+53Y/r6bJEQsqtpf/zdaZ8get+bM6GoxKBQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ietWbrzhDJBwPpp3rqSbWyUW4LCVL2fJShXbtV4PsOzvE0dypqIUUNiQm+x+dFP/1RuOS3V1hcUuf1f8w9aaCVzmPy49i9eNtFBrsMZyovB/8x6CyVl8amUqoot71y0s6f/eRzwEuvCkPDRBl2mZmVuKnAbNStxewx6o5TmJG+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gFwKBi8z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gFwKBi8z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1621F00A3A;
	Wed,  9 Sep 2026 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961811;
	bh=gaztktsgCDrThxp7ObI7o2HqL9mLUK60ZHOrBw9ug40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gFwKBi8zbhK+DBezc1htDnwycPJTv5W1W6+YQrHfao0z/Dijt0+H9h08c9FyuLW/F
	 f2B8FsS3Kzpl95WvWCV7YP3wtefWpLgykZLiEk4IUbssSvm6TsK0adyuYyq0QvJbzD
	 vsmJGFEllZiN4Gtptsb+XspG8uKxmnFGL09OJQTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 073/556] mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()
Date: Wed,  9 Sep 2026 15:35:53 +0200
Message-ID: <20260909134233.065813487@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit ab4d9358e32316fa39b5f1f5360292135978c3d9 upstream.

damon_sysfs_apply_inputs() reads addr_unit twice.  It could race with
addr_unit_store().  As a result, the min_region_sz could wrongly be set
up.  Read it once.

The user impact is trivial.  Sane users ain't update the parameter in
parallel.  Even if it happens, the DAMON core layer handles the wrong
min_region_sz (!is_power_of_2()).  Even if somehow the race ended up
making a min_region_sz that is different from the user's intention but
still valid, only monitoring itself runs differently than expected.  No
critical consequences like kernel panic or memory corruption happen.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-6-sj@kernel.org
Link: https://lore.kernel.org/20260714142950.100711-1-sj@kernel.org [1]
Fixes: 540a2aebc657 ("mm/damon/sysfs: implement addr_unit file under context dir")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2047,11 +2047,11 @@ static int damon_sysfs_apply_inputs(stru
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
-	ctx->addr_unit = sys_ctx->addr_unit;
+	ctx->addr_unit = READ_ONCE(sys_ctx->addr_unit);
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_region_sz = max(
-				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
+				DAMON_MIN_REGION_SZ / ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)


