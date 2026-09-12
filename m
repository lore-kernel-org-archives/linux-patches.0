Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C786037FF76;
	Sat, 12 Sep 2026 18:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237254; cv=none; b=IM0naTg0iB0Ss8cZG32awOhH0kDqav8hqgPdKEogYPn3wRC6e7bz1ukP2fENoZJ1yPJt19CbPnZJD+DQuzK5VofxHlWJIHsToR2/M9zbc8nWxjmMbMP/cy48BUF/+LEfRFrZMHpHt/aWat+outzkWoLkqeTPCGZ7g4KzcwhU7FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237254; c=relaxed/simple;
	bh=ncB2r2PwuvVfyPZvw/qr5W/8JwA0h/CQpFjj8LfS2mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnhN+oIh9HhgcURiWlxLib1FnG65mcz+46+CKD2QXSm+uuj3Bdammzg8FRtTZ4+S5/tMPYf1dBP5d8srsaXy3TSfsQWz/o2PDzwarBCaXS8xXWp8ZWEB2vItjQma30HUCHjDBq4kef9voN25QCxtk6DoHr/Dx35/K6cuvd8GOCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWBInPnj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWBInPnj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD65F1F000FF;
	Sat, 12 Sep 2026 18:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237253;
	bh=5LQEccrxqvslpH3+s4gbQ7hOuGoHWxtxM76jAZICLzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vWBInPnj+j61f7OsCjBzX9OA1DJifDo37f8kuO8eDtjcb7koigr3B4YBY8flhEgMR
	 AaUvr9jBA7iktOaWwbwc2tVDtVP9EHfNhydVhN08x6neNLdgyzlxAAbSk5TSXIZQMX
	 7rAeM+ODF45klsARBOxSRl22WsyRt5BofgELubz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.15 214/935] timer: Keep debugobjects state consistent in migrate_timer_list()
Date: Sat, 12 Sep 2026 08:54:04 +0200
Message-ID: <20260912065531.731676217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2173,6 +2173,7 @@ static void migrate_timer_list(struct ti
 		timer = hlist_entry(head->first, struct timer_list, entry);
 		detach_timer(timer, false);
 		timer->flags = (timer->flags & ~TIMER_BASEMASK) | cpu;
+		debug_timer_activate(timer);
 		internal_add_timer(new_base, timer);
 	}
 }


