Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E79577E39;
	Wed,  9 Sep 2026 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964868; cv=none; b=S239+srVaOvIc0Z60475urqFMufdctQyNIUhO9NJnUrd1qKYlnCSUv2TenXpvl/qC0RQNy+dyZvSaF9qojnM6KTWTh+AUbd3/+UpDV8PlrIIQ6xWykmsJdVqaLFwQi/VFtL33eVSe+1zlYoCjKX3HETF7lnsoEkWIAYMtPdxxEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964868; c=relaxed/simple;
	bh=z2QFzS0cHe459Izm2AYWgZQCy4nS4jpwWiivcg7rE5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjLQwqtk2nyVdKqUYF+FbOHSQrpR4X5EIHb+a/t2UrRmYboWiKX9nKT2Nlso8GP0LozE+sXqgBbaYw8EcUiwPNcxWyJM/sbGOTGrvokejv4ofm04RlgQLmboHFXZLEu4v5cW6ByNJnZpHQaEF2u9gW1hQQVAVuVrBefU2tjrxsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ha9tUf2c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ha9tUf2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F4C1F00A3A;
	Wed,  9 Sep 2026 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964867;
	bh=SX+a5FTbXrD8QEBauqizku1DqZHBUL3ifUfIRCsPGvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ha9tUf2cp83u6DZfPS1oULwA4rNUk7zLJKM+PKTZahmOjwlPXhuMxuLSUUFRJah0i
	 TBXiBhDuIlS07ElusEkiPVCN/lCzIBY1j8eFAfhuLI5uJ7KBOzthZP3Z9WJwBZiKYb
	 sRyZdyvEYV5dFtDlFrppL595g14W2MQkW7HlUyz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 572/583] mm/damon/sysfs: read addr_unit only once in damon_sysfs_apply_inputs()
Date: Wed,  9 Sep 2026 15:44:17 +0200
Message-ID: <20260909134257.647632765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1445,11 +1445,11 @@ static int damon_sysfs_apply_inputs(stru
 	err = damon_select_ops(ctx, sys_ctx->ops_id);
 	if (err)
 		return err;
-	ctx->addr_unit = sys_ctx->addr_unit;
+	ctx->addr_unit = READ_ONCE(sys_ctx->addr_unit);
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
 	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
 		ctx->min_sz_region = max(
-				DAMON_MIN_REGION / sys_ctx->addr_unit, 1);
+				DAMON_MIN_REGION / ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
 	if (err)
 		return err;


