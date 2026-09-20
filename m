Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AEE472F61;
	Sun, 20 Sep 2026 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789926664; cv=none; b=Y8QM7F0QpcOBXZQ13MUKSc+SdkIPscGSx6fygiN8G8RXaJNYuU/xoRIuvY7455EyaT8QKZXDqaR6FONpVzriC7zqSYTmHTcnQFgg3I7p6rw02S5AiE+fdHVWwRyOQB370OcRoWk5b/+Hf5wiSa6EK0EEc7Xsx6MdB0omTyDnuFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789926664; c=relaxed/simple;
	bh=aKtCQ8EQksz0kTvpq/6BjM7GAR9kex6Bbgr2Gpah+Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulD5JIHnZbBHiNL2xlLlnR3a8Q+rObz/MX90qjjLVEm3EmTYyVXk28vV+k2ofNToYFavgp1vNoW5albGP+7V3lGViOuo8ApfHxZLjsVcEW1V39umTvuIPaS89q2Zn6NMWmWuHAMN5OryOqmg/wDS44vC+g3yYtnhTlcxEFlUNSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXXEmssX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXXEmssX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB1C1F00898;
	Sun, 20 Sep 2026 17:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789926663;
	bh=N04XbJXXjle6GDQt1BliGEChPTGaFsZotHb3+Czrv6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXXEmssXEBBzn8tOVedy+6SgSJFh5aPX5NwcCTTn0tcxPj4ZeDroMmC7PILlwx8AE
	 rrxpff5QqRH9YJIG3MR6dzGKF8l+ONxpvAqZfiCDhpw8BfHw+lApmqxIazC2rH1u5U
	 O7Q3uovx/rAuoeTBbc625kihbDxyNZbUFgAJgtUUSsRLAQ2Sl3InFt0+hk3Dqeb20/
	 uWMbwZhAkTAImXGGafTgsguS/Yza7BvoSZZvZcfI6nM3CJ9plrzkN6IrjzkHCZQieD
	 u/bCXXd7h169g8xoaSubRoEfwbKYwUtvHoqZMHBIRdFdPnchOwOGZsf2IbWp5GYCMw
	 G660e0uygUVjA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 424/935] bpftool: Update btf_dump__new() and perf_buffer__new_raw() calls
Date: Sun, 20 Sep 2026 13:50:42 -0400
Message-ID: <2026-09-20-daily-reply-0010-re-bpftool-5-15-build-break@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <9f5619f7-f726-4214-b87c-c052144134ea@oracle.com>
References: <9f5619f7-f726-4214-b87c-c052144134ea@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Would you be planning to revert the commits ?
>
> Don't see it here: 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/log/queue-5.15 
> , so reminded.

Nothing queued yet, you are right.

164b04f27fbd ("bpftool: Update btf_dump__new() and perf_buffer__new_raw()
calls") cannot come out on its own: it conflicts in btf.c and gen.c against the
libbpf_get_error() conversion above it, which in turn conflicts in map.c. The
clean removal is the whole six-commit chain, newest first, which also takes
66d7e39e49b0 ("tools/bpf/bpftool: Reset vmlinux BTF after map commands") and
two other bpftool fixes. 5.10 never had the chain, so that realigns the two
trees.

There is a third break the log does not reach: btf.c and gen.c call
btf_dump__new() with the post-1.0 argument order, so on 5.15 the callback is
passed where the btf_ext pointer is expected. Any revert has to cover those two
files, not just map_perf_ring.c.

-- 
Thanks,
Sasha
