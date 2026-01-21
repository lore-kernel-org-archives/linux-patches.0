Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C9A326954;
	Wed, 21 Jan 2026 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019856; cv=none; b=If5aoWOQJEHidWvGb2+D+42aknIGMmUXz4tvcbkvwsZjPPQQuy1VhFQXVNnJfMxerNQGb9VyPWCL9w24nG9yeE169cLC20/Pi0gY5IoWzWIDn7WrPSnfb8IQJJz5WDs+vitXvhOWODoGh97WmeHUnLgRYjazUoDKUqWnVR/Ph+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019856; c=relaxed/simple;
	bh=k4iKiEIc+Qe/DSmn4biLQtcRusLw1Nz8egyH8UGcags=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S+2EQEhWkL6SRPfCBLWCiQ8GRILVy+NUJoz0ZCiJ54ltMsYIcex0qqpduCGWrgz/P+wduECyeZY/Sp6WoIae3TaKvxZ0ZBJedoZ2Ycc4qFYq7Ok2Xo1seJq4EgRMs10stQfidj5gecQehDWWeA+eXQU3CbQKrzH6oxg9BlJHBX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mL7YjmiN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mL7YjmiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3039FC19422;
	Wed, 21 Jan 2026 18:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019855;
	bh=k4iKiEIc+Qe/DSmn4biLQtcRusLw1Nz8egyH8UGcags=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mL7YjmiNktNqfjww6JxhjtKgDywgrZ0kFUmriMWqjjTgKAq4X35Em8WjyQ5dWxmvX
	 ywhX5H9co0QMK7g7/TnufcmTIMM/TrRUjEUb5bAxvMR8v3EZZexf21zOmUma1ghSo1
	 uYe7ZjG9brp8Myz/BHkYv1nNwXVBx0xDi1oEd/pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	chongjiapeng <jiapeng.chong@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 126/139] mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
Date: Wed, 21 Jan 2026 19:16:14 +0100
Message-ID: <20260121181415.986979513@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit dc7e1d75fd8c505096d0cddeca9e2efb2b55aaf9 upstream.

When a DAMOS-scheme DAMON sysfs directory setup fails after setup of
quotas/ directory, subdirectories of quotas/ directory are not cleaned up.
As a result, DAMON sysfs interface is nearly broken until the system
reboots, and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Link: https://lkml.kernel.org/r/20251225023043.18579-4-sj@kernel.org
Fixes: 1b32234ab087 ("mm/damon/sysfs: support DAMOS watermarks")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: chongjiapeng <jiapeng.chong@linux.alibaba.com>
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1609,7 +1609,7 @@ static int damon_sysfs_scheme_add_dirs(s
 		goto put_access_pattern_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
-		goto put_quotas_access_pattern_out;
+		goto rmdir_put_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_filters(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
@@ -1630,7 +1630,8 @@ put_filters_watermarks_quotas_access_pat
 put_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->watermarks->kobj);
 	scheme->watermarks = NULL;
-put_quotas_access_pattern_out:
+rmdir_put_quotas_access_pattern_out:
+	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
 put_access_pattern_out:


