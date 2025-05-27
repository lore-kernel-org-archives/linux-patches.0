Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F673276057;
	Tue, 27 May 2025 16:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364935; cv=none; b=Y85N8tfymLkmW6TEipWgwFY1Qef3sRGpu0aLwShEtVepLFqSdjpCjkrltcYJzCotOfL4tkhLqwKvSwQFFI74+kjqzXwVSOmUcPIcfNz4e74F/8ClUsuUxGx7CCBuTc0yimeoZXcUBU1t4pKiP4KPCwMRKxp6XBKuNTr0ZerKMV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364935; c=relaxed/simple;
	bh=6BzOdGwj8GZ9VZfZKdfEtMZxwSnuBfj6bCI2PBMXE7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QxtHB9ohIvQ1DviZXlrNVTcXId4WPskAkeWxCVrZypaq9Wq0xoopJmVlPRatu9gSuRnGqGcp62+9qEsVvpMslpZA0aDTKDcq1APfchFHO4JJkVHDu1QsVVmgXihqbKMoMFHZoQxKJVO2/hO52Ah4HYC5D51/wGcqTB5cdw0PzFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sr8g9FGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sr8g9FGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF5E7C4CEE9;
	Tue, 27 May 2025 16:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364935;
	bh=6BzOdGwj8GZ9VZfZKdfEtMZxwSnuBfj6bCI2PBMXE7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sr8g9FGMaAko65E4tiWnFpWEOkq6tYhsO0Fdq43/fGQR7llJkpseUHegg+v+nVPk1
	 HG9AlG6A5XebxbcBHoeMIDrl68ZAW2P2zfpGKOuwp5eBP0pekPgt3O0Eps6GAlpFFV
	 7BWSt7lY1QdV4H2M8Dp/HvUDh0YTLKuIC5Scww7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Petr Mladek <pmladek@suse.com>,
	John Ogness <john.ogness@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/626] printk: Check CON_SUSPEND when unblanking a console
Date: Tue, 27 May 2025 18:21:16 +0200
Message-ID: <20250527162452.444908675@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index 881a26e18c658..3a91b739e8f30 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3310,7 +3310,12 @@ void console_unblank(void)
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
@@ -3347,7 +3352,12 @@ void console_unblank(void)
 
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



