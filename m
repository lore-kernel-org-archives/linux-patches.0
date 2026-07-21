Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AD03D6CD9;
	Tue, 21 Jul 2026 22:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674720; cv=none; b=DQWV/f+9YW4uLa83zPXR3Kf7xwlv9obId0+Cf/l/qkp8z6olK+Z45+oRqqUy/6+1Gfe1Plr9Og/I07kMBQzW0l51yRQbhGMz5NTDO+hAVZLJQUqqcY486ALA/N7PQBTKVdchj4aAJ/T1/4p/7Wl1EaXGH3TOCzqz+t0HFNhfVqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674720; c=relaxed/simple;
	bh=x2nPj2zqr35lYx6PmFA950ORhM3zuQkBfCEnUIyMaWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AEkfLxj553ZimRJPH9/jEhjytmh69ChmDxhAdZzlUD9XKy92OseZQti955ix/kjzif/ZvU+JzSJh/Rd7w08C7vUysF67xkcgoJBcyiTCLsZoJULQPFvEuJJYl4TU0kDv6Zrl5klmqdO5mZeIHGZq8NHdUIgPNPWwQYASxFm0idk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aEM5jW5Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aEM5jW5Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF61F000E9;
	Tue, 21 Jul 2026 22:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674719;
	bh=rXOtGezLs7qex9WS2u6Y/P/+2BEIFFxkn9L/6nE7m3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEM5jW5ZiSnYK51tvNdH5P0HcQJVZWlQIDBTylgXvIt88HbO0WphQDJyI1AfdoZ3L
	 Lqr1xNpPTyYkgbNNbfd7VWxXp0/ilhz3Bv7oZA+ogcpyWcvZBpK+jJfgARsLUw2Fvj
	 3LQ9XqEX7Hlhb1ZqDub4CCC7wChsYLjoxaOyMwnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Zhangjin Wu <falcon@tinylab.org>,
	Willy Tarreau <w@1wt.eu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 648/699] proc: use generic setattr() for /proc/$PID/net
Date: Tue, 21 Jul 2026 17:26:47 +0200
Message-ID: <20260721152410.372853707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 18e66ae67673f2c8df6f02428798b1355691f2a9 ]

All other files in /proc/$PID/ use proc_setattr().

Not using it allows the usage of chmod() on /proc/$PID/net, even on
other processes owned by the same user.
The same would probably also be true for other attributes to be changed.

As this technically represents an ABI change it is not marked for
stable so any unlikely regressions are caught during a full release cycle.

Fixes: e9720acd728a ("[NET]: Make /proc/net a symlink on /proc/self/net (v3)")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/lkml/d0d111ef-edae-4760-83fb-36db84278da1@t-8ch.de/
Fixes: b4844fa0bdb4 ("selftests/nolibc: implement a few tests for various syscalls")
Tested-by: Zhangjin Wu <falcon@tinylab.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Message-Id: <20230624-proc-net-setattr-v1-2-73176812adee@weissschuh.net>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 6255da28d4bb ("proc: protect ptrace_may_access() with exec_update_lock (FD links)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/proc_net.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/proc_net.c
+++ b/fs/proc/proc_net.c
@@ -310,6 +310,7 @@ static int proc_tgid_net_getattr(const s
 const struct inode_operations proc_net_inode_operations = {
 	.lookup		= proc_tgid_net_lookup,
 	.getattr	= proc_tgid_net_getattr,
+	.setattr        = proc_setattr,
 };
 
 static int proc_tgid_net_readdir(struct file *file, struct dir_context *ctx)


