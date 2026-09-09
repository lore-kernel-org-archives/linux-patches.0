Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4CF582B8D;
	Wed,  9 Sep 2026 14:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963373; cv=none; b=uhnq/c/FVnXC8Wx475LueUT0hVG6zVfZiZjtXoIx/xTOUV9x4XLXCe0l1vykr+Feux5iEVONfQxFVtIf6W2cdCKonRuiyFNeHUMgE2UCEFX9+dT97sIwhfajwdaqdcaxYg25qkiJzC4A2TrrljSmmXGy5FUq8MtHHiLXHaPxY6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963373; c=relaxed/simple;
	bh=kwUVwjn+xsAMCd0pRbHvvLC5Dbae1ckKEvjSt5bd90w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWLm2L24ImDPF1ZLQy05aO8sYdZxvnZIx8KYhgR8d9VG7E8xtWiAqScO9TvRMxp33FsiJAq/e1wrIs/kh442tN9FvfsH5MuyR+CbE1K1f3/dVd7MrmZoL+SzgI0YBkoMr91ivyXPR6Du3E3ETHopiKjvBcWdAJbAOILI7EnUtg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kqq6ZEDG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kqq6ZEDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51491F00A3A;
	Wed,  9 Sep 2026 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963371;
	bh=C29NAkhOU5nCoZyb4svLvw2dux5S15jy4F8dnxY/Tck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kqq6ZEDGmnVbXPc87oBzeLuMfU4LznphM1LXatkzZvIL4i9XmGAttEcfDRLWvIeRA
	 cp7klGwg8p/LU//6okli83C2dti2c4gWgYUNRfJenkzMGLiC/2zh7/4eun+LQa8wDT
	 mUpJFl4C+OayEqkOAq7aYlKnC8dHODhyaRPeqSHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 056/583] mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
Date: Wed,  9 Sep 2026 15:35:41 +0200
Message-ID: <20260909134239.939268970@linuxfoundation.org>
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

commit 3c453bddacd4c04ecb38cf79dbfa41e7dfe0531b upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme filter directories by adding kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-6-sj@kernel.org
Fixes: 472e2b70eda6 ("mm/damon/sysfs-schemes: connect filter directory and filters directory")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -704,8 +704,10 @@ static void damon_sysfs_scheme_filters_r
 	struct damon_sysfs_scheme_filter **filters_arr = filters->filters_arr;
 	int i;
 
-	for (i = 0; i < filters->nr; i++)
+	for (i = 0; i < filters->nr; i++) {
+		kobject_del(&filters_arr[i]->kobj);
 		kobject_put(&filters_arr[i]->kobj);
+	}
 	filters->nr = 0;
 	kfree(filters_arr);
 	filters->filters_arr = NULL;


