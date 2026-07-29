Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C41028C037;
	Wed, 29 Jul 2026 03:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785295082; cv=none; b=AJy8VqUyNJO/yoF71tFGd0vY+WVPuIoGT1o0WA0j3qHzZFh0GugrluKqOsgOa0bCJp1U2RdAA3pjU4i3PibH6oeUquu6HxM1IIGNFjnbVFo14pH++Tt4nq6fX3oWQVXzrV7dq3OaLnRqepeJbpZgsrb8h9NMVvyol871DasQ36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785295082; c=relaxed/simple;
	bh=bRsTJj6q2I3GDXVrSBd3eGbZvdGRI2dPnC6Ry+bL338=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFKVZiabnz2VqYY1GBoHBq4EhfqWnfcg7tcXpZD6ddopiRpHUXaNNvTU/KNGMkilQ6yUViVZPR2KXsXMFU6Lg2IorKJVTozZKfrd59LEDdLikiRo92wKKSDq7DqAXaoa3mrEmFCzldasY42ipH0WJ6naxpONhz8Pk79xJEh6qiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RvOk5wOm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RvOk5wOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A0E1F00A3E;
	Wed, 29 Jul 2026 03:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785295081;
	bh=nnuuji+riVImJSddJRAk/Q7uspzX7HnQ3lL68aJ1Tto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RvOk5wOmxG0UnQQpb0yMiiPK6K/oPer69gYpzf9LIiqoETGVLHxtShK+e67sMwwOI
	 16K0b1S6QM/C0YRg/LoEP3DHS4mCJWC3OYgXhDa3tiGtRJN1QeyjnpAPA9HKXwBMpW
	 AHJJoY1ruUqcIMiR+yOkTNDw3QyLKlc+8qElajX7r/bJzCZf37dw4IW3auQCaFL206
	 UXwej+hz136OQuAtPfuey7FkXnyhLMxTB4LahNg+a9h9y0SEhvuvKS/h/zTfyRGl9Z
	 c9qPxOgtCzdPtFS0fN8CpnOekF0AEqD6qMi3+Re+spzdQfmSPk8S83OZaSoELn9y9C
	 ZzjcbMdwGex+A==
From: Sasha Levin <sashal@kernel.org>
To: gregkh@linuxfoundation.org
Cc: Sasha Levin <sashal@kernel.org>,
	andrii@kernel.org,
	ast@kernel.org,
	kpsingh@kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	xukuohai@huawei.com,
	Wentao Guan <guanwentao@uniontech.com>
Subject: Re: [PATCH 6.6 0772/1266] bpf, lsm: Add disabled BPF LSM hook list
Date: Tue, 28 Jul 2026 23:17:55 -0400
Message-ID: <20260728225520.stable-0003@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728033810.1870379-1-guanwentao@uniontech.com>
References: <20260728033810.1870379-1-guanwentao@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> backport ("bpf, lsm: Add disabled BPF LSM hook list") for v6.6.y bring the new
> build warning for us, let your know that.
>
> and the lsm_getselfattr from a04a1198088a1378d0389c250cc684f649bcc91e commit
> ("LSM: syscalls for current process attributes"), I suggest that use a not
> upstream commit to just drop 'BTF_ID(func, bpf_lsm_getselfattr)' from 6.6.y.
> Maybe 6.1.y has the problem too.

Thanks for the report, I agree with the analysis.

> Maybe 6.1.y has the problem too.

Yes, 6.1.y is affected as well - the same backport of 21c7063f6d08
("bpf, lsm: Add disabled BPF LSM hook list") is in v6.1.178.

The impact is build noise only: resolve_btfids only prints the WARN and
carries on, the unresolved entry is patched as BTF ID 0, and 0 never
matches a real prog->aux->attach_btf_id, so the enforcement for the other
disabled hooks keeps working. I do not want to revert the pair, since
21c7063f6d08 came in as a dependency of 12091470c6b4 ("bpf: Disable
xfrm_decode_session hook attachment"), which prevents a reachable BUG_ON()
and does belong on these trees.

Could you post a formal patch for this please?

-- 
Thanks,
Sasha
