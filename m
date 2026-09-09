Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F28D57D221;
	Wed,  9 Sep 2026 14:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963378; cv=none; b=ZC/rKkYuO6tOGxWrqyvHsqUhrhKZoaTIYQGU1YZcrL07WTVvCi5bYngcyxBDsZsCoYf3dfV/UF4oHnsMkJ35bbPPIvTQkLihv10fzv1fu95SPi/372drWSIwaiNCLE7gWvVhZ79hV2zz+9D4kaZWo8wR4XbZWMDxEP2ohn7dxdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963378; c=relaxed/simple;
	bh=WLQPe4Wxuo3m0WpNGjwa0SSuFTeBvaLjnKhgYQ7fX18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GgKZjtR9rxNqmgClbKLdn27AR0hpHdvqt22SH8G6pSNh3ZDH/ScBjpg4Ip/l1GYZ5SxgkndO9ONazt7l0FR3TpKycuIGUKMH7QEwlZa2HyhiTmu4CVSmyb4ttdSYAghTcESA1x0EQrP0OEHbcj2o4UlvXMgrcKjW7uDM0UYt4kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZa/pXw7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZa/pXw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8742D1F00A3A;
	Wed,  9 Sep 2026 14:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963377;
	bh=EPzJ67hs7Ah1rZs4kHpSdb7XM03laLH27/fL5jPgh6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZa/pXw77JBTb8rVlJbB5YrrKl3d9lYyErETV6VQK2NbsQxnQk7r7j87BPhz7icp/
	 leDNGL7LNvxJ02O0qbnNjfZM7rpwNwKwmbV/EOZN6/PtAkCg9G5cc3EebECmCtc43D
	 YmdKg3ThxwGH8DZD3upKErsCGjk50zT68kjdiS6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 058/583] mm/damon/sysfs-schemes: kobject_del() scheme region dirs
Date: Wed,  9 Sep 2026 15:35:43 +0200
Message-ID: <20260909134240.033974103@linuxfoundation.org>
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
@@ -166,6 +166,7 @@ static void damon_sysfs_scheme_regions_r
 
 	list_for_each_entry_safe(r, next, &regions->regions_list, list) {
 		list_del(&r->list);
+		kobject_del(&r->kobj);
 		kobject_put(&r->kobj);
 		regions->nr_regions--;
 	}


