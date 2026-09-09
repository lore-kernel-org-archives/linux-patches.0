Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746D8582BBC;
	Wed,  9 Sep 2026 14:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963375; cv=none; b=JyAfsXKBTfMRfZZbqfi4ZxKqNZu5Yw1tpGyS2WdOOif1dCZnoZbCVLvjZF5DMu+hfSc2MBgLh9HKaGPAv+sXRC8wrnUvoJ5iuD326pyEwp527rKdJdzL/USOgQhQhtlihBibutRnjn9rKIA/6FBKcpv7RkIM+kO1gdNZiWCzceM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963375; c=relaxed/simple;
	bh=A3srj9nVltFotAXG/gnMyTlLDb9DxM5GBguKwsAchWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Go1G+sDqI56rUYJQQrCD+xHsUMz4nx/wuA1Qb8s1Q10EGaIm8NNaBjqVy0VXgMGhto8c9/pWQCsNsELgVq4ekbgJuWm6LqAWk8MLruBeoZvMPWMMBv8RrioeJdtZjp2Dd62uc7oUwQgtY73in7ePhkkUybh69VI1xIclfA8cp7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1scS9LDP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1scS9LDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EC41F00A3A;
	Wed,  9 Sep 2026 14:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963374;
	bh=48Ueetm4J9OxotwW7y5dXg+vN9E/Ny6m7rZf31hxJa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1scS9LDPwgCKn0SszEjRBcPlM9V3Z1j0FuT22LcCDg+7sB8Op59Cr7B2XpZn+0vct
	 Aslr4ymD2RDa2Emw+ixV2jol6QfdR1IKmDmFZ0KIVRl4jHkp644y4UMHb0imsV3O/j
	 3QOyV7ZMbmuw96N0XyOIB+S6gVHJMILSkAK8k7Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 057/583] mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
Date: Wed,  9 Sep 2026 15:35:42 +0200
Message-ID: <20260909134239.982103259@linuxfoundation.org>
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

commit 0d4397ca921ceaf80fc3eca4c8194812ff79a979 upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme quota goal directories by adding kobject_del()
calls.

Link: https://lore.kernel.org/20260628220121.97360-7-sj@kernel.org
Fixes: 7f262da0a30d ("mm/damon/sysfs-schemes: implement files for scheme quota goals setup")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.8.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1193,8 +1193,10 @@ static void damos_sysfs_quota_goals_rm_d
 	struct damos_sysfs_quota_goal **goals_arr = goals->goals_arr;
 	int i;
 
-	for (i = 0; i < goals->nr; i++)
+	for (i = 0; i < goals->nr; i++) {
+		kobject_del(&goals_arr[i]->kobj);
 		kobject_put(&goals_arr[i]->kobj);
+	}
 	goals->nr = 0;
 	kfree(goals_arr);
 	goals->goals_arr = NULL;


