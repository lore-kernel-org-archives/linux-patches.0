Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B4036493C;
	Sun, 26 Jul 2026 12:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067503; cv=none; b=AJlyKKvx7KAKzvK3xKK1bgpljsIf4xOPVsUy7n6roHeoT1XZ/D7BVnwzLWvg/9/onxihcyvxh1PGGwy/BSP4yUKzvrHozAUT66k6ZNw6CeCEu73zbfgK4MHU4BzYBffJQMwFC4MEg96SZX8HrgyX+67TjCItiKdQKdbZUlY7+qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067503; c=relaxed/simple;
	bh=fYh1uAbF2vPjQFowQacrNfyUlQak/LE1Ti5CyFatMbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/BEytQSieO8we6NhdCqVzPP8rFGpc0GgM/N9xOfwf7oOSTgECAR6Tu+P5/L8FEnnceNlsHuNPJGo2yl4RoDy3+Q+6/nYn4CU+pHLaHOIvqwNbXv7nmQfvWEQhFVl9HSgnE7THEUj9BplxtuOGkl3YTdfVkxMsehI+ltw0+X69o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lqcRfC1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lqcRfC1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828A61F00A3D;
	Sun, 26 Jul 2026 12:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067502;
	bh=qMzY0/oiQ5lHdmlX/EPvsjRvEVPAmFxakLX9V6A7cuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lqcRfC1r6n5RsWHhbVy4pgWJ3Q7DxoETj84BvG7m/mh7TOtjnS+F+3ZgM7O9H267f
	 xGDFyV7iPDRV31aS7kuCccXJ/MaClUyXNbzRrW3FLJdNoxZGyinGPSfcKyHuWtiZVR
	 ZpCJgDQlxg5it2qqdSPbto7r45e+NTjZcK8zWr21g2bD83DtChkZpV53gma+bG/C8U
	 5DH4MmIwBlZn+PHOkd8Zwx98l8xneHA1Ck6plv05lWmr/6H6pwy9Ol9XugSQqDgVT7
	 hJLAvYJh2AJkkWC+NGunCjpwHi6r88SXJtYVzWD+rrUyL7aMLakyNCS2OCr2Tywl2L
	 mB32XeZu6soxg==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	harshit.m.mogalapalli@oracle.com,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Yun Zhou <yun.zhou@windriver.com>
Subject: Re: [PATCH 6.12.y] ext4: validate donor file superblock early in EXT4_IOC_MOVE_EXT
Date: Sun, 26 Jul 2026 08:04:44 -0400
Message-ID: <20260725192000.stable-0005@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260724143828.1668805-1-yun.zhou@windriver.com>
References: <20260724143828.1668805-1-yun.zhou@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> commit c143957520c6c9b5cd72e0de8b52b814f0c576fe upstream.

Thanks Yun, and thanks Harshit for spotting the donor-fd leak.

Since the original backport is already queued, the cleanest thing is an
incremental fixup on top rather than a full replacement (which just
duplicates the merged commit). In 6.12 the fix is to turn the early
"return -EXDEV;" into "err = -EXDEV; goto mext_out;" so the fdput(donor)
cleanup at the mext_out label is not bypassed. Could you send that
one-line delta and I will apply it? Thanks.

-- 
Thanks,
Sasha
