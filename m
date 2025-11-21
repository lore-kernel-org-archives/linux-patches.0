Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CFD2F6577;
	Fri, 21 Nov 2025 13:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731345; cv=none; b=sh4qvBC2Va6o6Q6v5b+Av6zIEJPiX1K2JYrR+xeW8oymv4kBEpeIvm8Es9zS0oSVKQ1usk+S8IYyhLvJzQCjrBEyYjkU8rfFmpsYcV/mvamF3QO0MoRAmMVDi9pbCNHR38iC6floUtHPSHbh0muMbuG6IRt+WlWHG2NsQZYApCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731345; c=relaxed/simple;
	bh=R9feXb1OKTfIUoa1QSzyLTBOVc7eEZAd8wiAh60BKMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUzqTYYEfp6WF+yG6nSyBh44LYvzNWyfwzwrN5bONJt+ziwSpZm1MKXJn2M0xPORz8tPXlQzfkDYIDahSn6saUgpkjKl+5UGXP18dJSiqRXWDVBldUONzSkrseIu6tZCsQpJRVAplIWghIErVExv/PJDB3aYEXMAfM3wUPXyJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NM8tChEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NM8tChEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5985BC4CEF1;
	Fri, 21 Nov 2025 13:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731344;
	bh=R9feXb1OKTfIUoa1QSzyLTBOVc7eEZAd8wiAh60BKMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NM8tChElNlqg8MQRtoLi/IavXVz5t9BQ7TrVI5HqlAbTPdu1hWfgdkDG273VAmnxz
	 2kLpN0X+TYJDkbP2YSj5PjwBoPWIiyDYUqXYtc8YeCspabKdlVzypj1RodTAPUHLCF
	 ltMqa8wHVLti5c8bstSqF0YvUimy1+l6+2Zu1Rwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	ze zuo <zuoze1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 175/247] mm/damon/sysfs: change next_update_jiffies to a global variable
Date: Fri, 21 Nov 2025 14:12:02 +0100
Message-ID: <20251121130201.000614541@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanmin Yan <yanquanmin1@huawei.com>

commit 9fd7bb5083d1e1027b8ac1e365c29921ab88b177 upstream.

In DAMON's damon_sysfs_repeat_call_fn(), time_before() is used to compare
the current jiffies with next_update_jiffies to determine whether to
update the sysfs files at this moment.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier. However, this causes time_before() in
damon_sysfs_repeat_call_fn() to unexpectedly return true during the first
5 minutes after boot on 32-bit systems (see [1] for more explanation,
which fixes another jiffies-related issue before). As a result, DAMON
does not update sysfs files during that period.

There is also an issue unrelated to the system's word size[2]: if the
user stops DAMON just after next_update_jiffies is updated and restarts
it after 'refresh_ms' or a longer delay, next_update_jiffies will retain
an older value, causing time_before() to return false and the update to
happen earlier than expected.

Fix these issues by making next_update_jiffies a global variable and
initializing it each time DAMON is started.

Link: https://lkml.kernel.org/r/20251030020746.967174-3-yanquanmin1@huawei.com
Link: https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com [1]
Link: https://lore.kernel.org/all/20251029013038.66625-1-sj@kernel.org/ [2]
Fixes: d809a7c64ba8 ("mm/damon/sysfs: implement refresh_ms file internal work")
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1514,16 +1514,17 @@ static struct damon_ctx *damon_sysfs_bui
 	return ctx;
 }
 
+static unsigned long damon_sysfs_next_update_jiffies;
+
 static int damon_sysfs_repeat_call_fn(void *data)
 {
 	struct damon_sysfs_kdamond *sysfs_kdamond = data;
-	static unsigned long next_update_jiffies;
 
 	if (!sysfs_kdamond->refresh_ms)
 		return 0;
-	if (time_before(jiffies, next_update_jiffies))
+	if (time_before(jiffies, damon_sysfs_next_update_jiffies))
 		return 0;
-	next_update_jiffies = jiffies +
+	damon_sysfs_next_update_jiffies = jiffies +
 		msecs_to_jiffies(sysfs_kdamond->refresh_ms);
 
 	if (!mutex_trylock(&damon_sysfs_lock))
@@ -1569,6 +1570,9 @@ static int damon_sysfs_turn_damon_on(str
 	}
 	kdamond->damon_ctx = ctx;
 
+	damon_sysfs_next_update_jiffies =
+		jiffies + msecs_to_jiffies(kdamond->refresh_ms);
+
 	repeat_call_control->fn = damon_sysfs_repeat_call_fn;
 	repeat_call_control->data = kdamond;
 	repeat_call_control->repeat = true;


