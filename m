Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAF037B02A;
	Fri, 18 Sep 2026 00:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789692795; cv=none; b=AlUgpJbKGUilyWOhBvSzeBcVGezsZo23UluPX9e7z+7O/dSoOgwHKUM9N6baTkb8b4oWQ76/Hg1WDspcJusmi4AD/cVt0O9+LwT63BR63eVsnD1F64fgTjzQ7yCO7iZlQzBwsgBP2cSNVzIGdqmrIrRfF5SXL8uIoEzXZ2Dv8O0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789692795; c=relaxed/simple;
	bh=7wkTTeAmmqw5+Igdaidv0WI/LoRxRztWDxXUFnFdJiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qa5vmHkncpoQryTPS7kPLPufwMeA7F9Qlj66r/KbA+Vjplb9d6diq/dcGNjgNB9Jw8OMDXbjA2GtRgnba5vfvsnXrzgGWnYfE96tbsTEHsK4Dm2RACs8CxRZd6+uN1em6ZhTlMSzZImE0c1Ms+Y/Ieq9pfwRorZQzUaSl+sIoFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=leQtdrms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="leQtdrms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD271F000FF;
	Fri, 18 Sep 2026 00:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789692794;
	bh=SRhs32coGhSHb3xr+S2DReS6gAixTYLbsaCbgmk/nao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=leQtdrms2LdAa2ItV87z+yQwt6fZC38CZtpaQjczxmwa7x5HghqH+XdGNabblmvrU
	 oMT/75uVpb6EXUQhsuFI8ObGT3NOBuUCub8r+hi3IeEbDU2Gv3A1xKrTsw1vskDgnh
	 xtX94DfWn/csg7O+dbw3OIn/WZ3dwgx6XHLLg3D9nyFFZVXjeH6SMOiX+bKog+zAw1
	 fVYcOpzUGv8SwQJb8cWCyJnfU7i3kG8Tq8n4AUuuVux9+itdsurHENFX9OOY00E9Uq
	 SURu8103VXMJMMq3bLOZbHPCMXzsk4VbLv/UapitYWk1AbfUubw9WrWYOVDh3r8lDD
	 zZQJOT0+7BX/g==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>
Subject: Re: [PATCH 6.12 1269/1376] powerpc: Add preempt lazy support
Date: Thu, 17 Sep 2026 20:52:46 -0400
Message-ID: <2026-09-17-daily-reply-0019-powerpc-preempt-lazy-6-12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5dbf3584-23f6-4ed4-8a62-c7d8bf9e554b@linux.ibm.com>
References: <5dbf3584-23f6-4ed4-8a62-c7d8bf9e554b@linux.ibm.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> As it has been discussed it is really necessary in 6.12?
> Seeing some LAZY related code while main mechanism is missing can be confusing. No?
>
> If main mechanism is not there in 6.12, I think we can drop this patch from 6.12.

It is not necessary, and it is also not doing anything. There is no config
PREEMPT_LAZY on 6.12, resched_curr_lazy() has no callers, TIF_NEED_RESCHED_LAZY
is never set, and PREEMPTION there is exactly PREEMPT since powerpc selects
neither HAVE_PREEMPT_DYNAMIC nor ARCH_SUPPORTS_RT. What landed is dead code
rather than a behaviour change, and it came in through a dependency walker
false positive rather than as a real prerequisite. The byte identical dead LAZY
code also sits in the s390 counterpart.

So I would rather leave it than put a revert on a released tree, since that has
its own churn cost for everyone rebasing on 6.12.y. If it ever gets in the way
of another backport I will drop it then.

-- 
Thanks,
Sasha
