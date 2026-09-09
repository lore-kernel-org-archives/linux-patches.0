Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E63476049;
	Wed,  9 Sep 2026 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961961; cv=none; b=BfIPbJP73Qlurq3GaNzlcFfJln7HbRS/wZZAXKkS9FciUj60M/Gco5nA+FIWeK64IhQrcVilp4etQWc0Yz2z0NcR9+oGp5+D60bY7sLhxvpKyBbvcBfPpDPH/wz4/nOeJHjhgvtHSlMDTH27DVW9OBAZCRCLaEvsjX4EL8aWyKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961961; c=relaxed/simple;
	bh=enfEGt/zT3C+UY2GoyPvc0hciZCwzc0g/QZLZHGGwjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzyeuC0Wl2Ri4tHm9mwlJEPPCuGy9Z1q5ppWIdLLlHfFM8Ifss6s06agxOspVKOVPe/r3uCADbqWb8muZf2ig7VhFOPP7EEn/a8OrvhFAMSEk0RpKOGyccrxRv8k7kNSZAB4AjAP3TBdX56+ctpFDfRzzgMBxf2+Q5zwwjXVYPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkcChPz5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkcChPz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3AA1F00A3A;
	Wed,  9 Sep 2026 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961960;
	bh=6Em+0oV59c+w/tzxrbUlHwIDoKR/gE//D3JmIsKIXgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkcChPz5Hy73OVS0OGxXHnk7qH9JHCjPsPewALzDj9bsF3MUB/rhCPQ6RrzbS+yfk
	 43tw5gihGE3yUdpFeyuEc9nXbb9G2Z379AzZa0rUOAhAU65qMWee4ESZp+JnZDFH7x
	 bgbS1mYRO36zC44kirP1C8JPOVMau0TyPuq5pNXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 085/556] mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
Date: Wed,  9 Sep 2026 15:36:05 +0200
Message-ID: <20260909134233.500799332@linuxfoundation.org>
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
@@ -911,8 +911,10 @@ static void damon_sysfs_scheme_filters_r
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


