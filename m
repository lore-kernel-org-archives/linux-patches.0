Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D128436E460;
	Sat,  3 Oct 2026 01:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790991031; cv=none; b=AkP0BvF3yWyVHkmvx8B3JYsfXqlvXpdEwonHkSYYIq1B9Xaqn/MZ/uCc5jOt75saWJCczdmSPb78StEb4sFBdXlhRjcd4JhwBYWN9TCkY0uf0Gz6TU4iaiLVnhHIXP+fdalTm8Z0rQHH9u+WblZopKWWzZaR6/4I86xVcBZzb7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790991031; c=relaxed/simple;
	bh=T5YGkfDPhlmkKMj/3dz8o/loQstbcbQcrUpbAaEWuoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GN9CqtwbZG8ZF3gYelXnYrnHdZJufP8wSCyVoKKOIhWeVAuod/tFv5e498Idc4d+axg54OwmbYwgpwsd4tQktFX+o/+hv5Dm1vndwvCcGGGYknzB+0V10/BlEEiB9ZEkSIz9MBz5eNPgG6j7bQo/yq1A5eetYsGLwYeSCEstin0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4KSaHqI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4KSaHqI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC62E1F00899;
	Sat,  3 Oct 2026 01:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790991030;
	bh=fXXjA5Na9mCpdk3aVWgSfNLegArrtR6zxSIa8KQqhEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J4KSaHqIGPBoEfexI55KTDLs8Fw5CPCQL9hUzCQOgoR8al46IqFNeI+bHdPpAij7n
	 Lvxlbxw8Jhh//95IfPM99idJ189C/ifH4olWHozbr8BUo4tgGNacHVN3gz0M+tFUBD
	 uhTm0nJRYgdHugeubbpBRUe0hsCSQwKYLgumL3LOrahQhwH1iBl4iirDygM0V4xqCX
	 0PJ8cMcqxy2Ldv/DXf2a/5uG9gOke9adHQk3Xb6eG7Q1Ryp1KUgVZedKo6fZA7X/Y7
	 4t2zg1PlUiLueWQsCgpfm9QV2poz80IZTHhxT0Yv/lEbY2QYLqaifVo1cq6iw8GYn8
	 xK/2b86wu72Ug==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 554/877] xfs: drop dquot flush lock when we cant find a buffer to flush
Date: Fri,  2 Oct 2026 21:30:22 -0400
Message-ID: <2026-10-02-rc-reply-0002-re-xfs-dquot-flush-lock@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4463bbc7-ee0e-4f92-a075-e2dd331adf30@oracle.com>
References: <20260930152414.738996857@linuxfoundation.org> <20260930152426.598291693@linuxfoundation.org> <4463bbc7-ee0e-4f92-a075-e2dd331adf30@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Could we replace the new mutex_unlock()/xfs_qm_dqrele() pair with
> xfs_dqunlock(dqp), keeping the early return and out_dqflock cleanup?
>
> or drop this fix for 6.12.y ?

Greg already dropped the 6.12 copy. The 6.18 queue had the same
unbalanced xfs_qm_dqrele(): 6.18 doesn't have 0c5e80bd579f7 ("xfs: use
a lockref for the xfs_dquot reference count", v6.19-rc1), so its
xfs_qm_flush_one() never takes the lockref_get_not_dead() reference
that the new exit path releases. I've dropped it from 6.18 as well.

7.2 has that reference, so it keeps the patch.

-- 
Thanks,
Sasha
