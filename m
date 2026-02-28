Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5DC359A69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302383; cv=none; b=bVRFABGgjvqGsuj7iUal59DIM1NM024M8iUE1af4r9C85L12S3fqEfRiNSJcc768pZEpMMVd6sdIMVXiX1fHjupsKEUnintgG/hE8JcyhMaa6iNq9nQuFw9iknsGRk1lKNLetcETQqEsVdqefHrYpHXuljmXF8CXm0Cl4xQ0cqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302383; c=relaxed/simple;
	bh=0Z9GDsyWT9Nbk+3V/l0yiuxlnRm0Qe16ms7i6y0y6Uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zx+nI+scj+OBZWHIg5dTDiloRWWvnKSkt6bn9iaUtbbqhW4YVpRqiq7sWslGLsCN5RRjM7nW+rq2pH2Yujhi+oKY5jjx0aBF7OtxKNVlGyR+3nC8eLTkKfMdoLLWv3L16QXWzduuQvwHBnoFrUE8/jvmIXbVaKGYpAhWvd92DMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o7wqytKn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o7wqytKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3CEC116D0;
	Sat, 28 Feb 2026 18:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302383;
	bh=0Z9GDsyWT9Nbk+3V/l0yiuxlnRm0Qe16ms7i6y0y6Uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7wqytKnO95yhWFb6koLMrtyvogneqvYkqGw0A1V442iG38xDNumA9wKPsafv8TCS
	 QN+BsnhEn57ybGCihSJwwNROxUPQlusz8C4xnfQNmU6euRaGqjC/LTghFk6nMZH4n2
	 6O7bfRfxXs66wTW1mCaGquyBMmdxM9AkYvmJ0xnAu0sv+sq+hAKmzpYaDr9IUNxSHA
	 T+BtLk+wn5TusqGbBABYKZFvOt8dUDXmv7mMm4GcdJLN98omsS5a4MfJN+SYi06ZN5
	 Xo/mOTxkSaNotfPocnGRbJr4N9W8o+t1DYyRy2MeYQozvPFR8HspsSu2T9t+PJ2NfI
	 UcEtckLFJmeFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/232] ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()
Date: Sat, 28 Feb 2026 13:09:24 -0500
Message-ID: <20260228181127.1592657-111-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 8afa2878422d5..7f29cc9728189 100644
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

