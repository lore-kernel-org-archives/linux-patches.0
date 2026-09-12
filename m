Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003CF3BE645;
	Sat, 12 Sep 2026 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226690; cv=none; b=RZXIuDBKw+rHoGk5hHc5t9hJjiC7kOSK6MxH2Xhr+eC97vzEBHU/fXhfVasr02T4y0lf2S6xATpxoImBlLKfoPZ0QJ5we34fj8YNThER5jj2jt3Rvq6x7RDRpvk+8Bb2zBLYHlnNObnXuxyfb7+27+YyKUp9ueqn+zhUxw+anH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226690; c=relaxed/simple;
	bh=+joLuKTcySVlNMQKps5ygkrZs0hfMhUrQ+VtL4MtLok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gse+IdzmX3Ap97kRDZoOUJRkPVVZeGbyQaUS3Zx6JeJzbf2sZh033Ksdoi1GnVU6UNKgggxjnsEIifBObFYQt4u7K19+aU304Z/XnOA+QMoMtT6ZCjiKJ9Fo2u3CZGtdSyTotME7z5/Sl4eHRiJgBxWkXMYcmTVfcOr4YUGKF6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEipDDTi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEipDDTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4AA21F000FF;
	Sat, 12 Sep 2026 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226687;
	bh=sacq85/Kst9vo7YBJMxVEahsdEPemcO69NWKxYmCDHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEipDDTiDz/1ahFrttlibaCn8DNTLDaj70PbZZA2hd7JlkCCKEsPh+P33SmRgyfiF
	 35378lqSVAR7E+9Xl6Wnrf8kcRfWJxLV8ctIYiGnwOqWN4D6ZY6ik3EWyqsI6ZbXqp
	 uuy2TRo7ISqu8lSgjBdV5mEcJJE0KQry2/YWs9hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0011/1191] mm: memcg: stop reclaim when a limit update is superseded
Date: Sat, 12 Sep 2026 08:45:39 +0200
Message-ID: <20260912065548.358281085@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

commit 9477820c63cbf4d97114238f3d1ff10dfd6bee3f upstream.

kernfs serializes file operations only per open file, so separate open
files can update the same memory.high or memory.max file concurrently.
Both handlers store the new limit before synchronous reclaim, but continue
to use the writer's local target in the reclaim loop.  If another writer
raises or removes the limit, the first writer can continue reclaiming
toward a stale target.

For memory.max, this can leave the writer looping indefinitely once
reclaim retries are exhausted.  The OOM path sees sufficient margin under
the current limit and returns true without killing, while the writer still
compares usage against its stale target and records another OOM event.

Check the current limit at the start of each reclaim iteration and stop if
it no longer matches the writer's target.

Reproducer:

Populate a cgroup with anonymous memory and disable swapping.  Lower
memory.max from one open file, then restore it to "max" through another
open file after the new limit becomes visible.

Without the patch, the first writer remains blocked and repeatedly
increments the OOM event counter.  With the patch, it returns normally.

This was not motivated by a reported production workload.  We found it
through automated randomized testing for our cgroup observability work
and reduced it to the reproducer above.

Link: https://lore.kernel.org/20260724021805.1234583-1-guopeng.zhang@linux.dev
Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Acked-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6428,6 +6428,9 @@ static ssize_t memory_high_write(struct
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 		unsigned long reclaimed;
 
+		if (high != READ_ONCE(memcg->memory.high))
+			break;
+
 		if (nr_pages <= high)
 			break;
 
@@ -6476,6 +6479,9 @@ static ssize_t memory_max_write(struct k
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
 
+		if (max != READ_ONCE(memcg->memory.max))
+			break;
+
 		if (nr_pages <= max)
 			break;
 


