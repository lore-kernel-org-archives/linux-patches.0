Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E3C4CCDC7;
	Fri,  4 Sep 2026 05:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500268; cv=none; b=ea+hHfnEz8E7Pk9al9lEfa6G3HUXJOXp/JI9RqnSwtbmlL+MLBFLGgnuJBhal+tcuASM/ciqrZYIw293L9+QhSvEs/Gsd42tP2ZeMmwWRZDiZoqzecDooDtCQjlmZ2UeVhcWyfEQGRhieGAfTBR+mIlL6r504lyyyuKxPQowmDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500268; c=relaxed/simple;
	bh=tG3DR5nHRl1R6sYZeBfZUczur1zr3JzNkVzJzxw0tDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezFGahyGBTAlAZ/TVVZQ3qFnQZwL1G+arAyUDTfi3gxEGxH5Su6pCVYjIlBgsBQd4d34I4xDKlrex5qFpeZ1leRu5j08sOXgoNGXsR0ZdwAa0OhARP59czVmeSEdv2KzI2hSyh38On+V+mxSf3169IrH6ePqv5DX0tHofByNjTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjJc59Gj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjJc59Gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6711F00A3D;
	Fri,  4 Sep 2026 05:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500267;
	bh=LtLqOiUT4SQ6owcBsRjyGLKfh248onOAPjWelGpsups=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjJc59GjHh2xqIenu2VJhSWA89uXMSmpw5No9T2CEVCaqC3DASfAFtLogDUSncEO7
	 0KnmBpYqT6hdWORboFm/UioebHiONxYbNArvfGZM9rqIWGr8JBYgVVe0ONvoom7n+x
	 wnOR8yhMh8CCcB13t5x0U5YfBeDq9LR7JopZk28k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 7.2 709/713] timer: Keep debugobjects state consistent in migrate_timer_list()
Date: Fri,  4 Sep 2026 07:01:17 +0200
Message-ID: <20260904045819.741178848@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2492,6 +2492,7 @@ static void migrate_timer_list(struct ti
 		timer = hlist_entry(head->first, struct timer_list, entry);
 		detach_timer(timer, false);
 		timer->flags = (timer->flags & ~TIMER_BASEMASK) | cpu;
+		debug_timer_activate(timer);
 		internal_add_timer(new_base, timer);
 	}
 }


