Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C24330B14;
	Sat, 12 Sep 2026 13:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221276; cv=none; b=tkqew1FbbsRrIRae1eRi0d08abo0rHDrzYI+5nUPR6xHjirO6lLV69YqGSNUikz5BZRhxrDY6kKOiRiNdNT4wJWr9wFgNEGiwK1tDwXDLagBhBbxlptTmc9KOeBOalmByxRLs9NeMnQM7CxYxDo8mMq8yBm/HaZJBiP3VJWUMqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221276; c=relaxed/simple;
	bh=HmX1dg6icbEQS+hYflQsNX4Rc2jx6J37n7FR14eJEP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRbFKILPCeVSCjA+LaXji+oOjqKfz/TWSXCfg6698fDAyb9ZbZlUBQUErQp2gPh3wNXzuKSOwWSFBaT844KIa0HNWBDlihFFXMiRbLMGpRCulgzuajbGaEkFOmXcdv3SmHQraqOco9LtfTnee2pdxWOEcVduJ09OFIjqBCrv7qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VrrBPPZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VrrBPPZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF291F000FF;
	Sat, 12 Sep 2026 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221272;
	bh=ZeF/FB1g/UI4k0/vJ5jjL7ig9FqrDwMhFrfUaU9azNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VrrBPPZY/IIA52agBa1jsVfkw6EdIZowP8Js2/4nyMkWhcdMY5AjG27wfVf3jY/3i
	 fsYqklH8R83Vl64By24cXchKmw5lWPtcm+aRhqHE7SL1SUMYIAXZFf6llC5WTNijTD
	 K+VMuHMsfZtiyDRKfjsGYVNGgjoLONt5Ic7j464A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.6 0306/1424] timer: Keep debugobjects state consistent in migrate_timer_list()
Date: Sat, 12 Sep 2026 08:45:38 +0200
Message-ID: <20260912065614.135703697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2224,6 +2224,7 @@ static void migrate_timer_list(struct ti
 		timer = hlist_entry(head->first, struct timer_list, entry);
 		detach_timer(timer, false);
 		timer->flags = (timer->flags & ~TIMER_BASEMASK) | cpu;
+		debug_timer_activate(timer);
 		internal_add_timer(new_base, timer);
 	}
 }


