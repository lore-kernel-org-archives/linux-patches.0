Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D7B424D6A;
	Wed, 16 Sep 2026 19:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586952; cv=none; b=phjijWUtADzKBRFnpVkWT3NCk4yAD3B3COoKb1CpOpzmY2R9v7OFsnWMUJU+PM81LTZNN2pwxTIglXnscpxg9+ZMS8TvrSvo0r7GvbMfgy69ui0f8lF3n8Yq5RbgSPYxe+ydiYMexyHf7WBSmLFsDyY+BqbPWMhXLvU4NEsaC9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586952; c=relaxed/simple;
	bh=1BjSTk9uTuNMGOlusEIEzIAif6wFtk8a6Nn7KBkHauw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nY61XL5ZC2cA5YMEUYhBEqEHEXkv1CmrUEK9XEmeSUssWbOJQlIT3LVc1A5jfTKPTsq1Fgmx0gmt0FRqMFYnshLuAldQPzGhiVIKJxkk8LwSULxKzhfGS5ZUZAt/qmaBFYUhxwFdBdy+innxVM4+GOXo2V+I1YoycLuPxygsBd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ku12se2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ku12se2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D3D1F008A4;
	Wed, 16 Sep 2026 19:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586926;
	bh=hrqFh5SjNaPR3AWBcidmnKsmxIkq4/WvG+mYvdK93uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ku12se2FYUQwHrMnJQdRYptobl0RLLz0uXK7zOnYw0aM71p83z5K+FBCa/KMI4BWN
	 8ejcX3GqQeyGhCFuReCoDgijAu6zFChUHnaIkkaiqK/ol4eX0xx/xojWV1QAQAwwxx
	 ClSeGl8rPFGB6/TuzONWspzGheeABuucaW9KJol7jT9bQnzQuDP+JidwGcG33a0x8U
	 6aaLaDlZzpsI1ixVVTK5i7dVmRTbJ6UHjpcSWO8bijt0TLEafjnKiYRSwsgW+EX6Aj
	 aitXzOe6KomV5uvysxSYUlxCyB3TLHHSCtqyDp+crGF7fPTK7Hqxk1qkwr8XwO4oRm
	 oCJ7pOx1apAdw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Qi Xi <xiqi2@huawei.com>,
	Xie Yuanbin <xieyuanbin1@huawei.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0909/1376] ARM: 9485/1: mm: acquire mmap write lock around show_pte() for user faults
Date: Wed, 16 Sep 2026 15:28:06 -0400
Message-ID: <daily-reply-20260916-0016-re-arm-mmap-write-lock@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2f32382d-2f25-4acb-9126-ffbd14400486@oracle.com>
References: <2f32382d-2f25-4acb-9126-ffbd14400486@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The missing commits are 59e4f3b45b96a24fc9b7a89e5f8a2168b30f95af and
> e79ca91165d4fd18549c536abdb86101e889052f. I suggest applying adapted
> equivalents of both before retaining this patch. Thoughts?

e79ca91165d4 ("ARM: 9484/1: enable interrupts when unhandled user faults are
triggered") is already queued for 5.15 and 5.10.

59e4f3b45b96 ("ARM: ensure interrupts are enabled in __do_user_fault()") cannot
go in on its own on those trees. Without 7733bc7d299d ("ARM: fix hash_name()
fault") and fd2dee1c6e22 ("ARM: fix branch predictor hardening") it leaves
harden_branch_predictor() running preemptible, which is a Spectre v2
regression.

Xie Yuanbin has posted a 5.15 and 5.10 series that carries both prerequisites,
so I would rather take that once he resends it.

-- 
Thanks,
Sasha
