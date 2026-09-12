Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BC83F9F47;
	Sat, 12 Sep 2026 11:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213068; cv=none; b=UYc6Gw8pd2HdMZ4pNtA2ariXAuqo0rz/Uij1CeWaGwcxH2QrgjMzzSw6JfoBeLlKflaqPqyb1xxlXaKMHeNiRZcIm3AVy+iLuyH6OL0YDlhM8IUs8nCWuQTUijJmryjVR1hbA5iAGrcfYPeJNX4BfYxzytNANxAA/Jtnn0OdNIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213068; c=relaxed/simple;
	bh=4yh9mvstSEXZYkYW/Ktry4TdHrq2fxaO9p8Ta058YLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdSGY8TCY7g7sLJ3sHHTku4lpTcN2R0OJbvnlxgoJ913ulJ1AH1gFzPrGsG3ugCN4tXe7AaCt51zgtcqVPWFtoXur678BmOnfgYr6wtXBF6ZrJsp/zOrRbpXJTsvZuL1XDNHU0k0X67fFhdf+NEu6Xc7zqYda8vzXAMUap7SO98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCAJE35H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCAJE35H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F390F1F000FF;
	Sat, 12 Sep 2026 11:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213067;
	bh=93AEjww3vHTaK4tlXm3V0mV5ABnQetuEP5zFf0byRpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCAJE35HuMpalMhVQCG3oL3/kaqvC/xcUq5QtRPyrPHmSoFl+mzpRp/FQjr9S6Fek
	 Mj8wKUevde/X5pYPnN0wt27fB6SZslX4uJOo1/RVgrfQBlIHPJBvPPbChwgF+Cdm1K
	 YG4NhHuGdY4l5YRQw5Nyhn3gRoquMYUb88U9J+y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 0044/1376] mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
Date: Sat, 12 Sep 2026 08:41:10 +0200
Message-ID: <20260912065608.535710305@linuxfoundation.org>
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
@@ -560,8 +560,10 @@ static void damon_sysfs_scheme_filters_r
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


