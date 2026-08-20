Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A6D23403F8;
	Thu, 20 Aug 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247161; cv=none; b=e3/uibJ0Y6P8j/M5k/2QU2LBzski1Mxx6rcxwz8FnxvL9cVQv62Eb7iLI+bKL4UF7J2964ZUib8T80pExvwMaA8khjjLl9fkcuhpo/4UUVQvms7vieEdVWFSOsbagiLK0G2MG3B13LmNkO0SAFViHFug9aFB9heq1WBnY735YoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247161; c=relaxed/simple;
	bh=3POQkiey7HBWZrt5Yzf9KWuQrW9DRTLDyLUzQWkyNPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4k7vXHKm51iX7Ry2sDPyoz8G6QYMqacSkht0hVDlXl8C+BegFC2pIglse3Op0Xamrz2yFbGreXXzuJwVP9rG9QVD2klT/OhYinXN5G8tdV2pFturQ6sidPAxPXq1DJZsxUd5mKftVEFo4w8EYx0SU1M/8wHOuhpaOHypCwvmGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d3vr0dt9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3vr0dt9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 672E31F000E9;
	Thu, 20 Aug 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247159;
	bh=B8gOBrLkp+OEK9l0g8LHNLYYJ2eaiZkJmb8yU5JYjK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3vr0dt9jhzQXvC0gZdiVqIUMix/MGHyuUNoP/RMEe2g8k6MvnDM/591xMN6ANdl4
	 yfuGUMTiYt1Z2BtIlxsmn50toc/P/3Qi9GEOQZgrjEM4PSJBdSi8jMM2PkJWqhxTwh
	 JK34lxQMc4nKfNhhc+l4R/Krghcinku39wUqil9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/220] btrfs: add debug build only WARN
Date: Thu, 20 Aug 2026 16:55:33 +0200
Message-ID: <20260820145227.769844062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 3db15c6ca6feb2c5000a1cbb39c33866e0349abd ]

Add conditional WARN() wrapper that's enabled only in debug build. It
should be used for unexpected conditions that should be noisy.  Use it
instead of ASSERT(0). As it will not lead to BUG() make sure that
continuing is still possible, e.g. the error is handled anyway.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 8bc4d7209611 ("btrfs: zoned: fix missing chunk metadata reservation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/messages.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/btrfs/messages.h
+++ b/fs/btrfs/messages.h
@@ -181,6 +181,13 @@ do {								\
 #define ASSERT(expr)	(void)(expr)
 #endif
 
+#ifdef CONFIG_BTRFS_DEBUG
+/* Verbose warning only under debug build. */
+#define DEBUG_WARN(args...)			WARN(1, KERN_ERR args)
+#else
+#define DEBUG_WARN(...)				do {} while(0)
+#endif
+
 __printf(5, 6)
 __cold
 void __btrfs_handle_fs_error(struct btrfs_fs_info *fs_info, const char *function,


