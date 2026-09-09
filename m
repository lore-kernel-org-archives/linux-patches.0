Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BD125783C;
	Wed,  9 Sep 2026 13:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961964; cv=none; b=GfUDEBUjztpa13+BdFoPLbY80icpbwJVX9aPoHjD6WYkKo2sK1zM4Kx9l+zwbLhezWolqPgOKZulLx5wmf+0aisMZzOaugs5HxFa9rnhVSLpGFuZpbYHW68M2gIxaMU8MmEKr7cjuFVa2EoX6FPu58v/yERjaY0ajn8IYSy8pLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961964; c=relaxed/simple;
	bh=rzSslgqDirIsHTXXi4ti7K5hl9i/jAorKCpy3oCXwY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQlzq4TxP10v86xiCC+MpF+eF6/RbMYkao5pcjJO4Kb7GzE+qQrPXStQv042xrNKmbsJH25+Mr5ejnr4Spa2yY/ueFZIE5rRJbKQZlraO0U59Dp5d1yJyBhgjKa1rX9h+NSukmXYsn3to+Mw5EmKp8PNMhVpNoKCB3eijBb38n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABqRsjCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABqRsjCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E5D1F00A3A;
	Wed,  9 Sep 2026 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961963;
	bh=TvHIG4ndaNTb1JQAWviqgKQyzGFYNekn9JIe80bwVRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ABqRsjCGr1We41VHLD5BCrIzP7WWMIKxD6BXSKqBc5f/SujIqfNlJ0Y0dTgaItjyi
	 nALV88FjM8eYsNWObggYX934fOF6YtRgMZrs4TglGYpDfEfXfTMQE91n3/ufvbHoXs
	 A6SvosW0pxyWLE6kCSLN9uybatX3vxj2nqGDtOZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 086/556] mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
Date: Wed,  9 Sep 2026 15:36:06 +0200
Message-ID: <20260909134233.535041117@linuxfoundation.org>
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
@@ -1462,8 +1462,10 @@ static void damos_sysfs_quota_goals_rm_d
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


