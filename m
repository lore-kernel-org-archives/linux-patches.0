Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6414A431A5C;
	Sat, 12 Sep 2026 11:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213320; cv=none; b=aDhugoaLnVIj4zpQ8lwglTTlH9HlNdkftYO4Px1aNlnPBuXmX6sXImjyhBlj5i9QsX9xh1xnTaAnF7Bfl9VY3QpYyrt08KWU6j2Z2UCZ4p3/veHvTISB7cT5bMt4sWCrTqNehQnZ/Zfg2gQf0VtuPdBSIxarPn/Kf60Hw1d/W3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213320; c=relaxed/simple;
	bh=QckslUUbter/ooqXlI3x9EJiMFVrQydrdhNuyQBZ5XE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/avWseTwazCWMben3qsYQF5NsGhf8hiQ7evvdq/Cdzk385yQnWl0V3vF9g1mn2JjQPmcaZeXB981f1Oro0UUqrtUNfQ5laDzrKAiUjB1saLaBhf+gR/bfqTpwLXt4s8IuFi61wBKFEdI9vD0Z0TCwjpIoVXxd/XSI7w61Owrhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBarwPgW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBarwPgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A10E1F000FF;
	Sat, 12 Sep 2026 11:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213319;
	bh=VBuHoC6SY5qPp0S4grl4tSdnlmZhS1E6ldtdHw8xpAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBarwPgWSRkehMjBp9hp+6yp6SBpRxGlxNqlzDR54jr9oVoNfLoll2rTrNsI0U52I
	 ivNwxGBPvjnY9ovAP4JvomK/6pmw3ejhGpS/0kRtSdwxdcqys/EYEybjDgt46ASlEz
	 8huFd5L7TEpg0T1kqluB8zj4K7h/eX/qvGKHmrY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0045/1376] mm/damon/sysfs-schemes: kobject_del() scheme quota goal dirs
Date: Sat, 12 Sep 2026 08:41:11 +0200
Message-ID: <20260912065608.558352991@linuxfoundation.org>
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
@@ -971,8 +971,10 @@ static void damos_sysfs_quota_goals_rm_d
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


