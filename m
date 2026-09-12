Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A834752E;
	Sat, 12 Sep 2026 07:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197765; cv=none; b=Xv6th58W2Ax5PybCXe78r+mXXKhez+cMurdiz2PrGf1peLQb6Dway6Ddr6MFXrgS666Uj2pAi+xMoBoUt05i6zBHdruNARWEdx+++z3iMf3YbXx5q/mM9KI3A0PgmgcrToUUGzpOKLDuvbhEyKmfllqVslUmQeOD4iG5C42YJgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197765; c=relaxed/simple;
	bh=+MxihWzwS0B0iXI9uZY+26hVryETKE5ZJSzQ1IXdZNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyMuWlnZ+mvLiPXQXbkDzgi3s/CZymZ6/Jpn5RA9bKNuob7NJdoaoh2x62Dzwf9DWnn5AJiDHnN5yUNwUgCFZwJGGV+kvV8w702KFkFooIAs+bIB380ynrhlqGmTqTVbaWqGtgHFaRG7N3BiquGel9Oyff3rbevaUpCD/oMJHCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBxy4RCj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBxy4RCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CAD1F000FF;
	Sat, 12 Sep 2026 07:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197764;
	bh=vpUU3E2VzUODTBRTxvnADVRQbOgHEdTY8hLItV38B4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBxy4RCjP1ksSbZfsUgdWZBWzFzGcPKW+kpikk8iTN881DnKLK0hqSemVmB1Z/OdK
	 S+psnQQh6n8EPzToyFMjlIRvUMuulUJNpncrpObTdWG7iT5LDSEgUAFg646O+kSdqa
	 c4xoKd0jF70U/Agl2u/VVkXyTVhb9tN/efjNdBoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	William Roberts <bill.c.roberts@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0243/1815] selftests/lsm: Fix memory leak in attr_lsm_count
Date: Sat, 12 Sep 2026 08:33:13 +0200
Message-ID: <20260912065654.693402958@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



