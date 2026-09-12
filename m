Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A5117DFFA;
	Sat, 12 Sep 2026 09:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206862; cv=none; b=sKwUcLvaOekKtKheP69aOarPtpSItxx4xGsrW2fTH3fqOAqn4C8iGHkSWVW5PvRXVMULWt5LZ2CXJ7WeVoGBBPhQHbC4ad1UyZCKtoTC7E5swElYoo4UVB1bzwoVE5cefi9WBkIBNA/AufqyHnk9/1BHYQN8hmiO2bj/AydxKdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206862; c=relaxed/simple;
	bh=KaTjoF4txu+DvqxVnTdZ5KvUdGWULtgScXEhcTRvRRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hruNhGOMTa/v9Sa3QAEKa7PmS0xC+DO0WDqgY17rp0v7pVWrTy0HI4Lahrznv2S+y5hkffmoP7K9AVfut/OP66TLxdr0o+trnYLCwv2lxmnO90XTK/r3PbB2u8NtFXamLwA4XifTQw3iWBIRzTHXl0KIhBz+C1vyjmazA8Y+oHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rv5yrA1m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rv5yrA1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFACA1F000FF;
	Sat, 12 Sep 2026 09:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206861;
	bh=ijZVaIzxJKMRMh25tP74+X4SehpF7+/vmJntJRKgV3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rv5yrA1mbROS2g4nFzpF5+9cLR0j1UbptilbStkMUNjFLKQnc2SJyrLOeNgL9uEmI
	 69t6oeQ0tBbBAKyjY5ZqPuTWo1RLXB7sYi3US0OeGQHid6lxgxzLcNIPQHtmNt0wLd
	 2FDnl5NFmtD8UP7EzEWZLuNTDvljOui25xDF901A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0294/1518] printk: Fix possible console use-after-free
Date: Sat, 12 Sep 2026 08:41:03 +0200
Message-ID: <20260912065630.132590254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 36630cafbeede0b64c370edb2f7b4094327ee1e0 ]

When emitting a record via legacy printing, it is possible that a handover
to another legacy printing context occurs. When a context has performed a
handover, the console SRCU read lock is released and the pointer to the
console struct might now be invalid. Therefore, after calling
nbcon_legacy_emit_next_record() or console_emit_next_record(), it is
necessary to check if a handover occurred _before_ further @con usage.

Sashiko pointed out that console_flush_one_record() was not doing this.

In console_flush_one_record(), after emitting a record, move the further
usage of @con after the handover check.

Fixes: c158834b223f ("printk: nbcon: Use nbcon consoles in console_flush_all()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/lkml/20260630170903.099D61F000E9@smtp.kernel.org
Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://patch.msgid.link/20260703141521.202813-1-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 8f3097664622d..ea9fff8f0da87 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3211,10 +3211,8 @@ static bool console_flush_one_record(bool do_cond_resched, u64 *next_seq, bool *
 		if (flags & CON_NBCON) {
 			progress = nbcon_legacy_emit_next_record(con, handover, cookie,
 								 !do_cond_resched);
-			printk_seq = nbcon_seq_read(con);
 		} else {
 			progress = console_emit_next_record(con, handover, cookie);
-			printk_seq = con->seq;
 		}
 
 		/*
@@ -3224,6 +3222,15 @@ static bool console_flush_one_record(bool do_cond_resched, u64 *next_seq, bool *
 		if (*handover)
 			return false;
 
+		/*
+		 * @con can be used here now that it is certain that this
+		 * context is still holding the SRCU read lock.
+		 */
+		if (flags & CON_NBCON)
+			printk_seq = nbcon_seq_read(con);
+		else
+			printk_seq = con->seq;
+
 		/* Track the next of the highest seq flushed. */
 		if (printk_seq > *next_seq)
 			*next_seq = printk_seq;
-- 
2.53.0



