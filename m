Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944A3286D56;
	Sat, 30 May 2026 20:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780171299; cv=none; b=UzWBv+T76/Hkg9zq38KI2KUk5K4HBVE1cLIi3zUaRfeY7Zwo8IImh1es9GYYYjbArJCF/JXol2dmJBuijU/4kKSu7qWMXR0egE5B243Ww3S6Jd102ru2k/4znBdymdKcaWQKUN+CwciOl+bmcd8hyfctBOyz5tkWJBUlDfuI2hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780171299; c=relaxed/simple;
	bh=dNXWmVDZE7TIHn3Kldykv9FY5vwtGO/nYw306FjS4vI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jD0cst3GUE/oQimwjb8ubZCUwo1gFDAagp4hKvGtsWRybbdEoJlz/MRmJBvF3fWpJhkQGhBEOx4EcpcP2SKtCXKUnzqmdbJO1kdl3MCPXMVfpJ72ge8Fqvfeu4lctSg48Q9kxJ2ZXuLdyKT5O4TG5pbixLMUj/t/89KzYgZ4pes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tUtz4mxy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tUtz4mxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4691F00893;
	Sat, 30 May 2026 20:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780171298;
	bh=sVK6vbmQ177D+us09e8NUIbuX4svyI/zUiMovqklpuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tUtz4mxyvxHGFqeHig8YeraraVoHzWPc9BkRpSEQIHc9Q+0K8NUIec9uaQT6uL7Cy
	 AIobDlulUDqQCtI5NkoYJre31L9LtifrVsnmZgA1/jJoXDy36H5YjerYD3aKM4ciFX
	 VwQilmkCK3DePXIfw0yahURBRz5n3uoXfR9RLESU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <FredTheDude@proton.me>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 6.1 015/969] fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath
Date: Sat, 30 May 2026 17:52:19 +0200
Message-ID: <20260530160300.890067812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredric Cover <FredTheDude@proton.me>

[ Upstream commit 78ec5bf2f589ec7fd8f169394bfeca541b077317 ]

When cifs_sanitize_prepath is called with an empty string or a string
containing only delimiters (e.g., "/"), the current logic attempts to
check *(cursor2 - 1) before cursor2 has advanced. This results in an
out-of-bounds read.

This patch adds an early exit check after stripping prepended
delimiters. If no path content remains, the function returns NULL.

The bug was identified via manual audit and verified using a
standalone test case compiled with AddressSanitizer, which
triggered a SEGV on affected inputs.

Signed-off-by: Fredric Cover <FredTheDude@proton.me>
Reviewed-by: Henrique Carvalho <[2]henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 9000299e98cb4..35f2c94aafd14 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -454,6 +454,10 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
 	while (IS_DELIM(*cursor1))
 		cursor1++;
 
+	/* exit in case of only delimiters */
+	if (!*cursor1)
+		return NULL;
+
 	/* copy the first letter */
 	*cursor2 = *cursor1;
 
-- 
2.53.0



