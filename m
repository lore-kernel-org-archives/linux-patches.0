Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016AA248F64;
	Fri,  4 Sep 2026 06:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501833; cv=none; b=bJoi8dqtH3G+dKsEypsyZ0yxFjacGxCZ6iit8v8x4C5Q5Whv9yIisleq2DtLwuiECAT4T4+wOEKLibh7teqGSV4uDTIJg2Pbi6aTQBR+6vC5f9p/rBTa9jL7nZfssAJt2m95Uq3gsuxhMHHhVU4K9nRbwQTy5hMmZ8sbHAp5gi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501833; c=relaxed/simple;
	bh=6+0AMjjg7U0TneWox3sedy3OnpdwMGO9ROqg6GgCLpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jonSXp0bunE3GAfOEnJa9pwmwG9xiK7C3IFWaTG1ulVBUC8DWuBytjawDisILUtNsifGHljFEn2foQy39zdsKx0/vnd32oi/V9wzCqtA+0PugR35cp/zjtp/Ci39OpqWYKMyqV2gsJhstTEM8vDFgQhRLOGGVFjGUxf4tT3qISg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POLecDiC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POLecDiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD451F00A3D;
	Fri,  4 Sep 2026 06:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501831;
	bh=RL6qu8nIl9qhYZHk7dHxu2S4QGHscuA82aPCAqQTvBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POLecDiCxrDH0EptNzpCwsQmGLkcKzbleamrFr5sFSZ2eBQrMEJEjAlrlW7QX5z6r
	 s5zKIoh2iX5rAUVq5jWVb4riD8lG9Pntx/kvibS2ST3kyZPG2NZJaAsbF1QRzrlOcF
	 sjzqMM8KnkEJLB/IpvlFO9ROUxbWzlWnKChyG54U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 549/552] timer: Keep debugobjects state consistent in migrate_timer_list()
Date: Fri,  4 Sep 2026 07:01:46 +0200
Message-ID: <20260904045803.044858649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Thomas Gleixner <tglx@kernel.org>

commit c793bbfc4a0a9f5a66978fc91559e9681748dbeb upstream.

When timers are migrated away from an offline CPU the debugobjects state
gets corrupted. The timer is accounted as inactive on deletion, but the
enqueue on the alive CPU lacks the activation call.

That used to work, but got broken when the trace point and the debug
objects call got separated. That change missed to fixup
migrate_timer_list().

Add the missing debug_timer_activate() invocation to fix it.

Fixes: dc1e7dc5ac62 ("timer: Move trace point to get proper index")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/87bjb0l7ha.ffs@fw13
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -2491,6 +2491,7 @@ static void migrate_timer_list(struct ti
 		timer = hlist_entry(head->first, struct timer_list, entry);
 		detach_timer(timer, false);
 		timer->flags = (timer->flags & ~TIMER_BASEMASK) | cpu;
+		debug_timer_activate(timer);
 		internal_add_timer(new_base, timer);
 	}
 }


