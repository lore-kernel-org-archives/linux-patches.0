Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184C3438FEE;
	Tue, 21 Jul 2026 21:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670644; cv=none; b=h6efz4d2WGPjPG5wXNsEwwoxGeTwGqHMkppwXig16/kAD5643valcrxcaHN81KpgAygJmIJ8uXPjSQRyepmOL1DweeDO4JbBd9dolSBWrFaJWpLP+RCw6SRMsQXk8wfIMYJU7e6UdD+JLw2hbuqS/XaVZKuV5+x3mHx9sAhkO5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670644; c=relaxed/simple;
	bh=gU4IsAv6hIPlwktiQQnpRiXJPNb3VuW4BOphltum1BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SillIbYZ9xLvVpQaRwiKzBKahqFWsDR1h8SWaJKGjQ+rtzEAnlJm54IW06OX+aU5WwLOPudz9ztjlqMAVdUIBtYmxdd8XsMWKDn82o8qZBHNbKNb4HmgR4K1Yo8R7M/FefRTdGuv7Qf86nzEMVNq8bDSQAgSA/i469wp+d5TE5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWGpnyPU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWGpnyPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2253E1F000E9;
	Tue, 21 Jul 2026 21:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670642;
	bh=Fl7kFi6cmzzQ3TXkP41qJNHx6oO3i1YBqKS82GkE1I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWGpnyPU8owEf54hZcEzeSW2HWnaVnypGY1eF6/GeayFCK/FHEW4aBJUOZkdV8WZA
	 gh65PbyKCtkIf/afj2Q/gQhd4LuKb1KjHxJYnjNoklNj9fP/VSugJ1bMrqx79NUUep
	 zOtqlQtBwy44pH0rDKUxD7lIjgT3NxyBW1SYhhGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Zhangjin Wu <falcon@tinylab.org>,
	Willy Tarreau <w@1wt.eu>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1009/1067] proc: use generic setattr() for /proc/$PID/net
Date: Tue, 21 Jul 2026 17:26:50 +0200
Message-ID: <20260721152447.142399908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -321,6 +321,7 @@ static int proc_tgid_net_getattr(struct
 const struct inode_operations proc_net_inode_operations = {
 	.lookup		= proc_tgid_net_lookup,
 	.getattr	= proc_tgid_net_getattr,
+	.setattr        = proc_setattr,
 };
 
 static int proc_tgid_net_readdir(struct file *file, struct dir_context *ctx)


