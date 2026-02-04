Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C687741B37D;
	Wed,  4 Feb 2026 14:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216819; cv=none; b=lDQ8qH4sGci8IwtBr9qrmdmRgLlvKgkDf1E8FdNeYn5Im0SHXouW/TlymlZWUexLCXEQXbGAgAsR0ydyQa9DNRsCOVOv0dCj16eZzwgWdJ7eTMUe7Ryi2hwO7gzRZpSwP0v5gwa1NhTqPe47lBod8PxUgDRCJ0Wfqb7UYy/qy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216819; c=relaxed/simple;
	bh=I+o0vftEQaFbL6S8I852RiKbbQOYeOBI0IuWq0FLiCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEkqGc9whatY6pCn2afHT4RqZUlcVDmisFU7j83tNxvui8eS8DiJinPhORnbLOwbj3q8/yzaZlszhSwvbiq9ydLf9t0jzPmzam7FwMG6rKkbEnYgYtT9Z0s832O640U1b+DZ5w26OnWg1L7DyQcttIbW8sKjWLeUKP4QP9L9Nd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wGOaSFpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wGOaSFpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47713C4CEF7;
	Wed,  4 Feb 2026 14:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216819;
	bh=I+o0vftEQaFbL6S8I852RiKbbQOYeOBI0IuWq0FLiCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGOaSFpmGlr3jqUbEixeVXIHZBskXLZjNoD7GQLpUlRhZ7AN3c2dxzELW1dzjlQ5u
	 igzM0vdPmX6UCI+UYl4ZElYDVlySvXUaGEYkJvtuxz9c+u+E/115N0Zb24HBy2KSyR
	 RaqFj1b4OHKz9jVLU9eTNNOuSaQne++/vppTSIk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 040/206] mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free
Date: Wed,  4 Feb 2026 15:37:51 +0100
Message-ID: <20260204143859.655562836@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aboorva Devarajan <aboorvad@linux.ibm.com>

commit b9efe36b5e3eb2e91aa3d706066428648af034fc upstream.

When page isolation loops indefinitely during memory offline, reading
/proc/sys/vm/percpu_pagelist_high_fraction blocks on pcp_batch_high_lock,
causing hung task warnings.

Make procfs reads lock-free since percpu_pagelist_high_fraction is a
simple integer with naturally atomic reads, writers still serialize via
the mutex.

This prevents hung task warnings when reading the procfs file during
long-running memory offline operations.

[akpm@linux-foundation.org: add comment, per Michal]
  Link: https://lkml.kernel.org/r/aS_y9AuJQFydLEXo@tiehlicka
Link: https://lkml.kernel.org/r/20251201060009.1420792-1-aboorvad@linux.ibm.com
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -8764,11 +8764,19 @@ int percpu_pagelist_high_fraction_sysctl
 	int old_percpu_pagelist_high_fraction;
 	int ret;
 
+	/*
+	 * Avoid using pcp_batch_high_lock for reads as the value is read
+	 * atomically and a race with offlining is harmless.
+	 */
+
+	if (!write)
+		return proc_dointvec_minmax(table, write, buffer, length, ppos);
+
 	mutex_lock(&pcp_batch_high_lock);
 	old_percpu_pagelist_high_fraction = percpu_pagelist_high_fraction;
 
 	ret = proc_dointvec_minmax(table, write, buffer, length, ppos);
-	if (!write || ret < 0)
+	if (ret < 0)
 		goto out;
 
 	/* Sanity checking to avoid pcp imbalance */


