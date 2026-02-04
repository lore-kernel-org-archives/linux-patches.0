Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48966426689;
	Wed,  4 Feb 2026 15:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217582; cv=none; b=Lm974L90Ny5IxekvvTt2wcphW0RvIFAFrYgcklVn3tPuz3dHQiaFuYHaGMrTkrA9eTDx1wRH0Q2MNu7OaEjE24b923oJ2yAknu/iNjt3CN1ISrhrf8E7eTor4ka19j35MDgrydK8m3DBVfLZUJAMxCGKWgPrk61fnWGSNWv/kvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217582; c=relaxed/simple;
	bh=XLNhqVR+lsN8C92JfVxzTP+gF/pr7uQoxWmMkwVq/pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smB7G7/mSBg5xu5Ng7wCGOBR1N2Asls059tjCdu9L6MkL9Da6l6PMZ8oJSL9/BIKOIUiZjMOPPw9Gu7fleYKxsKJNu1QBeA3rrBmTHaihYaJPg5R2gvpsQLmuYjzamIhoa4yzVEZkQrFjzpayAYFdujEZqDpg+JTNAOraB6kl8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udEMXEhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udEMXEhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE4FC4CEF7;
	Wed,  4 Feb 2026 15:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217582;
	bh=XLNhqVR+lsN8C92JfVxzTP+gF/pr7uQoxWmMkwVq/pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udEMXEhY6sBAbqsGsPTKAIyshpSDQ0qNDuraKi6FYeQ/RcwTLvpIpFsQ36PE8ODaf
	 Wk2ZudP2muVgbsbxv1blMWughpbO90iQEnu0SgREOi+XdsnVKhRNIOHGKAF+mWG5Rp
	 aCnauDC/3DiaEtwUpeTxSyqY5UD9tuYO499m0t64=
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
Subject: [PATCH 6.1 059/280] mm/page_alloc: make percpu_pagelist_high_fraction reads lock-free
Date: Wed,  4 Feb 2026 15:37:13 +0100
Message-ID: <20260204143911.776218429@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
@@ -9067,11 +9067,19 @@ int percpu_pagelist_high_fraction_sysctl
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


