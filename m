Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2059288C81;
	Sat, 30 May 2026 20:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780171308; cv=none; b=L8iPDWTwPDZNbee2kI5K+TxFNekCK65uqoskz2CS2F2lh46us5PZKLKvCQzltt7zSZEnzkl0URYBrFNinVWBScYsh3Qmxsof5+z7jfUj/eBNUaTH7pORVePNKeO9YXlFXSR1dNL/g/1sQ7RYLBlhLHBq581AUWhRvK/J+Z0QqoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780171308; c=relaxed/simple;
	bh=dQ/SwkErJuAhiVfbeY3wBkrg55WKLm/tvfDpbBQB9FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUAY8Q+51AhCPQARQbbqHqO41RPmsXGpfWbrF4zHa+RqYFDnbAUoa3B5f0dyrOCQfVR4AHMy+NICt+7uo25GgGbfYQ+iFlJyngiY0JaDq22H0Tx9BhRu3buvUb3v07Odv5Ua9KxsYoYRqJCBVnKsB4zC+2+yeUGXYg6RcyDUWTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jwv+1zLm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jwv+1zLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6A41F00898;
	Sat, 30 May 2026 20:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780171304;
	bh=Rwodttwjn6WrTysx1Bayx+y2MrfT/Ad2VgcoE3dAWW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jwv+1zLmC+AJ/18kYVzKlWqvfaxKJmgPUXJRrLTxefxKgqBQgqQKcCM5dtv1vYldE
	 Hqv3hgbs8tw6ou2MHL4gNfumyYnUEAmQwSTl5gZN4lzLnuQmIKxxUZM4rEx3j31GAT
	 N6H30gptf1EEfbgJEw2xNv4q1dy3NRxnMaXYRcDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredric Cover <FredTheDude@proton.me>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 5.15 010/776] fs/smb/client: fix out-of-bounds read in cifs_sanitize_prepath
Date: Sat, 30 May 2026 17:55:24 +0200
Message-ID: <20260530160240.519681832@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/cifs/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index c3a71c69d3395..0336580062067 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -450,6 +450,10 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
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



