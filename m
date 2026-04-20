Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5926346781;
	Mon, 20 Apr 2026 16:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701757; cv=none; b=nHBB1D4kK/yTmw9+efOzoSlXd4NQFo1o8wYQidRWpjQKGBX9r3RePcbIGIMI+5sTKKE6ocKujdJquzS/P/5x1fHsug0ir1vyzDIbYg3wpG5Cw5Ouw77TeVc7r61zMvfSEmMmTybRoSK0DB1t3xWjZVunRliej1s5QZN/m23rr+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701757; c=relaxed/simple;
	bh=XGnifYhaxxp5mQkFeCzYkrP155cwJ9LZBUH52ZMJlo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7H7+jEAGLPlw6uR/VQaRAQ9TtpbsH64zTlzUVRW7jWOQ2R3duXyB8yUwKgRZLa9UqDGeFKWV1QTZPrZNJ5AK2h1avne8/PmbhyOQxeRAppviN3MOXoQH24PgGPVIp4bDSTZp87BWt3H87qon8aeBrV6BYJZnCnuX5/o1gYUJOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxQNaExQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxQNaExQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9E2C19425;
	Mon, 20 Apr 2026 16:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701757;
	bh=XGnifYhaxxp5mQkFeCzYkrP155cwJ9LZBUH52ZMJlo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxQNaExQ0wT3EhJPtMYpayZFhlAw0e5UWR6wo1ys6hs5IVVhf+rr9k3ylXLzNoizm
	 vdXb5BHmkyTUCY9fwlYmjRvg1vgKDjRkRvAi5hwFofXDAQ3J8wt6Y/Yh+0xpvxIyAz
	 vMvHep/clChaUyzYef6/1Pnp43l2RzmFuwhf2aek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <FredTheDude@proton.me>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 6.12 022/162] fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath
Date: Mon, 20 Apr 2026 17:40:54 +0200
Message-ID: <20260420153927.823136449@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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
index 39e48e86b9b4f..769380020d41a 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -527,6 +527,10 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
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



