Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C728346773;
	Mon, 20 Apr 2026 16:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701755; cv=none; b=hPwOXVn1AurfE20u4g1awPkty8wOJWN/TdBPvC0bud+1N2HTyvtRdY/xTPhuBYg9UJ1K+5Y/ms9+6g09QmbD+Fy4JK20nwBWZW1h+fWdp1iQsDyzhqKXvSlSr4WUEFAOvl4b2ZkO211w4oa47KZ5phmk5WGEmiLr52NBuyhDLZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701755; c=relaxed/simple;
	bh=GFq1rsh2RNH75D5V1Zu+ABKbLzOXdI3Qku9lsZG1LZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BlIXfiLxuIO6UMWVYEKJBdQadpunZO69NPmxkXx+KhnAVetpags9HLaZ6IU+cqv7db/HUQ/DxpDGofgVY35MVCEpLjJ2lW3ZJA1DV6RJ6RWIwOsSNDGuJwMTwk5sj0iTdbw4Oi2SwHFyJAN7ZxCsxK88je/pcbv47k3laswqmF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NW37ESiH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NW37ESiH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834BCC19425;
	Mon, 20 Apr 2026 16:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701754;
	bh=GFq1rsh2RNH75D5V1Zu+ABKbLzOXdI3Qku9lsZG1LZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NW37ESiH0ApneR+1uNyF+P5g5O2BenhFEIoU8e0wNTIycdQulks1xjKG1selmdO4C
	 84XqLB7vNqKor9xRM06zsWJzRyQXfTrZK7sL6bRfKucK+LSpJihL/eHPUVfs9IgCUt
	 rl51hgmgH7KrchNtyCWo+VfP6/2UWMWcjcjhKBwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <FredTheDude@proton.me>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 6.18 032/198] fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath
Date: Mon, 20 Apr 2026 17:40:11 +0200
Message-ID: <20260420153936.774380475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
index be82acacc41d6..f207c7cef0467 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -589,6 +589,10 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
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



