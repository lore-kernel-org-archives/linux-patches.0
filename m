Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E77625A640;
	Sat, 12 Sep 2026 15:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227764; cv=none; b=mP56iwtUi2Oc4v56cHv+qcamRHSVzyRupO9J2c5HT78MSvLS1ys4asn9xBvpyH9Wlm3clykrG2C1ujRjOUEqbekeUw30KzX7fDrUCiwD9nh+UOaX2a8SW5sdDzWqLA6Y9ERyuP7E9S7Qywp5X6Uu3flRytyturpvDRy0SV6VOqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227764; c=relaxed/simple;
	bh=fnAGvaMCyr05RGt8lgs+Oq47TiHm5Gt3646cC3Gfzlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIyrNtRNHokieAKfAFk/5CSDr0vfv+aVc5J2L3imkDmcUdnyZK1TmAYcrKqIdBhrp2mQcqBu80IA1a5YAp73OSR1t33oJyBtm+q6eMoLlld6+Uu23SrwZjOmH+DpmY2sFqL6Shso9wtjzQxtcX9lXN2g38IUqa9UH63z7W23dug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dokT+mJN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dokT+mJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3671F000FF;
	Sat, 12 Sep 2026 15:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227763;
	bh=TMwT7xUUQUeNWs9ZBzT/oRW/fWu0H/PG/eEAAwPgd7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dokT+mJNO1q6K4vVItU4VVwt9U5REgrsBPT13A+FOGq9G6wSHj7g3lCTAQQLfv33x
	 Bkv8iJ4AkTCq6TA7r4azIYI4bB7V+++2m3lmI5/2lp63DLu1pTL+v7u/1arpWYjUsG
	 DU3GL5tFMKa5htd4xnXCRBLs/poDtOInvwUOC+5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.1 0249/1191] timer: Keep debugobjects state consistent in migrate_timer_list()
Date: Sat, 12 Sep 2026 08:49:37 +0200
Message-ID: <20260912065553.811483540@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


