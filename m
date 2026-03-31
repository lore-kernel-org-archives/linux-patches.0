Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E513301471;
	Tue, 31 Mar 2026 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976828; cv=none; b=EuMlzYb1p/T4FJt7BAtAWcI6OUMky7TtK/zPFTUgHZD+trE35koJ3bqfJIigvrTcZ1uxwbfKQitq8Hru3dmbRBp94a2wvsIeie0bsKAXsQESilhh5fhASeHD+qgJasKoIQOoLOMNavC8YgV1aa9OlcGGq5Rrp8Cqd90UiPtNFKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976828; c=relaxed/simple;
	bh=5ASkjnnd30bpamzJyYkQXB7uZwwWqH7xZy/2225XoKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZ01LZJCoZzuJ/AWoCnjVVZ8Ma5a1vXBM+QuSyXclHu5gS19aYzmSBxQWIopv8bihb2+SyoAJsxignRQPmS6JNiyrPy2jwrsdgd8DKPoICtMBDkTwPSzCMtYe3+mcLuVqNntNJjhoYu2v9Nal+Da+l25YF8LHd+rGZKsSlxLN2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L47uGMb7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L47uGMb7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA46BC19423;
	Tue, 31 Mar 2026 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976828;
	bh=5ASkjnnd30bpamzJyYkQXB7uZwwWqH7xZy/2225XoKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L47uGMb7YdelHd6Izy/Vs9SB6/lIckSTEvqmrIIQwvaVVnEgEnFZH4wcNPkidb0Os
	 FFYoIrDL6azodeHItCLFB/Wau5enXIvFaK6/UZS8lrDbxbHp/1eiiXQm+mwshFABn7
	 N97LxxGCbQ5+9fWZRWu6ugMQnLN6IiDOEPBQqFgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 244/309] mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
Date: Tue, 31 Mar 2026 18:22:27 +0200
Message-ID: <20260331161802.551778175@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Josh Law <objecting@objecting.org>

commit 1bfe9fb5ed2667fb075682408b776b5273162615 upstream.

Multiple sysfs command paths dereference contexts_arr[0] without first
verifying that kdamond->contexts->nr == 1.  A user can set nr_contexts to
0 via sysfs while DAMON is running, causing NULL pointer dereferences.

In more detail, the issue can be triggered by privileged users like
below.

First, start DAMON and make contexts directory empty
(kdamond->contexts->nr == 0).

    # damo start
    # cd /sys/kernel/mm/damon/admin/kdamonds/0
    # echo 0 > contexts/nr_contexts

Then, each of below commands will cause the NULL pointer dereference.

    # echo update_schemes_stats > state
    # echo update_schemes_tried_regions > state
    # echo update_schemes_tried_bytes > state
    # echo update_schemes_effective_quotas > state
    # echo update_tuned_intervals > state

Guard all commands (except OFF) at the entry point of
damon_sysfs_handle_cmd().

Link: https://lkml.kernel.org/r/20260321175427.86000-3-sj@kernel.org
Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1700,6 +1700,9 @@ static int damon_sysfs_update_schemes_tr
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
+	if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
+		return -EINVAL;
+
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);


