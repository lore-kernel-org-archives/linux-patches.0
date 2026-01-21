Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680FA33DECE;
	Wed, 21 Jan 2026 18:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019841; cv=none; b=jGo/Y6AdNv9zxLz58TuQ+dD/LK0i8DH1AErYpIrcmDLyA7hzMS0cxWBEz+GFFDMWA03/ydPpkFSGprmyDix7cvOQ3oP6/eKqk3FnRgw8oZP1od8RsiKyMX9312tHj1jhMQzQI9lp9FHIWXZ+Ex0Zp2V2/ydDJTSO35ome+E30Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019841; c=relaxed/simple;
	bh=iOtRQMr+wzLySGyNWrSvJTzVIX55e1Oun3mcUgBN2gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RT/6DCvlWrSjYIhFZ6JdmYo7fJhiZBRtZJHESX5Ih8Cn/2PaiCA/KERHUohTL7wZYcGkTZYeMuI613PzNx22w7KW5VzBLueVxGmQAiQpBHvYJJ5CrwVXEATPYOJe93kWVyMzgoVlM0oxlDBy21jhSbu+b7ZD7y8DMwTv1nPz7Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/p9P2qK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/p9P2qK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27ADFC4CEF1;
	Wed, 21 Jan 2026 18:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019839;
	bh=iOtRQMr+wzLySGyNWrSvJTzVIX55e1Oun3mcUgBN2gA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/p9P2qKKNxcKh/B2w3morP34Z9Wh/Nuc3hninSTpkDbiTcmlOCf1Gspl/4tK/9Oa
	 UUWEaPbZai/C/H97uT7cCRr4jQDxEIciZhyK3Youga89VAWDlGHecdHX30nLCjTRvB
	 +Nn15rvt5aUp6kBgGz1gGkodVtNRcC5fcWTJAwPI=
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
Subject: [PATCH 6.12 095/139] mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free
Date: Wed, 21 Jan 2026 19:15:43 +0100
Message-ID: <20260121181414.872061273@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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
@@ -6321,11 +6321,19 @@ static int percpu_pagelist_high_fraction
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


