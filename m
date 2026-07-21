Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB0C40315B;
	Tue, 21 Jul 2026 17:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654940; cv=none; b=SQEApOllPZufuzHFwKo84J6PhNVprFAw4OEu6cC4YK3Np3eFtBesprlcipm0kn9WkCAXm8dG7f2dwu9gcodbrzwY5Hzb8CC86M/cgYYrXxuarn8OoA7ojL4czRvfhfAuOJK6b78Q6YlngucfxLJ3U/AzZBSJTssAUEu1x0yJB7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654940; c=relaxed/simple;
	bh=6ThD3dBgsi9+BhhQDc+mJ0YwmfPQ4qflKlPS71TR6rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyK41EaR66CWZyq70ToNJ3FnJzzjCcDhR/cnhJQdDJlkiaF5jZtDspoSGoW0I7AK+yh09jt92Jyj/uzccnAI6Xabcdny2CNOSnxz0/D9XayHCxEOnF0+pvoEqXwtwvwUYcXAgkjzhtktLH8zhh+KyLHX7x2m3gd8x2BjzHqxg5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZ43JtL2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZ43JtL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF34F1F000E9;
	Tue, 21 Jul 2026 17:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654939;
	bh=6l+rsAH7KFx6L9RKEZIkf8brL+Q/9+qQfmkyPOvfE3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZ43JtL2aso+C2uQ8mjJaMhXjN5QBwSqKtG6o6sJxrg7pDNVAa7EQsJaotu4rpU0z
	 oTdcOXQdZ6O9Mv3o/8Zg4+7tTKnscnXLWw0OA4K1AHccL4CNa3lYp08UK9/dDnimzW
	 QG7jMEIRs35eneEV0LM8d3Qa5Si12/j1zw4BM4dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1851/2077] dm-stats: fix merge accounting
Date: Tue, 21 Jul 2026 17:25:24 +0200
Message-ID: <20260721152636.394164446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1917eb2db750ecbdf710f79a8042eaa545a063c7 upstream.

There were wrong parentheses when setting stats_aux->merged, so that
merging was never properly accounted. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -692,10 +692,8 @@ void dm_stats_account_io(struct dm_stats
 		 */
 		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
-			(bi_sector == (READ_ONCE(last->last_sector) &&
-				       ((bi_rw == WRITE) ==
-					(READ_ONCE(last->last_rw) == WRITE))
-				       ));
+			bi_sector == READ_ONCE(last->last_sector) &&
+				(bi_rw == WRITE) == (READ_ONCE(last->last_rw) == WRITE);
 		WRITE_ONCE(last->last_sector, end_sector);
 		WRITE_ONCE(last->last_rw, bi_rw);
 	} else


