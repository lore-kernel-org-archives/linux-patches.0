Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1921241A575;
	Sat, 12 Sep 2026 12:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214959; cv=none; b=QB5B9vNCfvODkegzTmrMOEWdPPVYLaKiBFt+FAycEA9t9QXT6gioX+tSATng1m1YXhv0R+E1+Z8VA7IHsAFDO8XIR7VhW346keqoz7habSz7Vf52HUHwvZiM/aCIfX20XRaqE0fBgEEo6iKDcBkDvL/oHT/76D77a37j+qgWTLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214959; c=relaxed/simple;
	bh=yRJ8ZGUc52Y50oTluBoDoF0Nw1baioqYer77pX6nwdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJ6D5HN6KvrfT8uoJ7ihi2I80I4mYZ+juvBokctARqz8CyDKZdct22cHJuUwXfQDaeceyKmO5xENp6eiIZwJMI3jML6NBT439Tptg/drpTgNtml28ZJ04UQVBlYkyCIyjmoBR4zetk0+hZCdHyumyAyCCD4jtma9DwZUa/o/qvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzDvVFXX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzDvVFXX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE101F000FF;
	Sat, 12 Sep 2026 12:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214958;
	bh=1btucHk1PaAf23aSb/0lNQ6zTyT2RJKMgX0UHBl+CbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzDvVFXXFL+cbOOqdMkMCJZ3oFT68w/qE1WRJiDv6cbRfZzITWVBQzMNmLm/Zqe1V
	 sbXhhtah1e2PpThGeoRT90VoWB7w5LZju2b7xxcjT7ryFdiENvQ7lh1AgAuD1HqGRC
	 3k2dOwlJmFEc95zy7B0gUYUsgNWh3x8SaCZw+Kb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yan <wangyan01@kylinos.cn>,
	William Roberts <bill.c.roberts@gmail.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0434/1376] selftests/lsm: Fix memory leak in attr_lsm_count
Date: Sat, 12 Sep 2026 08:47:40 +0200
Message-ID: <20260912065617.207368067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



