Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2491E31714F;
	Tue, 31 Mar 2026 16:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975401; cv=none; b=Yi0TxsyubtRFMqCH+phw4lX4d6Ofo0+7Fbx2zFv2X+rpBSvB4g01n7AuyP4pLwJtSc1vRQXc4gnQcKpOKywcOgh2EAZ26Ow+XCPriCnxklb2Ds6kAkQZCUT9PHOtwqiSvoXVzRek4lEWEhwcpVeM4KlK2eYGjrTD2Z3T6eM2BrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975401; c=relaxed/simple;
	bh=HG6TslWt9VUZwxXXRzUlWiw8HPKBqUD108YQzn0jp8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueP+gVeGJixD8AQ1f+nEAhHc7w1ZMuAzGSIIEon/0DNx4ObGRAyqjmivXWntBqFSsQ6YCpJJwL5iiTfySl1utNfvLOX8kImvi8VYdjjNuMR/YZ7bSpR3x+KJx5+Pm845WCy7xYGjJu2a0IxtXQRWsJV6acaK8LFeJ55j6F0nINU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDUAo+Of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDUAo+Of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE30BC19423;
	Tue, 31 Mar 2026 16:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975401;
	bh=HG6TslWt9VUZwxXXRzUlWiw8HPKBqUD108YQzn0jp8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDUAo+OfdqSxhioZX7Uw56Y2RZaFoJNfjpIYi4DaFNYygOvzdgrV+sxKmLY8SLtdF
	 hEuzP24lcPtDDd1nWmwpaJakfazEOg/s0OwRUbngJRa1TTlONWhUdhWBK7VrUyFvcq
	 /0NtUvoz7bK2sZfrULOcxeQNL3DZghPgXyCdDDiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Law <objecting@objecting.org>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.19 281/342] mm/damon/sysfs: check contexts->nr in repeat_call_fn
Date: Tue, 31 Mar 2026 18:21:54 +0200
Message-ID: <20260331161809.279805413@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1622,9 +1622,12 @@ static int damon_sysfs_repeat_call_fn(vo
 
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


