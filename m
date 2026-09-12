Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1B82594BD;
	Sat, 12 Sep 2026 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221292; cv=none; b=g2Y6uTu8PdC4fCZFRwlzarp7cH9KbZYy/gyArfKcLLPwh54jTqNb+uOl3CbtXYYhQyky3eIi8Wyeff4w729RysBGZsWly0epEqHcygK0Z6pA9NGw9+PZ/m8emWj/NsDLO/XWAVSXfX+Yf7tggozXZjAwee888F0TAaxLzYjeJgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221292; c=relaxed/simple;
	bh=6ATzWBXVOQN4G4ZY3lOEAA2Yygxq1ocvpt/zAw3Gxno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ef25tmJvdZO9Ky5ApWU3hh6Ggz4YoaieltvUvmGu7TPBnPE8PWi9uKLB3ecj58MtdGF/ufJ1uLc/tRNbxORKasEb8WQwAXWrEHSxywpYJiLVAJOuaiizWaVb++ngaxj1dusFz57z9GpDwwdxOkzRIW4zmX0vvBl0Y/AEw9w0YCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fp712wNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fp712wNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200011F000FF;
	Sat, 12 Sep 2026 13:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221288;
	bh=4uEo+Jlxr5Y8ARL+m6ReIpPMelpOTMhU+CsJQ4AejFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fp712wNLJLwEipNgdot3Ku+ZHGbn0SsYyA+59sP6jXvp4ZHJMxZ6zM+RN9loigOG2
	 gYKAdQICS6X9YiUcmfFQLLS0IcN6rDdoSIIvpMw1L5y7k4mTwAImw7TiRn1ixbiM5k
	 SOGuhecBkmnL8DnfFiGeeZCcWwSCqby1NGszHilc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 0345/1424] mm/damon/sysfs-schemes: kobject_del() scheme filter dirs
Date: Sat, 12 Sep 2026 08:46:17 +0200
Message-ID: <20260912065615.014931798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -513,8 +513,10 @@ static void damon_sysfs_scheme_filters_r
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


