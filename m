Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8149C33FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300908; cv=none; b=mwdls76r8SNJpR9ngm2t6EpD1WvjkA8quIEazjZlg+wEqGbX2KSbd7RIV0HSHZ1utibDgcyn+8vg5aw5hVYTfu6AMUyKGk5PzItya8aycV3IQnXdrXQ0mD8lS7StAal4cMp7K2ZddC6ketx8A3gOtwxnMHT2UOHJ1ukLRZHBdgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300908; c=relaxed/simple;
	bh=LkUHDpljvu8fcDtvyAJKn3DwFMy2wkQcc3SEqAiH7BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o86DHFiA6hQM1Rrod2YPIcd3T4swNIexrVsE5Q7quTgiezeqZjg2XBiyqxewQSsJhZa9wkSJiFJqyRKtDbJuAyCZdIHF06akCMTu0Bhrtdo0WzThkX8i0Q2Sy4vORndCwk+K52j7WTmVmq+OUSEgpj0p0TKpBp4azaAnnVccQD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQJf7niY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQJf7niY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA7EC19423;
	Sat, 28 Feb 2026 17:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300908;
	bh=LkUHDpljvu8fcDtvyAJKn3DwFMy2wkQcc3SEqAiH7BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uQJf7niYSihHR4TT4bT3FpGX1Lt9yfs2xQAxZcH7PyvuTIvqbIvQvfJBplNH7KBou
	 J1otOtOiB/9gfI94KpeFjrlHtbUEYoZBXtAAMUj9wSYkkRAZHSGic/OhMYxcioOUxU
	 OeFZB7BNmZ8d03ztfqKQvNzoPW1cJ2r9hCzc+7xLDjv6pdKfRMHuZIGHSfJ2sFOb1t
	 /HbFiuyQBuuaYUuEV5f4WuuPH66aLFXp9RTAiAm7OdDf16hEL5KrFt+eCPoDMtaMY7
	 GJqdmw6eJSkeB9ERsnHFnDvQfLNSH1OPsBnsMCp8HbEX/M70jWbHNFxjoTz4oDqbpG
	 F8/JIMPn3M4sA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bhavik Sachdev <b.sachdev1904@gmail.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/752] statmount: permission check should return EPERM
Date: Sat, 28 Feb 2026 12:35:33 -0500
Message-ID: <20260228174750.1542406-22-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bhavik Sachdev <b.sachdev1904@gmail.com>

[ Upstream commit fccbe38a5d06dbe44bcd89196fe1d2c2272a1f4a ]

Currently, statmount() returns ENOENT when caller is not CAP_SYS_ADMIN
in the user namespace owner of target mount namespace. This should be
EPERM instead.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Bhavik Sachdev <b.sachdev1904@gmail.com>
Link: https://patch.msgid.link/20251129091455.757724-2-b.sachdev1904@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4272349650b14..5b31682db450e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5796,7 +5796,7 @@ SYSCALL_DEFINE4(statmount, const struct mnt_id_req __user *, req,
 
 	if (kreq.mnt_ns_id && (ns != current->nsproxy->mnt_ns) &&
 	    !ns_capable_noaudit(ns->user_ns, CAP_SYS_ADMIN))
-		return -ENOENT;
+		return -EPERM;
 
 	ks = kmalloc(sizeof(*ks), GFP_KERNEL_ACCOUNT);
 	if (!ks)
-- 
2.51.0

