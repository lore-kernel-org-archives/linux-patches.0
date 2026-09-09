Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B302BE7BA;
	Wed,  9 Sep 2026 13:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961959; cv=none; b=vDDmEP/BWJzGjelao5hV+mSNTjH9Jtr2TWSTV5R/hhz85PLq2O0m4dU4VXVfnJl3zeIANc34aKsbeRmqPC0MhOcc55VhWJyR7a87/ndV5beDXwyhkjUeFRx36ILTLbpoPX/taRRs8OXI8GZyXz8dAOX1zCfG0vz/3gr3oei8NU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961959; c=relaxed/simple;
	bh=o48YAe6ZDodz5iUilUmb5bOFG73UXh3W09kJcamiXeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BcmOLLsfx86z/dWX4V0aEAJ2pzNhF1Oqhmba1WPBOcCgqhRysOWZ9lTDLB/ojke04VFZAOdErPR0sF7A6jzJNaV55nAa3X0y5UTBYGqsdm1lk2rQuVeaJO+ETrYJLVHiL6iAFrv69l6VFADqKLJ4hC06NDqCyDF95GhZAnwbXhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KteAFxYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KteAFxYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3571F00A3A;
	Wed,  9 Sep 2026 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961957;
	bh=xuTW2VGEHyz1TnUvRDl8Nqx2bzHjgkgJXQcrE2MTn5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KteAFxYJ7sypWmFyMNaYHEl9dx6GGvW7ql3WwE3DrVauExDY/Oz/XvKhwcsTWkzjp
	 GbOea5FQk0YYHYrWqrb1yWAV07hw2hb6cthpuPwWfGmhfKDujCzQwD295cY73yWXc4
	 K4rvxJ8Au6LU0BB3epHdo+HPfkjZju9+T4b9khSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 084/556] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Wed,  9 Sep 2026 15:36:04 +0200
Message-ID: <20260909134233.466247660@linuxfoundation.org>
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
@@ -2683,6 +2683,7 @@ void damon_sysfs_schemes_rm_dirs(struct
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
@@ -2724,13 +2725,15 @@ static int damon_sysfs_schemes_add_dirs(
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


