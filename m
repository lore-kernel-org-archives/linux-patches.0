Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB163388E62;
	Sun, 26 Jul 2026 12:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067512; cv=none; b=h3MGTbNHRFedihLwtTe3RbcDMAoHKaj+qsw2XD8J9bN8HdHEjipbOk+62NPwpcx+Voq/ieRu6kUCOjwAPMth/Rsfuvd55CeDUtOkBKnyDckRsxkKzLjP/drZQAA6YIiN4FjXtTYkxkWPc/EGV4Vmpez42v/wfKEKN6wF4dXgJKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067512; c=relaxed/simple;
	bh=cw4JeZXbrpriQKCBkGx34xgY9j4UD8xKqtPcf1KuW2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7VKW6RGRnIjzyk8b/x1ZoEI21+9Wu5AbKdhX86OnUP9H7e0MOa9yeSI7J/uWMmoA6veyPk7cHINolij1iXXEeNSNheM6/dyUOybao5fx2PTXihQFpiW5WThdnm+3Ae6Epvpi5Jjl+GjJjTRi1WGoYVQR1nlpZaiQN9Dpby/K80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgdJfyF1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgdJfyF1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D791F00A3A;
	Sun, 26 Jul 2026 12:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067511;
	bh=7T97vetR8vPwz2yUzHd2WS/6+HDPDKgVpmagoFJ1C1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cgdJfyF1z/miFu2MOQco8xzUclsgZZ5b/2iLMt0yhR0eNqz5a0LAW6nCx9IxwMfmp
	 DHbFUG+dbyAPx080ZjaV4R7lw+/ZvxY509P3hvs/Z3m9bXNeqBu9xI9POLRqKQn5MD
	 Tj9QAaPUJpOQ/GFdq6sZNIFn+VedNy6PWkFBQm3gSNtmbXxMThgiIEwkcO25Xw+xm8
	 3jz6pe3P9+QYzgpP619MEq0Wvxfv4XF8HZPn7TspyDSIq64rAJn6DwARbcppcLrABv
	 IaJoyDAseGA1XHdAoQQ/hNM1X/Nypkpj4CdDOodB5dFPzYPYF1CqCHMGJN3AO9t4o6
	 yzThnnB1JbXZA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Simon Richter <Simon.Richter@hogyros.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	vegard.nossum@oracle.com,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 6.12 1155/1276] PCI: Fix restoring BARs on BAR resize rollback path
Date: Sun, 26 Jul 2026 08:04:52 -0400
Message-ID: <20260725192000.stable-0013@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <51bde2e9-0989-4145-9fb8-cdfb08c50e29@oracle.com>
References: <51bde2e9-0989-4145-9fb8-cdfb08c50e29@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Those are not equivalent. I think this backport is incomplete without
> pbus_select_window() semantics, or an equivalent branch-specific
> adaptation. [...]
> Without an equivalent fix, I think this backport should be dropped.

You're correct that pbus_select_window() (74afce3dfcba) isn't in 6.12
and older, so the backport uses an "r->flags != flags" sibling check
instead of the window comparison. But that adaptation is strictly more
conservative: identical-flag BARs always map to the same bridge window,
so it never over-releases and can't corrupt state. The only shortfall
versus upstream is that in a rare mixed-window fallback config a resize
may fail (return an error) instead of succeeding - exactly the corner
case the commit message calls out - and the common amdgpu ReBAR path is
equivalent either way. Given that, I'd rather keep the backport than
drop the whole rebar refactor chain it sits under. Thanks for the review.

-- 
Thanks,
Sasha
