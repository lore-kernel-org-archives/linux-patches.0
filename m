Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450304229D9;
	Wed, 16 Sep 2026 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789586969; cv=none; b=P8y5H+/dEOwy42Ujcd3knciroZhgX8Xrq29GxEirHzApoG4wWVgwoRLSLudJCx3lBQzHtJrO0KG8B2EATQH2r2aYXNLLWaSmbAbWCDISGGm+KfVZTSPI2NpzN6Z7j/hq4XMMyJKI4LZeswSHqWdQKjzYCxQ719xYSBho1GRckiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789586969; c=relaxed/simple;
	bh=aCZZZD3k7IF1Uuy2EWw7k6uEDkBgpzq6rxXQoAindh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiSjA/i/ENNaXMCw0ahjVXHKKsFqfUTEeGX2sIc3mRNAm6vuQv2ejaYmR+NEXWkTHFP/TMXZhg+TX6zGrcL2A9/6c1VHqm85kvo9TMAwSG9IRg3qMyzcfGvK9Uslpninc77z5cqXpyWHOzfS+36gXD87ezPKi0Lzmfy0VvP7tFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QXq0tO92; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QXq0tO92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4D41F008A3;
	Wed, 16 Sep 2026 19:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789586929;
	bh=k8Z4RnHg0/AK4gUCjUPauHxKKRQpx+zycIOMOXjQopA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXq0tO92ic5XWSuBONIva75RMHAKSDgOkJYztdYjxSWMARZSCyOA1yb0qmMnzcUMN
	 dAAqf7Lw/0nqxpfUAvwyQ9uDpJmcN0lR5Th/55h/RmSuzOQrZo04IlG+CPqODsxC8Z
	 rRgTfPFibHt6yYphBgMsS795ZOIwjv20pHr3PLer4KfEdgGTK1LSD/yE3FcgZ16vF6
	 j8CdzoBBNxT2COHqJVfG2XB2xjmEi3yMEkfEKlljoJyi90CyTuzhIhJByBRvwbVIYG
	 zrqaNJnX+1bm/TwbHCz1d1vAhu5Zmt4TrYEvOc2AbVuKf22e/+1UyV5KVs8HDHomnc
	 h+MRPLIYZS19A==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1269/1376] powerpc: Add preempt lazy support
Date: Wed, 16 Sep 2026 15:28:09 -0400
Message-ID: <daily-reply-20260916-0019-re-powerpc-preempt-lazy@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <0de39bd3-3575-4955-963c-b528f81b7fa6@oracle.com>
References: <0de39bd3-3575-4955-963c-b528f81b7fa6@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> This is a broad scheduler feature rather than an isolated stable fix. 
> Mayeb we should revert this. Thoughts?

The pieces you name are indeed absent, and that is what makes the commit inert
on 6.12 rather than incomplete. ARCH_HAS_PREEMPT_LAZY is not defined there,
kconfig silently ignores a select of an undefined symbol, and nothing on the
tree ever sets TIF_NEED_RESCHED_LAZY, so none of the guarded code compiles.

It arrived as a dependency walker false positive, a Kconfig context line next
to "select ARCH_HAS_PTDUMP" in the hunk taken for 902caade3cfd ("arm64: ptdump:
Make note_page_flush() range aware"), not as a real prerequisite.

Since it is released and does nothing observable, I am keeping it rather than
adding a revert.

-- 
Thanks,
Sasha
