Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6413B2C0F97;
	Wed, 25 Feb 2026 06:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002552; cv=none; b=Eb/qJ8cCCG+Ni08UYkCnLMvHniNd26QeLP3s9xMwKhnN1Xet2HBVQlwZhbL1aXJ+dIRGtOI7YG643DiJfN1sNypWhMj6Y9tSFITvrybEMXeVMHG7gRuesNAtdDmllA8f0hefa6RZjd186GU3GQoXp/hFF8uMlQLIXzqpSN4XksM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002552; c=relaxed/simple;
	bh=FiI+WTgUnyXhQyUHAhTmC+yPhchBmGBXOfaHfZdm+co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3VRJ8AY1sgbhy2n2Btfvsvxb2gLbEGga9F+fIGlUXK5mraLmJhF22VOwK2MrHJLQXblrFWqJzPX2VgaA9HrQzjStPF8soa+vj8gUGwQcRcrLSKk5+POuLC+y+VKVcLemZ4wjKWV9FydHLcIzuRgRDBDMtQJMtSVEWIW7gm/lkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eAwJRt9Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eAwJRt9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE70DC116D0;
	Wed, 25 Feb 2026 06:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002552;
	bh=FiI+WTgUnyXhQyUHAhTmC+yPhchBmGBXOfaHfZdm+co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eAwJRt9YSncoiEI1QF9gmIL5YMVSAryNJP40aLA+NFMDyi+XSJ7okLf6CVCydFEtT
	 cyWfDA5El+5ZEwMwU12tA+qZAqOoQ3PJJQ0jUFrjyDUgZ6mC3pGSHzd8MXpL2mklTK
	 Oaf/Cyk0jpZPBcOiL9LOIWgry6jZFq0EHo/PbnWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/641] ucount: check for CAP_SYS_RESOURCE using ns_capable_noaudit()
Date: Tue, 24 Feb 2026 17:20:18 -0800
Message-ID: <20260225012355.830815388@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 586af49fc03e4..fc4a8f2d30965 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -47,7 +47,7 @@ static int set_permissions(struct ctl_table_header *head,
 	int mode;
 
 	/* Allow users with CAP_SYS_RESOURCE unrestrained access */
-	if (ns_capable(user_ns, CAP_SYS_RESOURCE))
+	if (ns_capable_noaudit(user_ns, CAP_SYS_RESOURCE))
 		mode = (table->mode & S_IRWXU) >> 6;
 	else
 	/* Allow all others at most read-only access */
-- 
2.51.0



