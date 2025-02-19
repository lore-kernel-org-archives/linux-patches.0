Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5AD61DE88C;
	Wed, 19 Feb 2025 08:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954965; cv=none; b=GQ6GmSDNpnDNBS9lT+q4b4h8Uwi93I7vqHs+WotqHVVY8KrCAn74tyh0kQuqRjBcyTN4vRObFc7KXK+n4+VtQWsmdFh7AfmkBkFcS7Nga2gtcwkArzs0vdJPUrj/MwsOK+HYzLs3kaYgJy2ADYwHZwuQLNcnSflBWxGWFLNlRu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954965; c=relaxed/simple;
	bh=Qu2zKuMnGh37Rsi8p9v2DRfntPBkJOVQGH45yaVaXPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyMRp/p1sn6qOqFJmFGOBTo94/whSi46/n+md/00wgWu3O/4aaDrhxwUVXEIwGMW0exSEIC2lsGmriLxeCX517u2iJUMZuV2+gBJevb9/UHnAP3W1Y/r2P+ExLBChFMyz/aW608VCGmQgN40prQaTEUNZUMdUZ1igE/Le74a8HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AD4GfBo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AD4GfBo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7C4C4CED1;
	Wed, 19 Feb 2025 08:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954965;
	bh=Qu2zKuMnGh37Rsi8p9v2DRfntPBkJOVQGH45yaVaXPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AD4GfBo6G4tSuO06ETievwB/ubGCnutkdP7W1c4QrN9v1NjY+HN8NFc3EjuPjdoV3
	 JrZgZeKURoOdcqcXuDDmZsKgiYAk8h34AIPnHv7j5DWdvoQws0J38VW0FvVE2FBsyE
	 Sbp+P7CjABSdtKT/zja3LAYqseF/O6FN7pnIOOyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>,
	syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/230] orangefs: fix a oob in orangefs_debug_write
Date: Wed, 19 Feb 2025 09:26:47 +0100
Message-ID: <20250219082605.220085229@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mike Marshall <hubcap@omnibond.com>

[ Upstream commit f7c848431632598ff9bce57a659db6af60d75b39 ]

I got a syzbot report: slab-out-of-bounds Read in
orangefs_debug_write... several people suggested fixes,
I tested Al Viro's suggestion and made this patch.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Reported-by: syzbot+fc519d7875f2d9186c1f@syzkaller.appspotmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index 1b508f5433846..fa41db0884880 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -393,9 +393,9 @@ static ssize_t orangefs_debug_write(struct file *file,
 	 * Thwart users who try to jamb a ridiculous number
 	 * of bytes into the debug file...
 	 */
-	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN + 1) {
+	if (count > ORANGEFS_MAX_DEBUG_STRING_LEN) {
 		silly = count;
-		count = ORANGEFS_MAX_DEBUG_STRING_LEN + 1;
+		count = ORANGEFS_MAX_DEBUG_STRING_LEN;
 	}
 
 	buf = kzalloc(ORANGEFS_MAX_DEBUG_STRING_LEN, GFP_KERNEL);
-- 
2.39.5



