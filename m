Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78F52264A6;
	Sat, 12 Sep 2026 09:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206591; cv=none; b=ohstIsOs33coNbJlJ/VDXBT3Wx47GgQUfK2JFX932lL0vCqGEJM0WY5decItFuHH+iqfTqo8NgPOKU63dJPxEbLOEFQydwN+PJSrYuxEQOfTN215UwnigovDZWKay8MIL6f0GDyasOpW96gN7ZdEKwmEACmXcPaAjLE5oMqwLHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206591; c=relaxed/simple;
	bh=x6Q/U6uOjdSQP7eYvhDNT/AN01/zAre2cTWkEuO2HZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F5Pkq/KjcG5ccd1nianx2mX2ickDn9QYPOImAcEGwgiNS8TPTK5Wnx6n1aRwcVkdu5/PRNmktWTmrT+EC9YD3fWAIScGfeyCiuEUfhKq9U1jiV8CfxHeJ95RC2dIeN1P7EyAEAlTeUzZqCZdnEnJ5o9uKgDf/fYKQbsxDgr+YsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDLRkubV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDLRkubV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90DD1F000FF;
	Sat, 12 Sep 2026 09:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206587;
	bh=4gt5X4/gXV6QqTaJlDqxDXwWU13GrBuZL6NzQ9OCsW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDLRkubVF9nrK9vfPhu5sKfEtlmLrUhM4Mujb8Ly0U1tk/IJCkJD7uRz4chuNjFMY
	 ZH37DHJGXhXT0GeEMUruFeVal2ctOO8NjLAg/mRUpwzFLBQGdt3gO9nkxGRWhjq2sl
	 NoPLY03OdCp/CPUU+D1TiO9m3gWs71wkdgphmYjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	William Roberts <bill.c.roberts@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0239/1518] selftests/lsm: Fix memory leak in attr_lsm_count
Date: Sat, 12 Sep 2026 08:40:08 +0200
Message-ID: <20260912065628.889558519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Wang Yan <wangyan01@kylinos.cn>

[ Upstream commit 0cee720cfd51402cfcb14d96cb326a36c13b823a ]

The calloc-allocated buffer in attr_lsm_count() is never released on
any exit path, including both the normal return path and the early
return when read_sysfs_lsms fails, resulting in a heap memory leak.

Add free() for the buffer on all return branches to fix the leak.

Fixes: d3d929a8b0cd ("LSM: selftests for Linux Security Module syscalls")
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Reviewed-by: William Roberts <bill.c.roberts@gmail.com>
Tested-by: William Roberts <bill.c.roberts@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lsm/common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lsm/common.c b/tools/testing/selftests/lsm/common.c
index 9ad258912646c..927dce4f04cb2 100644
--- a/tools/testing/selftests/lsm/common.c
+++ b/tools/testing/selftests/lsm/common.c
@@ -76,7 +76,7 @@ int attr_lsm_count(void)
 		return 0;
 
 	if (read_sysfs_lsms(names, sysconf(_SC_PAGESIZE)))
-		return 0;
+		goto out;
 
 	if (strstr(names, "selinux"))
 		count++;
@@ -85,5 +85,7 @@ int attr_lsm_count(void)
 	if (strstr(names, "apparmor"))
 		count++;
 
+out:
+	free(names);
 	return count;
 }
-- 
2.53.0



