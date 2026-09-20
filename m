Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB98C47207B;
	Sun, 20 Sep 2026 17:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789926666; cv=none; b=Cq2t6g9GNb40ogxgAzCdiA/zXN44BprCk76il71c4+ECtoGdx4gVBKgXtI/9+GE5oWCDFFMpaB8qCJd3IS3eDXGW31zT+pMSRNN99bMe8HS54tDUG6hnCzoW0KbTN4kELP+EWVM51x+8jOJYvhMkQbYh7gzTGanFG20S6NRAo6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789926666; c=relaxed/simple;
	bh=/6Dsni0ecTmFpDhWK+xBcLm4fMrdvHG+iQcfABvHSWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jS7Sk02pQ52Zg8HXIlx4e/Q4Cj140gQGf7tVnBk3+o1xCGtp9VuDwK9YqzQPDFig2mv8ljthc5EdS0DHx3DeW93O06jQLB/FfXj7ioqSMZAGCg8I4NRfsMcItfTJIRKpO44aydviWVgjprAUSv8SYYvn6m3RfeToWCRDpD5aLSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=heIFHKGS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="heIFHKGS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A851F000FF;
	Sun, 20 Sep 2026 17:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789926665;
	bh=08o1E5cyc7FdqGKDazlbh6cycAlVhPoC1k2NQc66Tuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heIFHKGSDjv8JSfMTu9t0uQQv+/JNkcayK9m3rgwsAj9E1VvUUXM92WuT6LIkkJ/a
	 MlbO82HdJIk3UuBYb4OhtOXkG8V2pvcQSXUE+/Q4CilOits4zrAC9uBMlHsUzf18Dv
	 kGJyvjte8rr+sL7NmlK/03MwAhEDLRv+Bn1mro7RvK04+jbF+PhL40B8zPq8AyBLZh
	 iCC1Kfa43bE3s5Qy8lcnVKMaHbHYz2cNXXmPgTR0LJwFlVTPaZr9/iMoqt57dvIj9a
	 7ySeA6zsarlH1xNK2xgEot9Aa8M/x+UeyKbAsLMrqjVBX/DZbD4nGURP1XSl1+du4t
	 4XdPGEjnMvbRw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jackie Liu <liuyun01@kylinos.cn>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 0533/1102] raw: annotate disconnect-side IPv4 match writers
Date: Sun, 20 Sep 2026 13:50:44 -0400
Message-ID: <2026-09-20-daily-reply-0012-re-raw-annotate-disconnect-writers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cd0a550e-02c0-4cac-a769-3ca0ac0e008c@oracle.com>
References: <cd0a550e-02c0-4cac-a769-3ca0ac0e008c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Therefore,
> 843d6af89a11 alone does not complete the intended lockless-access
> contract, and the raw-socket matching race remains.  The partial
> WRITE_ONCE() conversion does not appear to introduce a new regression.
>
> Maybewe should take an adapted version of 18f116931f52 with 
> 843d6af89a11.  If that prerequisite is unsuitable for 6.12.y, dropping 
> the standalone follow-up would avoid carrying an incomplete fix.

The prerequisite is not cheap: upstream reordered
__ip4_datagram_connect() to write inet_daddr first, so it conflicts in
net/ipv4/datagram.c on all three trees and in net/ipv4/raw.c on 6.1.
Three hand resolutions for an annotation-only change with no Cc: stable
on either side.

Dropping the follow-up from the 6.12, 6.6 and 6.1 rounds is the better
trade, as you suggest.

-- 
Thanks,
Sasha
