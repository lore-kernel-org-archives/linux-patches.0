Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4385724A06D;
	Wed, 25 Feb 2026 01:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983810; cv=none; b=thodetyaQGWw996hq6nBOTGZAvAXFm7hc+G+ERTmAi5FvxO1h7D+FCgHDzjYQ2vJ0vEDOOZSrBKtKcNZx3sgZuH4iW0mz4LKb3C8KaL/DeJy+176nilMXOq/lHlCuBLtGMa7IBTg7Wq+f2gFxJClyxxBVSdBXVCnWDcN3RGhcQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983810; c=relaxed/simple;
	bh=EhDeLLXKduXDJX1xD+oN/OrYLrO42miP2gWcnhql5xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7lsYV8tiqNBfEGSa7xHroXYvFJEqIMxtYr1d5awB/OcpE17c+JJGEcpVKQTxP+TAhNSZlN2vEdKNCaTBdPe5wMDVogqQ5ll6LoDA2B/PLYCN/zvglAs7tJ78UADgBzW92yVTztc0edukCkfZZuwCW7g/8NSvRXSiYPvkV05JZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zs50WMT2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zs50WMT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17142C116D0;
	Wed, 25 Feb 2026 01:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983810;
	bh=EhDeLLXKduXDJX1xD+oN/OrYLrO42miP2gWcnhql5xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zs50WMT2L/noAwivE3lvyXcCTNMSgLBtk/VnbvfaOVVe3rGMPiENHUhA3FWIBxBFv
	 mYkvwrZLgQWItqzSHmYOkxRZ9MkvUkgXYCGCvrOmjUAw9olmwnZGdgf2fZwdxAtBA+
	 VHmyE+xDLwyml1ZxdjtayCbZXYc+W0Bpov6mhlVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/641] hrtimer: Fix trace oddity
Date: Tue, 24 Feb 2026 17:16:53 -0800
Message-ID: <20260225012351.202693151@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 5d6446f409da00e5a389125ddb5ce09f5bc404c9 ]

It turns out that __run_hrtimer() will trace like:

          <idle>-0     [032] d.h2. 20705.474563: hrtimer_cancel:       hrtimer=0xff2db8f77f8226e8
          <idle>-0     [032] d.h1. 20705.474563: hrtimer_expire_entry: hrtimer=0xff2db8f77f8226e8 now=20699452001850 function=tick_nohz_handler/0x0

Which is a bit nonsensical, the timer doesn't get canceled on
expiration. The cause is the use of the incorrect debug helper.

Fixes: c6a2a1770245 ("hrtimer: Add tracepoint for hrtimers")
Reported-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260121143208.219595606@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index e618addb58641..21b6d93401480 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1742,7 +1742,7 @@ static void __run_hrtimer(struct hrtimer_cpu_base *cpu_base,
 
 	lockdep_assert_held(&cpu_base->lock);
 
-	debug_deactivate(timer);
+	debug_hrtimer_deactivate(timer);
 	base->running = timer;
 
 	/*
-- 
2.51.0



