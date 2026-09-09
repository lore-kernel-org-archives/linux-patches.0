Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E1F4C6803;
	Wed,  9 Sep 2026 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961967; cv=none; b=fhIf1/1R6tLiIg0XxEW0xU52sse7MUr5q2AyKrclGpQE28f/GdrgjxIcAsc/Onu3D6W0C7oIdrhWp4sUAbWMlH73WpYiKOWkIBxsME03yS2YSpYlyl2ps6dB88nqqFe9UgbDT9qU3jPT+YCtugPD4ScXd8RPdfNzX+8aIOS+pmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961967; c=relaxed/simple;
	bh=BON3mvz4Cl7/FjUBmJad/QY6Je/7xmLR9eWcRMMtfWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T360eHj9D19Dghq7zgRAN7D0QQWX7Sxlt5mpJ0wL8arK2txLep4WgwvNSahWAKFuZmF+NztBQQ0ukQAQfNeSHxMH3Ep4dBOILsjIoMnAlUWmWdfShztJU0Zncv22xHwIgSM7uww+e5SsKgaL6vXRa8bCG6FV3tQCFM6NgDglD9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Dn+S5eW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Dn+S5eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC64E1F00A3E;
	Wed,  9 Sep 2026 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961966;
	bh=64vbqGJxs7CCEq+LV5HUrc5v7Q4jvx4IDqp8lp646/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Dn+S5eWpv5VJi+v+sp8b1qkW9Nut4IlWgKqqQlR9HZEANC8pCGBjNUd20DQdokL/
	 yHZGPipUnCca8svszTbIfa8WsZWJNAeWN6h62LaFqjwtD8w5ZZ4f8kyiL3I6Gi4dHn
	 5iOFP/XZ/M8jjAPpBI14M9C2LXnUL+pTcJlvDmG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 087/556] mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Wed,  9 Sep 2026 15:36:07 +0200
Message-ID: <20260909134233.566072439@linuxfoundation.org>
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

commit f3ec3271210781c255e737498b84d5790e8176b4 upstream.

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.  Fix
those issues for scheme region directories by adding kobject_del() calls.

This issue was discovered [1] by Sashiko, though its analysis was
partially incorrect.

Link: https://lore.kernel.org/20260628220121.97360-5-sj@kernel.org
Link: https://lore.kernel.org/20260517205828.6204-1-sj@kernel.org [1]
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -332,6 +332,7 @@ static void damon_sysfs_scheme_regions_r
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		damos_sysfs_region_rm_dirs(r);
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}


