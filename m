Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAC41F7558;
	Wed,  6 Nov 2024 12:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897016; cv=none; b=RyZ1mlSP9vObasXOJOj4WlSAt6N4kfgP/duga+rDHNSV27H0zbJesANSnuWlt60b5IyvauPfdMeh0o2+huV2ymd9zgdPKqsHxAC8Wwi3mBG7tn53SFITTAZIgOenDMkheIVIvk6a8F1m3pIgMnRb9if259wMU1gAcKLVjGAAI8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897016; c=relaxed/simple;
	bh=f6nMTBPrv7dR79CX45tG9dmwwZk7XVereCjocqO/y58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=svW0jV+bXXc+6Z5VGv+xC7y08UiGx+PQuPRZ/f3p4XwY9g0l6Et48dXezRkEd9k0l/U5TUcFYME0Sv01d/QEfqRtYxFOUSABfpZMU/uw5k0MENz9eD7OKkrSAWokVS/85LRFevQ00hpv37Wz0I9ir78FDBnbg669qxRfV2nbICo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ew9GboXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ew9GboXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234CCC4CED4;
	Wed,  6 Nov 2024 12:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897016;
	bh=f6nMTBPrv7dR79CX45tG9dmwwZk7XVereCjocqO/y58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ew9GboXNI6og8UDPGcYgl4nG85ZrRH78L+ZTbUliye/k0bcbgCXjtJlBbqamNOz0f
	 U+gAPeEEvSB//Z07lAc91Xu/kzcNtcUHevkpmBvl9prH/ADXR5S/oXD5uU2rtbPm40
	 h1hRsx2mNopa4RJuv6wNjxU6sTDLIrS/Qv/g5m4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/126] cgroup: Fix potential overflow issue when checking max_depth
Date: Wed,  6 Nov 2024 13:03:30 +0100
Message-ID: <20241106120306.322196642@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 3cc4e13bb1617f6a13e5e6882465984148743cf4 ]

cgroup.max.depth is the maximum allowed descent depth below the current
cgroup. If the actual descent depth is equal or larger, an attempt to
create a new child cgroup will fail. However due to the cgroup->max_depth
is of int type and having the default value INT_MAX, the condition
'level > cgroup->max_depth' will never be satisfied, and it will cause
an overflow of the level after it reaches to INT_MAX.

Fix it by starting the level from 0 and using '>=' instead.

It's worth mentioning that this issue is unlikely to occur in reality,
as it's impossible to have a depth of INT_MAX hierarchy, but should be
be avoided logically.

Fixes: 1a926e0bbab8 ("cgroup: implement hierarchy limits")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f6656fd410d0f..2ca4aeb21a440 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5707,7 +5707,7 @@ static bool cgroup_check_hierarchy_limits(struct cgroup *parent)
 {
 	struct cgroup *cgroup;
 	int ret = false;
-	int level = 1;
+	int level = 0;
 
 	lockdep_assert_held(&cgroup_mutex);
 
@@ -5715,7 +5715,7 @@ static bool cgroup_check_hierarchy_limits(struct cgroup *parent)
 		if (cgroup->nr_descendants >= cgroup->max_descendants)
 			goto fail;
 
-		if (level > cgroup->max_depth)
+		if (level >= cgroup->max_depth)
 			goto fail;
 
 		level++;
-- 
2.43.0



