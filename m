Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2647D07D;
	Fri,  1 Nov 2024 01:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730425992; cv=none; b=Ru1PetGv+zwj50y8qwxbouamI1V6yHNmIKc6OoG7d6/k7SF5A/ZMICurScTvLn/VEWdPi5tDP6Yz/bP06Uq4kSuZdce/bPIR17JbOSfZfv4AEZfMVSSgvyzjMCI9E1BPaeyWVwi3Upq/5Gx6TdtdJ6VktWquB2RzggrhfScEybY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730425992; c=relaxed/simple;
	bh=2TU62Hgp56g5+Sz4wGbj7LZ9edguPOOihgw6ErBjvh8=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=GJIIKMPirWVW5Yp/x4qontf0meN4/E9zapxYD2ZGgBwr1Clgf+pHQ2pq5/+otGc2fHLjcp827ZhI0hzXi2ATEXf55++WIgiPPpH1BCNXBzTDAS3l5WdaD4DR8I1MgLT5LyUN9pBst8IfOhPpZQsi5V0wR20BdXUTUBisPizZbHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aEqFY/D0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aEqFY/D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E254FC4CEC3;
	Fri,  1 Nov 2024 01:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730425992;
	bh=2TU62Hgp56g5+Sz4wGbj7LZ9edguPOOihgw6ErBjvh8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aEqFY/D0zWm2HZsvfEQD9UCb49YP/MdonDE5DUbK9KN4miXrUPKq5U4w2j+S7U3DM
	 YkRIS1p71AWdz6Ao9SSI1mNogr/+9XlC1MhmzB5IUOSUTahn/C+Tti0H5RwgYOReaD
	 lhQf9qPD1L0ADJgnGM7Z56U+6/6ezbDSNwqWXGb2LpyGL6ZgLxOkw7y62BS9FySg4Y
	 BlCxjNNtgte7SmK8+K17yI0tR5ckLqb/eSmhF/fSVKqNMJkeJhASH0PTbY0T0obUkw
	 H8Pioh/gQbMpn5lTsGv0hcbam2SdL0DA3saXKrOkX/lDOg4JPH39KwmSnOIT/MkpUl
	 xkL4NLNzBUmjQ==
Date: Fri, 1 Nov 2024 10:53:06 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Naveen N Rao <naveen@kernel.org>, Anil S Keshavamurthy
 <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Jinjie Ruan <ruanjinjie@huawei.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 patches@lists.linux.dev
Subject: Re: [PATCH 1/2] kprobes: Fix __get_insn_slot() after __counted_by
 annotation
Message-Id: <20241101105306.d198e543f9b60270cdcd570c@kernel.org>
In-Reply-To: <20241031033731.GA2553234@thelio-3990X>
References: <20241030-kprobes-fix-counted-by-annotation-v1-0-8f266001fad0@kernel.org>
	<20241030-kprobes-fix-counted-by-annotation-v1-1-8f266001fad0@kernel.org>
	<20241031105827.08b362cf0dcf558f9cf59ad8@kernel.org>
	<20241031033731.GA2553234@thelio-3990X>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 30 Oct 2024 20:37:31 -0700
Nathan Chancellor <nathan@kernel.org> wrote:

> On Thu, Oct 31, 2024 at 10:58:27AM +0900, Masami Hiramatsu wrote:
> > On Wed, 30 Oct 2024 09:14:48 -0700
> > Nathan Chancellor <nathan@kernel.org> wrote:
> > 
> > > Commit 0888460c9050 ("kprobes: Annotate structs with __counted_by()")
> > > added a __counted_by annotation without adjusting the code for the
> > > __counted_by requirements, resulting in a panic when UBSAN_BOUNDS and
> > > FORTIFY_SOURCE are enabled:
> > > 
> > >   | memset: detected buffer overflow: 512 byte write of buffer size 0
> > >   | WARNING: CPU: 0 PID: 1 at lib/string_helpers.c:1032 __fortify_report+0x64/0x80
> > >   | Call Trace:
> > >   |  __fortify_report+0x60/0x80 (unreliable)
> > >   |  __fortify_panic+0x18/0x1c
> > >   |  __get_insn_slot+0x33c/0x340
> > > 
> > > __counted_by requires that the counter be set before accessing the
> > > flexible array but ->nused is not set until after ->slot_used is
> > > accessed via memset(). Even if the current ->nused assignment were moved
> > > up before memset(), the value of 1 would be incorrect because the entire
> > > array is being accessed, not just one element.
> > 
> > Ah, I think I misunderstood the __counted_by(). If so, ->nused can be
> > smaller than the accessing element of slot_used[]. I should revert it.
> > The accessing index and ->nused should have no relationship.
> > 
> > for example, slots_per_page(c) is 10, and 10 kprobes are registered
> > and then, the 1st and 2nd kprobes are unregistered. At this moment,
> > ->nused is 8 but slot_used[9] is still used. To unregister this 10th
> > kprobe, we have to access slot_used[9].
> 
> Ah, I totally missed that bit of the code, sorry about that. Thanks for
> the explanation!
> 
> > So let's just revert the commit 0888460c9050.
> 
> Reverting that change sounds totally reasonable to me based on the
> above. Will you take care of that?

Yeah, probes/for-next is a working branch. So I just dropped it.

> 
> For what it's worth, I think patch #2 should still be applicable, if you
> are okay with that one.

Yes, other patches look good to me.

Thank you,

> 
> Cheers,
> Nathan


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
