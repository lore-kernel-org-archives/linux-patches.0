Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9399D375256
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302567; cv=none; b=lUeiY5B/5hpSKWEdmECgkkce6Q5TPNcWG0FzSE6M18zFV8OkXWmNdmNAOAx2UgiKGmDUezRY6aEOKbqX5ZI9Zi0YEqCz8pLTFqzkhRXZHXuJvOT91wETSTEfYNZl5OOpCCXTaXqWY9U7hvDBv6RkzO0OORhrSWPEjT0h9HQ4LYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302567; c=relaxed/simple;
	bh=DxlyWX6KhSOqzDs+YejTdeKU8xtzitO4B7L5auo51oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdWCHmX7j2wpmcxGwgmgcQE/FHBxA83OPMHSt3fVtf2k5iW/KWN1LgVhnoXAw0IRb2g3Iao+69DsgOk5nEXjcCHhWTR96h5Fh+2MyohZh+u8JdCTzB8z5noYuMP43tOfdAhS7TU3T5BJrGTVXWv1r173XHgsiKCw8Gtvl5seolw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GyNb8Ife; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GyNb8Ife"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613E7C19424;
	Sat, 28 Feb 2026 18:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302567;
	bh=DxlyWX6KhSOqzDs+YejTdeKU8xtzitO4B7L5auo51oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GyNb8IfeXZ+JjaW6U3b+6uaa4y9ujF1Ii7X4LKxV0H8ZQcjCz9kXl2vhPJ3qKTdP2
	 jn6e7eliKdoBiXirYJSviLUrqXQ5H9B4aRCAEGBj9Iqh3NTOIIdq8N7pV9W0ofBhqm
	 kJ7J6QCZ2kTdB3hqlYbcelT4SkR1x8x0qhIZddpw7Fh0OD7CcdKUVyMCsJGaTrkL1Y
	 SZ/BBtolHZDx9teiw5Z/QiaAVgwCrznno9JGZJLEbs2MK50BqubDpeS5zFAz/0jAQf
	 B4RQZGu99sDt4d6K+nVsGd7bj75nb4ghP5XziuAjNuiKRZYxLYQZpK+TDkccPYW6pY
	 EsRx9dsJOPthg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/164] ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()
Date: Sat, 28 Feb 2026 13:13:32 -0500
Message-ID: <20260228181505.1600663-73-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 0895a000e4fff9e950a7894210db45973e485c35 ]

The user.* sysctls implement the ctl_table_root::permissions hook and they
override the file access mode based on the CAP_SYS_RESOURCE capability (at
most rwx if capable, at most r-- if not).  The capability is being checked
unconditionally, so if an LSM denies the capability, an audit record may
be logged even when access is in fact granted.

Given the logic in the set_permissions() function in kernel/ucount.c and
the unfortunate way the permission checking is implemented, it doesn't
seem viable to avoid false positive denials by deferring the capability
check.  Thus, do the same as in net_ctl_permissions() (net/sysctl_net.c) -
switch from ns_capable() to ns_capable_noaudit(), so that the check never
logs an audit record.

Link: https://lkml.kernel.org/r/20260122140745.239428-1-omosnace@redhat.com
Fixes: dbec28460a89 ("userns: Add per user namespace sysctls.")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Reviewed-by: Paul Moore <paul@paul-moore.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/ucount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index 8c21398f7b4fc..cc8ec071d46d3 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -45,7 +45,7 @@ static int set_permissions(struct ctl_table_header *head,
 	int mode;
 
 	/* Allow users with CAP_SYS_RESOURCE unrestrained access */
-	if (ns_capable(user_ns, CAP_SYS_RESOURCE))
+	if (ns_capable_noaudit(user_ns, CAP_SYS_RESOURCE))
 		mode = (table->mode & S_IRWXU) >> 6;
 	else
 	/* Allow all others at most read-only access */
-- 
2.51.0

