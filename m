Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9491494B8;
	Mon, 12 Aug 2024 16:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480480; cv=none; b=o0+LMTetLkGKe4QlBLeoV3cb4GH2V6gxx+hGhzhNlzMzB210iajPYuZtQ9VLcR0USYaEU7/3HppicZDcfDqwxbW6VMMDtXyXaVbWuZq3sK6moxgZpzj3D7ktg/0a+Rspie4jpdyd8jRd/7zYVzCN4F8/gWHKxzmE+CedDq1bPY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480480; c=relaxed/simple;
	bh=WTgMTUymh3upxdbBQZV+KBc8PYbDkj4xu97Bfb3PakA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2bCiSLNAS8dFLUus5E3BAOVNdlEKJBK74txF62a7mMsmEsshWtnCIOWepoKJH5dlbU+NPpl8plHbto4WNzwiob881UZhnv5r9ay4buNVVxtSIoCgAm5iIiOpRI9t6DIRQlHptuD1sHjEyRALHPf7fk+A22/LCC4SqkJqQ+XsQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4ciFmy9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4ciFmy9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758C1C32782;
	Mon, 12 Aug 2024 16:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480479;
	bh=WTgMTUymh3upxdbBQZV+KBc8PYbDkj4xu97Bfb3PakA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4ciFmy9hsBwmExz8GaQtrPKdf7RBlncaeApUzj1Lwvjdya2u7Pd9zWoa7dig+WTr
	 DXZtb/1xmSKRZ/P6HOOVLf0oOhXm166NYrzrc8QYfBSactzq/oAfQgHgYaM/S96u65
	 1krEV8eU5kxkQGhRfXKGGRwf7NjTEDv9VWtunSFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.10 208/263] timekeeping: Fix bogus clock_was_set() invocation in do_adjtimex()
Date: Mon, 12 Aug 2024 18:03:29 +0200
Message-ID: <20240812160154.510303023@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 5916be8a53de6401871bdd953f6c60237b47d6d3 upstream.

The addition of the bases argument to clock_was_set() fixed up all call
sites correctly except for do_adjtimex(). This uses CLOCK_REALTIME
instead of CLOCK_SET_WALL as argument. CLOCK_REALTIME is 0.

As a result the effect of that clock_was_set() notification is incomplete
and might result in timers expiring late because the hrtimer code does
not re-evaluate the affected clock bases.

Use CLOCK_SET_WALL instead of CLOCK_REALTIME to tell the hrtimers code
which clock bases need to be re-evaluated.

Fixes: 17a1b8826b45 ("hrtimer: Add bases argument to clock_was_set()")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/877ccx7igo.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -2479,7 +2479,7 @@ int do_adjtimex(struct __kernel_timex *t
 		clock_set |= timekeeping_advance(TK_ADV_FREQ);
 
 	if (clock_set)
-		clock_was_set(CLOCK_REALTIME);
+		clock_was_set(CLOCK_SET_WALL);
 
 	ntp_notify_cmos_timer();
 


