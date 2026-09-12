Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08C02D0C94;
	Sat, 12 Sep 2026 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241702; cv=none; b=rZKpb7wgJh6kzZ2xEmZpnzDeN6nc3TCykEV9lid41DxDlErFd/Y7LNOARAt4KoC9nvnHLuNUDCIdwnSm6UD7yRqKjAa6Bb1lj2ghXtYNErq/gIObnsJENWy752IHVq0+P+Z66BSycUQLHCjLp3zhPOLvfBdnnaY0kRR75cGQGkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241702; c=relaxed/simple;
	bh=ZgAaOErctvtcjCj0g+o3VCKhYfzu4SlQTK5noKtJhUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u3I8289mNjyA7bcT9dVAmt+/4UDPpCVWtzAwzdiIWgxQau4TgLRpjjN99ZjjP6FkJKS81NoeezvLH4cO8fwcBeiYkcOhZmsMntB+03QCLwYawDis7E5fw4KBvjCK5gLxjlJaMV57aQY5CwRgFYkhSaKfV1N3qfsjoHCSsIzU5MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dP+QVd/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dP+QVd/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B22D1F000FF;
	Sat, 12 Sep 2026 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241701;
	bh=dHN4dxQDD4McbVsz/5nblRw2cjKomLdw1CV0YtpPrGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dP+QVd/IOZfYeFE4hCSDHnu5yx6/2aO1R0YZbdOeQdJOT0wc9gFICYgVDVEo5y4gh
	 5/Uw14y5qZWNPobIORWQVcEbzqBfODz/q1UEAU2EJOk4nBJAPLkbORXOk8I3m3Gbzf
	 Jg27/db3fRDFPkMVVPbXxO1cYqn8F6v8iBzkpFZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.10 188/798] timer: Keep debugobjects state consistent in migrate_timer_list()
Date: Sat, 12 Sep 2026 08:56:56 +0200
Message-ID: <20260912065521.358196794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1963,6 +1963,7 @@ static void migrate_timer_list(struct ti
 		timer = hlist_entry(head->first, struct timer_list, entry);
 		detach_timer(timer, false);
 		timer->flags = (timer->flags & ~TIMER_BASEMASK) | cpu;
+		debug_timer_activate(timer);
 		internal_add_timer(new_base, timer);
 	}
 }


