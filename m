Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5143D6694;
	Wed,  8 Apr 2026 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672382; cv=none; b=YPKMLEGA3oiTHlELuB2bkA+rjJ07O4ZVIWScUOjIOMqMq+cfVVmEXzfwSP45NFk6hdjiPOR874YcLntNxwbc8ASMFjVIVtGDWyFlB1LDMHGPdE3Xl4BlmKsAn77eLIWrnB690Vjhutkuu60KusDkjEYLhscXi8ue7gQWBEUdTTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672382; c=relaxed/simple;
	bh=FbfvpjzXhpKY2H5Ad2udY4sItoiRgKjoo4yU5Rea2HM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE/bxoLZwyS+iI6PDMDOADN4hT/S5HzU6VolL/zAoc+kq+ObdF9j5uYZD0PQLVioFEbdipdes5GXPkcIu5trnCQ9ogE94z4vAcx9qgCKh9m563lECw1+lGw9zKkcfXx3YDxkGG37hUK3WNCFGucSThfyUJ5iJ7rK7rRJMmDcxBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dtyxHDJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dtyxHDJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60954C19421;
	Wed,  8 Apr 2026 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672382;
	bh=FbfvpjzXhpKY2H5Ad2udY4sItoiRgKjoo4yU5Rea2HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dtyxHDJx19rJJSiAHTPhMbgHM6vhm2ysawuoafTq7op8mo46y0kcOPtvgEQylJuM
	 nZjcJzqhNOZVukfGCWKEm4Sn+2dXnjKCYC98emv89sIxBW2lVXY3yNKCBAuUxyafcU
	 rznN3Hn9MftywXyEdgzqxNk19jT/JhXlPLHsuEA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 266/312] mm/damon/sysfs: check contexts->nr before accessing contexts_arr[0]
Date: Wed,  8 Apr 2026 20:03:03 +0200
Message-ID: <20260408175943.681918013@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Josh Law <objecting@objecting.org>

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

(cherry picked from commit 1bfe9fb5ed2667fb075682408b776b5273162615)

Link: https://lkml.kernel.org/r/20260321175427.86000-3-sj@kernel.org
Fixes: 0ac32b8affb5 ("mm/damon/sysfs: support DAMOS stats")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index a5a1e90e53e74..bdcf895a29a78 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2576,6 +2576,9 @@ static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 {
 	bool need_wait = true;
 
+	if (cmd != DAMON_SYSFS_CMD_OFF && kdamond->contexts->nr != 1)
+		return -EINVAL;
+
 	/* Handle commands that doesn't access DAMON context-internal data */
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
-- 
2.53.0



