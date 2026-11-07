Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063360;
	b=j8MU09eO/T+znUlbp9t4AXw229R0xpZqH1p9H8+Ofb+o8rcjJa+5CC79JAwpRe02o4Cj
	 O7UvA9VQsV4szSE3g2XuT2CEMJLY0f0xErI+VOGyUL7uyt/UygYh4B1ZmuLQjMybjPExh
	 0dZQio3oB1m3l12V6tGeJmrfGjLhSkjzGOXc2c4j+sPSP8rx/wNaGfAj8TPsiNAHi67YG
	 VVTd8VLtHHGZudJr0OeWAPjnOgBm/pkEzJJOGQ5POLshFhQuXez+pnZZCabG5DPyaw5Jj
	 uiWBT5ZN1zLRyChojid2xnl82D9VyfzQLQ2pTMKlFhAYpQuihwemb2T77Jj+rOaPw5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063360;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZbHIAsLhZ7WwnbGyOFhDb/kqSCps787jiAmVKgAu8j4=;
	b=ACF591dX2KlUbihz+Y9sUErhdE48Ak0c5T1Tnd2xez3l46SDKbGMjVq2HG92baWk4UHb
	 S/qy+PwRHbe+SUQPriaXO86tC5Ys7jdeu2e6kMeRBZDIe7EyZ0ztM4Io5QY/Hf/Num98H
	 mg1wPW2YMUDHd2/LxOvUesQ+HSPvCEdlP+QBzPi7RimgNVTiE50/ilU6XFL/fa3W8RMdL
	 w8CUwG2xYVWF3mQYLHjh7HpJj3TXGhmjzigcUYDwYQ5cDDjhWh3xJ7Ac8iUya845OeGLK
	 /jpucSMOdoxBUlGCUz2uHwQuFQf0tMDe98s141rDwKD+86NvzpSS5Cc56qLpL9Bjbng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCt9QDdT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083DE606A330;
	Sat,  7 Nov 2026 14:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DCt9QDdT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12F11F0089F;
	Sat,  7 Nov 2026 14:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063359;
	bh=ZbHIAsLhZ7WwnbGyOFhDb/kqSCps787jiAmVKgAu8j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DCt9QDdTn3eXSQj0qvvZfBbily8WmeMo3YfyQ+XQb3n+khRckg342RZ2MuER/6L0+
	 KqznmB6sbQhjyw/x5XVKW2mPgK+/RZHsva4znnOBDi4DH2Ai8nvf74krt1pblrm/ow
	 6eQ8m0eC5DIia1vUj1Zzxb7PAlxgc6s2sy1qtOU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kazuki Hanai <hnkz.64@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Gabriel Krisman Bertazi <gabriel@krisman.be>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 538/869] tmpfs: fix unicode_map leaks in casefold option handling
Date: Sat,  7 Nov 2026 08:53:40 -0500
Message-ID: <20261107134911.671424446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuki Hanai <hnkz.64@gmail.com>

[ Upstream commit f439d79e8cd19f89e04cbb3b532347edacd72c79 ]

shmem_parse_opt_casefold() stores the unicode_map returned by utf8_load()
in ctx->encoding.  A filesystem context can receive the casefold parameter
more than once, and a second successful parse overwrites the stored map
without releasing it.

The map is also leaked when an unmounted filesystem context is freed.
This includes the temporary context used for remount, because
shmem_reconfigure() does not take ownership of ctx->encoding.

Reject a second casefold setting, clear ctx->encoding after transferring
ownership to the superblock, and release any remaining map from
shmem_free_fc().

An unprivileged user can repeatedly create tmpfs filesystem contexts, set
the casefold parameter, and close them from a user namespace.  This causes
unbounded kernel memory consumption and can result in a local denial of
service.

Link: https://lore.kernel.org/20261002081306.637148-1-hnkz.64@gmail.com
Fixes: 58e55efd6c72 ("tmpfs: Add casefold lookup support")
Signed-off-by: Kazuki Hanai <hnkz.64@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Gabriel Krisman Bertazi <gabriel@krisman.be>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: André Almeida <andrealmeid@igalia.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/shmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index f2b5a11e88a55..68a3a0734e3df 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4595,6 +4595,9 @@ static int shmem_parse_opt_casefold(struct fs_context *fc, struct fs_parameter *
 	struct unicode_map *encoding;
 	char *version_str = param->string + 5;
 
+	if (ctx->encoding)
+		return invalfc(fc, "casefold parameter cannot be specified twice\n");
+
 	if (!latest_version) {
 		if (strncmp(param->string, "utf8-", 5))
 			return invalfc(fc, "Only UTF-8 encodings are supported "
@@ -5081,6 +5084,7 @@ static int shmem_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	if (ctx->encoding) {
 		sb->s_encoding = ctx->encoding;
+		ctx->encoding = NULL;
 		set_default_d_op(sb, &shmem_ci_dentry_ops);
 		if (ctx->strict_encoding)
 			sb->s_encoding_flags = SB_ENC_STRICT_MODE_FL;
@@ -5177,6 +5181,9 @@ static void shmem_free_fc(struct fs_context *fc)
 	struct shmem_options *ctx = fc->fs_private;
 
 	if (ctx) {
+#if IS_ENABLED(CONFIG_UNICODE)
+		utf8_unload(ctx->encoding);
+#endif
 		mpol_put(ctx->mpol);
 		kfree(ctx);
 	}
-- 
2.53.0



