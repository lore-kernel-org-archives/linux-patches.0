Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FA133F59A;
	Sat, 12 Sep 2026 11:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213063; cv=none; b=oJ5uUdXm0+fGzk6p5JftHPDKKu8axkD4bl73Fv4GGh8MENJf+Azl/FzckIBvygXNIlgANl4Z1+D1tLcK8zCwSFsz8P4MdDA7pUsH/ZW+X/1dY8kwOsIO1aTimm995Dt61DFiQUxPaQVs1fhg67/9nrJMtmWVM3g7kW7M5ByDtyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213063; c=relaxed/simple;
	bh=SGfJZSlRgg59tmbleZgx99hBCOzbw9zArQYuXUyyU9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bScjblJjcfbDXywtMosn/6SIZVvDJ74rJf+dj0YdvHxAiHi47B2ScaUi8ozYtrAY3pVdaNPRlJgn+oaRRdL8EdqbBde2EPS6ENbhZI5b0PbTsHvub7LrsL4YFaqy71OfcSVwEgv+glZj1aZiGvvi/V/RSYATSlBlOnsIqtrSDV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QII97aoV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QII97aoV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC0C1F000FF;
	Sat, 12 Sep 2026 11:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213062;
	bh=O8ZvQ7jUkZ8vW9SWRGWnV3dhTNewLill+rEpYXuIqrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QII97aoVIlN7H7yzCBtQC9sX0ZzAq6okM1M5EXgeXmsxagYWEYBuCn//RDg+HTx2L
	 bEQrTKUV959T8c2aMbNApgj5Y9PNl/wuWOb90+vtONTcaamdWdyoaBN7QvtcIKhHL0
	 ErJLvMH5UN8SIskAOwI4BE6NDjnoiZD1z12DRv0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0043/1376] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Sat, 12 Sep 2026 08:41:09 +0200
Message-ID: <20260912065608.512970423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: SJ Park <sj@kernel.org>

commit 05fb6ac98c49be870c5f9ccdfdf95f0107e564ae upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme directories by adding kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-4-sj@kernel.org
Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1772,6 +1772,7 @@ void damon_sysfs_schemes_rm_dirs(struct
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
@@ -1813,13 +1814,15 @@ static int damon_sysfs_schemes_add_dirs(
 			goto out;
 		err = damon_sysfs_scheme_add_dirs(scheme);
 		if (err)
-			goto out;
+			goto del_out;
 
 		schemes_arr[i] = scheme;
 		schemes->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&scheme->kobj);
 out:
 	damon_sysfs_schemes_rm_dirs(schemes);
 	kobject_put(&scheme->kobj);


