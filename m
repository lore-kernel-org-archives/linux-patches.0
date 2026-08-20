Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D9E3803D7;
	Thu, 20 Aug 2026 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247585; cv=none; b=Wgx+GuUxM6tnog9H9QC8+CTQCikk+NUNqhEO6D4CC1CWmCU2MPBDFB1ktF8gNNia3rl0XQ9SbQex8qQo+JG63d5HoeTXT/3dC6RA59aBOHGJkJpIODOB3Lt7AgvdCCrSebR89gg2OoC2QTN+BT5eaJBhTLOoiOPFvVfwhFQ2QF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247585; c=relaxed/simple;
	bh=gBqfcmUVcWomqcpKg8IKeuUgc/DY2hwEy7urYg66L+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sS7BWwqHjSjKaHqGX1kPz2aefqnT65HVQ48NcMaHJ1wep1usgSxOMOU64mecMa4/hcRzlGJc00vp7HwndpktWMo21jhKBWkv+4gLSUUMzo54SddBNAx75+Vx3hDtaxKKhncwEbInvurqybFp0Uoor17NrFrT3nCA78b77Ptsf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+GZUC+4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+GZUC+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC441F000E9;
	Thu, 20 Aug 2026 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247584;
	bh=g9vyEJcLeY7hVzlap9P+DWmPaFUk4auRUacWmS5wWVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M+GZUC+4efNIy3HfdT3QuGi3wcc+mG+Hkv4j+Ut7ZMldu1KtWuwZJUVmZK6xzyA/o
	 DHL1jIgGjjmIXuS7M8y0sc09tVVJGI9cKO/QPwrBq3i6XpmP//5iJiEUSF5+X3m6Cy
	 oQAj/IblIBlVekzw4bLennBFqG2TjIR9FhqCUnVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/166] btrfs: add debug build only WARN
Date: Thu, 20 Aug 2026 16:55:56 +0200
Message-ID: <20260820145214.078473043@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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


