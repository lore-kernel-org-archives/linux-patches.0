Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9FE442FD1;
	Wed,  9 Sep 2026 13:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961956; cv=none; b=nh81X2D2r6zRQLCHN9jiJqGNlLcLX+Az7KtmXbkE1DIVAjuSi4Dlc/4unoVN978JblA06Y66+uavVzqh3echZnrcI5zuYtOrDzKyfuEY8xfmK/5+4MS4wxsO2USpwjGzis2u+yyY4QQOydQoP+Ui/YOHqtIzwqhgTxDEdhAHhLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961956; c=relaxed/simple;
	bh=VvcK9KwVZYTB/zVTTfhhulSbNF6CCOj9q0T2FVGRMMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPqsF28OwRSgWi8PKneqswFRahR4zHOzs60+e91bj/XaYXWwmIgDoIQ81ij98Er5cT/50OEFXkMjZK8Pz4dc3FHCJD7aCayQ+JVVK3YCo2VfCTej4UIbnxq54C0/bmJcktMvFtq2vFJ7kZy190s0R4PXxA0FsioZytkptYbb9ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkR6kb80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkR6kb80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654401F00A3A;
	Wed,  9 Sep 2026 13:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961954;
	bh=fzgLSv7FxcY0mOjnsKXE4x0wgytu8SKTuN3h60UNJeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkR6kb80g5ktRZkBRVC5IN9RXJGFqZGffNQ+iXcixJYboGEZd1P+qHwzgYcgiO/Zh
	 k6aV3dr0K1+HOx74t3fErI2bw0nKpQMZ0XWBEbFeUaXQ1LjhnFGcuwQz9LxPQpp3C0
	 I2drIkNq34NhtLcHlrbR+laAY9AzBAD38xRTkQzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 083/556] mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
Date: Wed,  9 Sep 2026 15:36:03 +0200
Message-ID: <20260909134233.430603671@linuxfoundation.org>
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

commit 286380c78bc51e6c578621b9ae660bf9e5ad2563 upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme action destination directories by adding
kobject_del() calls.

Link: https://lore.kernel.org/20260628220121.97360-8-sj@kernel.org
Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2138,8 +2138,10 @@ static void damos_sysfs_dests_rm_dirs(
 	struct damos_sysfs_dest **dests_arr = dests->dests_arr;
 	int i;
 
-	for (i = 0; i < dests->nr; i++)
+	for (i = 0; i < dests->nr; i++) {
+		kobject_del(&dests_arr[i]->kobj);
 		kobject_put(&dests_arr[i]->kobj);
+	}
 	dests->nr = 0;
 	kfree(dests_arr);
 	dests->dests_arr = NULL;


