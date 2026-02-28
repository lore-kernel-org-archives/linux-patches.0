Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FBF35AC3F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302715; cv=none; b=ghOJe4MasHJytgF8eFyuOLEjRn3obTGiKpD7WvtZcFCAarBK3AyZteFK5NIyk/B04VxBcpETNLs89ZyN2xq4oAHRXJxNEt8XTarWZb0bqw9x+0DCzE315qwBlSC1O59PoRKrqgSQ2imnqBB0KrBKtluaqWTUo7kMGQ87qIPZQ6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302715; c=relaxed/simple;
	bh=fnz7zCRb3FA5Di4VBYqDxGClqXlnd4cExrf1q5mbflI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txYpNh4ecz9e2NGdYlkJFfVGzsb/Fpr1XR1WRLqhcPyxnWp8c6GdkuMLuykNh/qKNrb2xh+ilyVgqfmQYxSYZsw33BJrMne3OcHiIRM8+TEeg6nZatAscb6bbboZ/5/fz5x7DfbaGqDdehuMaEKp7osfPW7uvTPRCFEhefAgjtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EA9MvVBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EA9MvVBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54553C116D0;
	Sat, 28 Feb 2026 18:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302715;
	bh=fnz7zCRb3FA5Di4VBYqDxGClqXlnd4cExrf1q5mbflI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EA9MvVBM0EoHPuyOZfUc/+Qevm7WaO+LTg4dqixt0S+LpofmhGAu6x1S4QZCzFijO
	 y3XC7ji/ZGc05EGFVXRNb123+dDoDDrVthOp2yT/D0mJDuejYxNWbug1bXXZ1/l5VX
	 qvB8nquTa8xYTyrIh7nt/1w11S+a/R4GK3w1HxgGo/uqhlEw4lbMdFn10bq+caOxc5
	 M2wjxZrFeGZZWHXiGXlQZ9HatxG3D3Yk9GQyObuBT0cWMs5bdrIxJ2CPT78DgeW6mH
	 3bOHj+DMw+nmpiaFod/EnlGrhYSNgRfTwGm+r4cF3s5DMQRYtz6i+E8kZ32NKG3SoE
	 Hj7aXc5ExUH5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/147] ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()
Date: Sat, 28 Feb 2026 13:16:22 -0500
Message-ID: <20260228181736.1605592-74-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 8d8874f1c35e2..a1e900aa1fe4a 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -39,7 +39,7 @@ static int set_permissions(struct ctl_table_header *head,
 	int mode;
 
 	/* Allow users with CAP_SYS_RESOURCE unrestrained access */
-	if (ns_capable(user_ns, CAP_SYS_RESOURCE))
+	if (ns_capable_noaudit(user_ns, CAP_SYS_RESOURCE))
 		mode = (table->mode & S_IRWXU) >> 6;
 	else
 	/* Allow all others at most read-only access */
-- 
2.51.0

