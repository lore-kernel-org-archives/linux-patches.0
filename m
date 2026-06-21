Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218B29443;
	Sun, 21 Jun 2026 13:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782049683; cv=none; b=DdsK8gkWMqxT4+A+UnJek5sZjQsCzKN5GVvba9uriuJnyrZrZuak04SfMeP2iBn9s5PNTIk11YQBXQi75ZwknZ7Eg2cIV/waGGnG3u40rZOloK+1mXbBLiNB5n9DLn1VFyjsD+T7HWJOd/mYaZQKdJIBNF7bB3tUyAOp9GxI31M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782049683; c=relaxed/simple;
	bh=bloBjJx0axVh0a44uL+s7DyRBExTx6YKWBHDUaDYLik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq+G9fuXfo1Ushcy1sOMH3XNUQkxlTOsw7alsIXkGTu+LdLZwErObJoFa0Vxrs0mlRVE4yaJUzVDc1CxRyNx4M7WgOLbI6LOAaNYOJwSW53Yalkz186NR3OWS5J1xZUAFyOwPt1g62BWflOA1KVvbebnmh8pTG+teU2mHBMkGOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EoozgbFM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EoozgbFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CDF1F00A3E;
	Sun, 21 Jun 2026 13:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782049681;
	bh=bloBjJx0axVh0a44uL+s7DyRBExTx6YKWBHDUaDYLik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoozgbFMZ4995amEUua5eRK2GPrLhmu9bIVUhn5HC4+YsS7Jk7nyW5W8Af3E3lIg6
	 Zl5pdzNodbU/wObx4D/FVtHt7SgJuSD58qhOS+LN5F23BcVokU2mp36CnnMpK+apuZ
	 jx/USJc7KgV6AX2fDZqSH0u4hyPuDgLDQqAIyNfrlx2pwmn0xO74HjqwhGQx+S772a
	 f3o3kU8ffJp7canWMaz/lxLOpytIh1xDKVtIWAPzCwyHwlh2W7XCpKy3sSL+5z0EI+
	 /dcyfWlJNsoKMmnwEQvEsd7pC8ShocNSTSxdV2r57x1hqlM48sB64nsG+bRXOB3GxG
	 3+IHpq3YcvjTg==
From: Sasha Levin <sashal@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.1 208/522] net: Annotate sk->sk_write_space() for UDP SOCKMAP.
Date: Sun, 21 Jun 2026 09:47:46 -0400
Message-ID: <20260621133722.0008.sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026061944-vaseline-essence-0008@gregkh>
References: <20260616145125.307082728@linuxfoundation.org> <20260616145135.793184452@linuxfoundation.org> <6f805abf1f8b058c1b1241e8568d7539185145df.camel@decadent.org.uk> <2026061944-vaseline-essence-0008@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> > That other commit hasn't yet been backported to 6.1, so this is not a
> > complete fix.
>
> True, someone needs to provide that backport as well :)

I looked at backporting the write-side annotation 2ef2b20cf4e0 ("net:
annotate data-races around sk->sk_{data_ready,write_space}") to 6.1, but
a straight cherry-pick drags in four drop-counter/scalability
infrastructure commits as Stable-dep-of (sk_drops_skbadd, sk_drop_counters,
the raw-socket and NUMA softnet drop_counters work). That's far too much
feature churn for what should be a small data-race annotation, so I'm not
queuing it as-is.

I'll either prepare a minimal hand-crafted backport of just the
WRITE_ONCE() annotation in net/core/skmsg.c (the part that pairs with the
already-queued b748765019fe ("net: Annotate sk->sk_write_space() for UDP
SOCKMAP.") READ_ONCE side), or we can leave the read-side
annotation unpaired for now. Leaning towards the minimal hand-crafted
version; will follow up.

Thanks,
Sasha
