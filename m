Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DF442E416;
	Fri,  4 Sep 2026 06:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502994; cv=none; b=qJuHVRGt4sgv0RbLKaz0RWNLTUFFEFPiqcoGCu5Lpb62Ao7gtfVQgykvx81YPZUydmPUS4yH84Fj4w4o52UN7besG0VykLdR+XheiEauH2xvV+u4eGu+7qmgsWh0K+gEYTO26PQJu3J9K+Mi4KcN24u1RojlJOzrTnWrUsu1Ew8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502994; c=relaxed/simple;
	bh=ZkSf4rnCc52112y714jiT2TAlOeElZz0Kpa8RRDiJAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiYEZpG01x1FdgvtOZKFyPXowhAKnX2ryEG9hxiVgK96gVs+DvpPkmWpYeh8nYkYCOMFgku/HYgln5VkxLjhexTvN4FRhAPDeOtDFI804xvCP6Zai/qE00ZObKhoAcoQzQMrhQz52ek+dZQsQ4aOaNNhH5ZcD7LiMDFD94D5AC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8svjkZk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8svjkZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7C71F00A3E;
	Fri,  4 Sep 2026 06:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502993;
	bh=vwU1G5iwyXid5pvAmGLowPfTfFacK5QAahrUqfviEvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8svjkZk9tEcIomVDvxgUtSX0K6g6qfCYCduUky1Ejoqd9fWl5ysuPqy3J2svt6NN
	 gw5Uc3DXXn+M83sKLuA+jxm+wbE6xrYJytpwj21tvy5sNnf7UP1evCcwAIUDAihMw9
	 a6Fqnt6ZZyLPywce30L2bYIPYZCSoGM6nbEafhTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 401/403] timer: Keep debugobjects state consistent in migrate_timer_list()
Date: Fri,  4 Sep 2026 07:03:24 +0200
Message-ID: <20260904045743.897744563@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -2673,6 +2673,7 @@ static void migrate_timer_list(struct ti
 		timer = hlist_entry(head->first, struct timer_list, entry);
 		detach_timer(timer, false);
 		timer->flags = (timer->flags & ~TIMER_BASEMASK) | cpu;
+		debug_timer_activate(timer);
 		internal_add_timer(new_base, timer);
 	}
 }


