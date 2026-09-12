Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28F83CDBB5;
	Sat, 12 Sep 2026 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228704; cv=none; b=dp3aqxCHIm7RjxAl9xHondyqyZwGXb7QU75Ko5CIGmhcn6iQQFDDrpXlQBlIb5LCnXujdjJdk6IfOg+H57GH2DHLAQiRIqX8hSezvrbhVNLkvpEPhcDlQYN6MMmNI+EHxZJal/1XJiz2WswEf6JTwfxDfqo+AtLeCxXuVPZT9xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228704; c=relaxed/simple;
	bh=nWo+vF/OVH3hVX215bRycp13/zPrfLdG+uOuRfNvSss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcnRSCsIAZqlTIu186PTsypcGKU5it2oTyHnoh3ZpOPIL95gHFJz9HCc1Zeep4ZcbSFkwu4iQuxqTgR3UVrL0m7bYl76BXlsyeZuna45Z6/SB5jYagdzoAwjgRHkcDOKPBDUIt2GU7m974DiZzOUgZfA5CRugml3mGasP5KSWTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICS8eMnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICS8eMnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC681F000FF;
	Sat, 12 Sep 2026 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228702;
	bh=60j9bmzqYqtaQEuSmG8OtYgnWtbxGuxVxNhCLOelBH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICS8eMnVufZQUhPC7fBHf6ZKKI7VxZzSvn2Cb6VEGPPoMEtvuXgv9vU8pg9R2NpOh
	 0FGrI4oSUvzH5LRMfVOntVheW8bB4kNlYpDQkIXcFsVnxt8aSd7NzzWa1WUu6Jg/yT
	 FEJivphq/ENkUr5UBiL50KBj38JftG8f8v4479Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0439/1191] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Sat, 12 Sep 2026 08:52:47 +0200
Message-ID: <20260912065558.093739859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 05fb6ac98c49be870c5f9ccdfdf95f0107e564ae ]

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme directories by adding kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-4-sj@kernel.org
Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 4231195785647..9a918f8e4c6bf 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -954,6 +954,7 @@ static void damon_sysfs_schemes_rm_dirs(struct damon_sysfs_schemes *schemes)
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
@@ -991,13 +992,15 @@ static int damon_sysfs_schemes_add_dirs(struct damon_sysfs_schemes *schemes,
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
-- 
2.53.0



