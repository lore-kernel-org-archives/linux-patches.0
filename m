Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5137313FD94;
	Thu, 11 Apr 2024 10:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831108; cv=none; b=Cy7A+eyd8sbJxaj/2DzaoRY85wt+LYDi8fDDECQI7WV/d0j4N1xDTU4KTvgTX6ZGI+skRkYrYgd4M7WgN0drFgYQhBrxfiTY/yEnwlmzV9f0t7m48umZubx6Mc+StQTDXoQquzp3xdo/CzZZM/feCeMgQZuA572GWeEngfgKbso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831108; c=relaxed/simple;
	bh=vewVte+JXcjnRJ506q8VE2N7M/3fflX/0yPAMw1ugiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lxr5GmxHemy4StXBRy8tfDAyj8MW7Hrc4KSDQxR+BQfAvG3U/uWPasgaxAKPzh7GZYRZ13KnZrluOW+v5TQI1z3rRk1oH4JxPkJ2YX9eHeGV6wX/cmb510fFQIzcUBwPEFMZPHtVFmOEI/cM5350MACmWMkvmE66tKIbTlnyIUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQAWZ3Rc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQAWZ3Rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9284C433F1;
	Thu, 11 Apr 2024 10:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831108;
	bh=vewVte+JXcjnRJ506q8VE2N7M/3fflX/0yPAMw1ugiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQAWZ3RcnlzbQKxRIiBdgpOcSOJ7SfOvtOCuD0vuN8W4NKSzf8GXn8ZCFsuwN4LZZ
	 gmEi730oiGHwoUHZMsmFQQpRu0bh2S9YTBGrlbGeby1WnzwjwwmSipTbEhNzIrx/B0
	 nX50blveigT4sAkF6r7lVaF6yD4KxC6Usc24U04E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Ogness <john.ogness@linutronix.de>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/114] printk: For @suppress_panic_printk check for other CPU in panic
Date: Thu, 11 Apr 2024 11:55:38 +0200
Message-ID: <20240411095417.205690243@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: John Ogness <john.ogness@linutronix.de>

[ Upstream commit 0ab7cdd00491b532591ef065be706301de7e448f ]

Currently @suppress_panic_printk is checked along with
non-matching @panic_cpu and current CPU. This works
because @suppress_panic_printk is only set when
panic_in_progress() is true.

Rather than relying on the @suppress_panic_printk semantics,
use the concise helper function other_cpu_in_progress(). The
helper function exists to avoid open coding such tests.

Signed-off-by: John Ogness <john.ogness@linutronix.de>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Link: https://lore.kernel.org/r/20240207134103.1357162-7-john.ogness@linutronix.de
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/printk/printk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 35d32d66fb114..0fca282c0a254 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2309,8 +2309,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	if (unlikely(suppress_printk))
 		return 0;
 
-	if (unlikely(suppress_panic_printk) &&
-	    atomic_read(&panic_cpu) != raw_smp_processor_id())
+	if (unlikely(suppress_panic_printk) && other_cpu_in_panic())
 		return 0;
 
 	if (level == LOGLEVEL_SCHED) {
-- 
2.43.0



