Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FE13016E3;
	Tue, 31 Mar 2026 17:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976831; cv=none; b=lU9yfOmxb/XNv76frUJ8tNbYE9nXqdaxK8siqv2RYSqmDJHMQbsl8VWdFYED1E7RTI7i0rqffaJ8pQprI+sdgZqAIAUHZJQfTzCXuHCwPLzVeknxy5/wh7RQFLVRO0uB+9yGisA0gxuWzG+BJB7+nGxFxXjAL0PE4cPNvI3aLKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976831; c=relaxed/simple;
	bh=LLKFS79j+8zaNuUAI7RxsDTFMp55FGp54cr/u7YAK7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw7vBLEnyGcGawNU9B58yJMnZEB7a02JFR8IRt/dgAcoVl5LwHEGzoE+V3+befOu8E5uoYoAgSj0klue2B4CBEY5uNUu6B4H3PGgrGsGJ9YSz7/eAkQ7sRnOkkMreqNidD5kWfvmdBNr8HCkaeL7+uiVzEt8nw29ajlDgSIMG2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLjAL7qe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLjAL7qe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3D3C19423;
	Tue, 31 Mar 2026 17:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976830;
	bh=LLKFS79j+8zaNuUAI7RxsDTFMp55FGp54cr/u7YAK7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLjAL7qeCix2xnabpBzJ7xtMG6blOQd4O5cEAR3JtsgZ60Jn24ZK/NE7AD2Zfqgth
	 os3Dj626YSE5Tt5MsJ8KjoNbgUOsrS2AvzL+h6L0CciBTlrSWvjeShd253RORujsRx
	 +9SH8gdMXTIHfYakpvcFamcq4FCPbTHzFNN5DbM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 245/309] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Tue, 31 Mar 2026 18:22:28 +0200
Message-ID: <20260331161802.588613976@linuxfoundation.org>
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

commit 6557004a8b59c7701e695f02be03c7e20ed1cc15 upstream.

damon_sysfs_repeat_call_fn() calls damon_sysfs_upd_tuned_intervals(),
damon_sysfs_upd_schemes_stats(), and
damon_sysfs_upd_schemes_effective_quotas() without checking contexts->nr.
If nr_contexts is set to 0 via sysfs while DAMON is running, these
functions dereference contexts_arr[0] and cause a NULL pointer
dereference.  Add the missing check.

For example, the issue can be reproduced using DAMON sysfs interface and
DAMON user-space tool (damo) [1] like below.

    $ sudo damo start --refresh_interval 1s
    $ echo 0 | sudo tee \
            /sys/kernel/mm/damon/admin/kdamonds/0/contexts/nr_contexts

Link: https://patch.msgid.link/20260320163559.178101-3-objecting@objecting.org
Link: https://lkml.kernel.org/r/20260321175427.86000-4-sj@kernel.org
Link: https://github.com/damonitor/damo [1]
Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1570,9 +1570,12 @@ static int damon_sysfs_repeat_call_fn(vo
 
 	if (!mutex_trylock(&damon_sysfs_lock))
 		return 0;
+	if (sysfs_kdamond->contexts->nr != 1)
+		goto out;
 	damon_sysfs_upd_tuned_intervals(sysfs_kdamond);
 	damon_sysfs_upd_schemes_stats(sysfs_kdamond);
 	damon_sysfs_upd_schemes_effective_quotas(sysfs_kdamond);
+out:
 	mutex_unlock(&damon_sysfs_lock);
 	return 0;
 }


