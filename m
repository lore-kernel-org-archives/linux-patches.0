Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDE427FD4C;
	Tue, 27 May 2025 17:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366929; cv=none; b=VA/PbQNfTQrnFsa+YdNNM2AwaJzm8qCOMHIpLgdjIJTTNbt/w2ELrn7jraBNHdOHX/RYIO0w1aqNUh1yE7LdftbIjGnR7j/n3DuLBaWErXQcIhRBA6k0hsgyvgBoPXhA5lZ1LEmoD5hEzwvfN+gcxcV21wMKynUAZ5u0E/17nzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366929; c=relaxed/simple;
	bh=ct9VdcN5Tm2xgp1OJGudG3hgML3+hN5L2VC2tuLQ1os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHPnMhuQbHmGXvb6KAsutTNzMZDSU00nDx7o3a4S4aa7DNUfuxbZKtDZa9ygNK90cA4f7xaepkFwWGc64lXgTWa32K00EkqylqEEkN4KLlxzSq6xg9NNhR1k9JjD8k5OXKW+lm4uy4CrWaPbhilUrPKAq7+aYsXUY3aHUKdxdZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uv02+nqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uv02+nqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B835FC4CEE9;
	Tue, 27 May 2025 17:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366929;
	bh=ct9VdcN5Tm2xgp1OJGudG3hgML3+hN5L2VC2tuLQ1os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uv02+nqh9FoOImGzl7Ld+NMuzxvInytjCBfSc/y7xsaB7YWN4lXy1BkQlvcSo5ZhN
	 YUzMoem7TR+XIGAQdqHFwX+o/8FphKZyPnPZOWHlBwFo4UG74JKo/vDhNtVmmH8C5c
	 5d9mpumKzeXdiCEx/rh6eaus+tvqCWbi0tYNuvrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 215/783] printk: Check CON_SUSPEND when unblanking a console
Date: Tue, 27 May 2025 18:20:12 +0200
Message-ID: <20250527162521.885490130@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcos Paulo de Souza <mpdesouza@suse.com>

[ Upstream commit 72c96a2dacc0fb056d13a5f02b0845c4c910fe54 ]

The commit 9e70a5e109a4 ("printk: Add per-console suspended state")
introduced the CON_SUSPENDED flag for consoles. The suspended consoles
will stop receiving messages, so don't unblank suspended consoles
because it won't be showing anything either way.

Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20250226-printk-renaming-v1-5-0b878577f2e6@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 057db78876cd9..13d4210d8862f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3340,7 +3340,12 @@ void console_unblank(void)
 	 */
 	cookie = console_srcu_read_lock();
 	for_each_console_srcu(c) {
-		if ((console_srcu_read_flags(c) & CON_ENABLED) && c->unblank) {
+		short flags = console_srcu_read_flags(c);
+
+		if (flags & CON_SUSPENDED)
+			continue;
+
+		if ((flags & CON_ENABLED) && c->unblank) {
 			found_unblank = true;
 			break;
 		}
@@ -3377,7 +3382,12 @@ void console_unblank(void)
 
 	cookie = console_srcu_read_lock();
 	for_each_console_srcu(c) {
-		if ((console_srcu_read_flags(c) & CON_ENABLED) && c->unblank)
+		short flags = console_srcu_read_flags(c);
+
+		if (flags & CON_SUSPENDED)
+			continue;
+
+		if ((flags & CON_ENABLED) && c->unblank)
 			c->unblank();
 	}
 	console_srcu_read_unlock(cookie);
-- 
2.39.5



