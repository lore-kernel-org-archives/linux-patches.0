Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D24B23536A;
	Mon,  2 Jun 2025 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873365; cv=none; b=IIww+s0PD+XxbGaO6xntbgXkQoAVC2d+x0yDez2Me5dP3+gefSM2uVYNGIiynp515WAK9JR+6EdZyDaBlYmjWMr042IQrMZn8uHzfOqnwbfSp3N8s0Os37Z2y7ZxLRX6XZPN+bvBAR4mCeJm8N90DzG5TfPUSLvNWUxeTyrDP/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873365; c=relaxed/simple;
	bh=QvU3RxRpKx07xbkiypFENFITeO7ERSI4UrsPYEY7pEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQh7OeMUzoIcI9neubI3Vu679AyH9MC0v74OIMwG9x4Dq9kaEkDxT3B7mgxI+XgrOByZuLh3RbaguAFlYbskKMv9X92BEVonL0XlrButGYywVG2076dy55OYtZ+xXwr5WRN4JQ+Gd87aIyFs3jcZOiEPuf7uvN2YPsJiEXib9Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXko0ZFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXko0ZFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72441C4CEF2;
	Mon,  2 Jun 2025 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873365;
	bh=QvU3RxRpKx07xbkiypFENFITeO7ERSI4UrsPYEY7pEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXko0ZFVOEn7NOdpeGxHLrj1GcXLK1S/1W60mse7GiQtmgPQ/EDy7MJaksEufV5Qr
	 m9RimUE4YvBlvi+XZa+VTcNKLkasW95qQ5wl9zfIDWzNeWBUYrsL4x1SX3U7E2mfR6
	 jKGQgZQFAJcoJ5LPxCKQwX33WDpwyVhF8PF/RJ5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/444] printk: Check CON_SUSPEND when unblanking a console
Date: Mon,  2 Jun 2025 15:43:03 +0200
Message-ID: <20250602134345.727204198@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dcdf449615bda..51c43e0f9b29b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3119,7 +3119,12 @@ void console_unblank(void)
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
@@ -3156,7 +3161,12 @@ void console_unblank(void)
 
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



