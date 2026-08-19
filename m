Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF932DE6F8;
	Wed, 19 Aug 2026 11:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787139552; cv=none; b=L21FQTvPAlH5Y6/jdxEU8f6qyV5QEBSK58IqXGnChobb72Pv0C7UMKVdB8jFH8xTpsAoYx8449K3M2uJP2l41nOWHMNWsfK/3MnDhWiNhvHo49Dn3hPLqcWaKQPlSIVqtdGKDCB3qiyrZ51iat22YtwzBCdyC24WwXRqNo0rFhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787139552; c=relaxed/simple;
	bh=UNd4nuWLBi7E1iPYuLMgZUXnFqahLooCpiLiYdLVp6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1hJ3O6TJWXI/rQmBPQq4VNa9zjMoQxO6rdk3p+bZRP0tRvTN1zFK84cQNddtmXDcBpa8kO/8B0xJf9yoOMloXnjeTJ7sG6d8MuPcas4Vm//jeLMBMzhI96lAthDZBfU4aDTAyjOTm8xWP+xijgRLvQd1VKvAnOa+4dHOj1EWd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2pD8ZA9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2pD8ZA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078121F00A3A;
	Wed, 19 Aug 2026 11:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787139550;
	bh=3bKUiWBHvWmcLlo+YBut45F5CupWrHT6J7Rwr67A0FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2pD8ZA9DHZ/H6/C2jQLBl4tp56Q1EtQqRDSJAw7TROoNy5t8UqmeHmz90f9DnG5n
	 ZTGfvhqVflIEvWRc2FDEWKCEiAy5IvC/2Lc971TpvDoU/DkO4ATCVLHYGH3VxukWZ4
	 UC+lgBCL2naAnTMP9McaCd4Su/EFUaAY4jb9JGiuRDO+RwCgM8v9fJ8B2Lar+Ire49
	 tx1YMMU/n55+PVI+7ONCQX+Kl09iPr+PG4dX5SnRdm7kZ3EVOSvDM8li5lMI/He7Mo
	 hPxY9HbR23BKwCKvaO6fcXw6c+MSX0wfFfghNzm7ogpsBStvtCLMthBraqxvmpRaW6
	 1I9aBgiSi+yTQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	vegard.nossum@oracle.com
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 166/181] ring-buffer: Use current_context for safe per-CPU buffer swap
Date: Wed, 19 Aug 2026 07:39:06 -0400
Message-ID: <20260819113445.rc-ringbuffer-f27bdc43@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <70b7ca30-be03-49c0-aea9-840d734011b8@oracle.com>
References: <20260817132535.394764707@linuxfoundation.org> <20260817132542.216680403@linuxfoundation.org> <70b7ca30-be03-49c0-aea9-840d734011b8@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Aug 19, 2026 at 01:50:50AM +0530, Harshit Mogalapalli wrote:
>This changes invalid CPU-mask, page-count, and sub-buffer-order results
>from -EINVAL to -EBUSY. I think update_max_tr_single() treats -EBUSY as
>an expected commit/resize collision.

Correct, thanks. Upstream only has the direct returns after f115d2b70bff
("ring-buffer: Remove jump to out label in ring_buffer_swap_cpu()"),
which first appeared in v6.16. There's a second bit of drift on top of
what you spotted: the patch also removes the "ret = -EBUSY;" assignment,
so on those trees the out_dec: paths (current_context busy, buffer
resizing) end up returning the earlier -EAGAIN instead of -EBUSY.

>Maybe we could be retaining ret = -EINVAL at declaration and assigning
>ret = -EBUSY immediately before the new current_context checks.

Rather than hand-adapting it, I've dropped this from the affected trees: 6.12,
6.6, 6.1, 5.15 and 5.10. 7.1 and 6.18 already carry f115d2b70bff, so the
backport is identical to upstream there and stays queued.

The race fix itself is fine on the older trees, so I'll look at requeuing it
with f115d2b70bff as a prerequisite.

-- 
Thanks,
Sasha
