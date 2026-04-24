Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8901F3BC666;
	Fri, 24 Apr 2026 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777039371; cv=none; b=uhBbNW/vSWnBI+WUAEQh16ZaRxcl48e7B995f1CV+GZILtcr+M1b4ntBBqIbMB6TWqtHlpPe/8q/14I5vHNGIk4KBwZOJlF+MGJeHGSZadwzpoI1EW28WJHarYU5Rtjf1eik52y8t+MXncQScXqwxIfk4q3qM5M7XMo5SJ+JYvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777039371; c=relaxed/simple;
	bh=AZgqWvJ/PBJknyH4beDmM8e087fPLZQLlCoSI1O7Ga8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6eXI4HwFiqZn9aEeGsrCOU8hPXtJzWSXDyBO/MJsilayk1ZjAwtsDGWC+XNhPtz6tjLvALwVnqgnrSt1m+0gv6PYrVJkEBid07fYjZQMpotYHYVwXERhkgNnwi4eAnfl2v7YqNUGlZM4GBYYN/6OtLdx7EMsp+hpLWcIMiJn5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0kHzDJz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0kHzDJz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078B4C19425;
	Fri, 24 Apr 2026 14:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777039371;
	bh=AZgqWvJ/PBJknyH4beDmM8e087fPLZQLlCoSI1O7Ga8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0kHzDJzK2S2iWovMlJrJ+xi5g4rW5hfpssbM2hj93q+aUHFQvYPsV7SMhuWGYMWb
	 neB0hVkgCqO8vqERQUSYmqQZoOrqMz+zH9A0s2tytPwpY5x6xPRDXu5Rgt4ahpfVxR
	 HPAafw5ppbqjuhefTkGYiK9BhHZ0LYSEPXUjvV/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <FredTheDude@proton.me>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 6.6 017/166] fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath
Date: Fri, 24 Apr 2026 15:28:51 +0200
Message-ID: <20260424132536.424518859@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 930f9c17a8d6d..0812af0014173 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -495,6 +495,10 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
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



