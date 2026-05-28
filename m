Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154642459DD;
	Thu, 28 May 2026 20:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001283; cv=none; b=FI4wEW4EG59ydRqYYt6SKiLADzvST7sIdZZkf2G+jvreQhNJO8iTWPx3RB2c+o6ltFpDyPy6t/57m7VCq6bzPkta7IONZ9enzXpKKDjvhxJRyWybErw4UhgPwMj+6IxYLBkFcCy5KdilFeHGv6OZIhMSRCrE42afPmviDenNGUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001283; c=relaxed/simple;
	bh=JQqi8Jnl+N1W22Lml3lXdAtZ4buh9d/vogIMkb6Erno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrYOzk2ANuHhD6MnpaZmixnd3SlRqfCNxY8r7i7iiJJh4Kk1iAn085N8lO6C/6QrFUwzIKbLn7vk6urUBbK/paLmcG3LCOiGxzYDXrW3vrg0gio42cPSzIBOcHlZBfuqMubUxcleirOCS/lDV4TkNMm6HIgGvkuzzRApzy5eI0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfLNWhHa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfLNWhHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738611F000E9;
	Thu, 28 May 2026 20:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001282;
	bh=Ax4ZOXIoqDcuGlh1XqfLNnj1vLK0oe1nmx3OF3m5KHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TfLNWhHahkAacNqCjRKZ60pRLZjJyIumXJq2hGS/OayrLFJjmQABzL0aXgAcxfw5P
	 wAb1Vxn632mGF7Hg3p3gOrLidPTtYcn3zw36W2nRKsukGFaUxYx96yG6nYjgXzZ7HV
	 W8ZRSXNQ8AMx3ht3MSx3OPEvIvEbUaavjP5akKRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 023/186] mm/damon/sysfs-schemes: call missing mem_cgroup_iter_break()
Date: Thu, 28 May 2026 21:48:23 +0200
Message-ID: <20260528194929.587467774@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit d4e7b5c4cc353f154d5ab8bb2e1ce7714d77a6e9 upstream.

damon_sysfs_memcg_path_to_id() breaks mem_cgroup_iter() loop without
calling mem_cgroup_iter_break().  This leaks the cgroup reference.  Fix
the issue by calling mem_cgroup_iter_break() before the break.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260426173625.86521-1-sj@kernel.org
Link: https://lore.kernel.org/20260423004148.74722-1-sj@kernel.org [1]
Fixes: 29cbb9a13f05 ("mm/damon/sysfs-schemes: implement scheme filters")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.3.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1539,6 +1539,7 @@ static int damon_sysfs_memcg_path_to_id(
 		if (damon_sysfs_memcg_path_eq(memcg, path, memcg_path)) {
 			*id = mem_cgroup_id(memcg);
 			found = true;
+			mem_cgroup_iter_break(NULL, memcg);
 			break;
 		}
 	}


