Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A4D34CFDA;
	Sat, 12 Sep 2026 12:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215322; cv=none; b=qQcR0HX3lRYKct+9hcSn+gfETlFGK5+cSPSfeVUKKESBbdmynYOqX5W7em3X8peRE7vbfoJISMerCf4DHxF8lLyDXGPRtcICv+Wh6R3Dxw12OVOLu8Wz9UkG/UcO55Y1j25VdHIuM3LZLj0uHxXCGbMEU+dcAYh/TFCj1GsCxfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215322; c=relaxed/simple;
	bh=1P1O5YaY4/qCetILBkkr2FB/6HIxeSTlqIecRB0u/Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UtkLjyIoxpIhFl5+uztMgT7JW5qJf4XTCV5KexHcLTJycSV53TAhN5xK+QP2f3OzRhF2kbJ92PSpKjmzm2QkQG8zlWLH2WM5fsezyWI0EYPh3Gcu1HR/ADHvEQrRqLaWe0Tg2DoeWcC3lQyd6kIk6AlgEFpFsM/ZdDM9PmZ6GLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ggl7QtH8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ggl7QtH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0471F000FF;
	Sat, 12 Sep 2026 12:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215318;
	bh=vpy9s+4rGhmBH/WsOp//QnTiRkBlmtVvoVeFNSZkrYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ggl7QtH88YVC5QoUSNG45E8kQ5CXrsYKBcWJc+eT/WIf7rHXod0wGZPLKxXB85l4W
	 jsnDw+LRMC0yqQoYEOJQD77lPELfalNQFseSSMSYO5WKs3nG74cFkg7o0SPcY68vGL
	 3NSrizFLDuhDiNHNn2OXsQjcqAn4o59Ss0X0U8fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0470/1376] printk: Fix possible console use-after-free
Date: Sat, 12 Sep 2026 08:48:16 +0200
Message-ID: <20260912065618.008081904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 464227c82b08d..37f1d4637d90c 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -3160,10 +3160,8 @@ static bool console_flush_one_record(bool do_cond_resched, u64 *next_seq, bool *
 		if (flags & CON_NBCON) {
 			progress = nbcon_legacy_emit_next_record(con, handover, cookie,
 								 !do_cond_resched);
-			printk_seq = nbcon_seq_read(con);
 		} else {
 			progress = console_emit_next_record(con, handover, cookie);
-			printk_seq = con->seq;
 		}
 
 		/*
@@ -3173,6 +3171,15 @@ static bool console_flush_one_record(bool do_cond_resched, u64 *next_seq, bool *
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



