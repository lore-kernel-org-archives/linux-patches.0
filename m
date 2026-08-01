Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD862931C7;
	Sat,  1 Aug 2026 14:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785594022; cv=none; b=bI3mI5XADQbeMQ1lceWq5kLL59RzOoLTuJVQEapNh/QfpvDkRUCR6SYaEYhRXatZi21w5Ok1FoYvbgHch/TDhCXce2bpEua6CFyVwngM1w72QsgEOXdPM1wYKTNzGWIxVafSC8LOx3HQCdYOYRVKL0TJypqFsLBleuBKMKeZa5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785594022; c=relaxed/simple;
	bh=xpnj6wC8h5/QCW0aYUwJ2pZK0GXW7CDAJjVc7QI1evU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGPwbcDKu0vy9Q/zndofNLbnPVF5z5YXvIHkfu1sZn+ZswSI2PaSumGHB0lgkRLXsmLKu/FoHxvhpANCbKXBWW77k5ckOfG0A7pCCwWYMZSKDFcNp+bO5YK+zh0mMO1TAhXnsVeJn1lC0pycLGXzJx77R8LBUlE7hT1DZO0mxME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BiLvGpGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BiLvGpGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE541F00AC4;
	Sat,  1 Aug 2026 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785594021;
	bh=ZGzqtJTAQVj3UiL8UDAlVrMJtLh1W963GASY87LM1hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BiLvGpGdYhr/BxVA2RZ2KcLwtpjt5UF0O7vBVjaHOEfJhqSNvUfSW9bxN8Lzd+YG8
	 rIqcGIm9X6PV0fNRYDHPgVGgS0+LQN/IeR4nY+ko+EuwarTBLNtVDeYvj5HSnvmYQa
	 aik1sKsNlLZ0w3cq/+01qVIro2654/sJti+QO5qvWAv2v06HKXPR1ZMvb4UlxKgh3u
	 hxO8yMy9zGtbr5rFQlrw7IbHLwRvnwMrvJ/Jpt0+O9HP2UBN8rx4y7epLWnLGs3lpA
	 NJxtQ55oSz2gJbPaIpNAMtD+nBgxP14hGMhIqk2BdMyit/ArmU2mVgzzCFrQr86Vcg
	 uV0rL9lSYGqhw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	vegard.nossum@oracle.com
Subject: Re: [PATCH 6.12 513/602] sunrpc: allocate a separate bvec array for socket sends
Date: Sat,  1 Aug 2026 10:20:16 -0400
Message-ID: <20260801101505-810831fa989d@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <6006a83d-d1a5-46c3-a501-9d31b27204bb@oracle.com>
References: <20260730141435.976815864@linuxfoundation.org> <20260730141446.781523139@linuxfoundation.org> <6006a83d-d1a5-46c3-a501-9d31b27204bb@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, Aug 01, 2026 at 09:57:48AM +0530, Harshit Mogalapalli wrote:
>The 6.12.y backport instead allocates sk_bvec unconditionally in
>svc_setup_socket() with kcalloc(RPCSVC_MAXPAGES + 1, ...), including
>for permanent TCP listener sockets.
>
>I do not see a correctness issue here. So I think this looks like an
>acceptable 6.12.y adaptation, even though it does not preserve the exact
>upstream allocation policy.

I think I agree with you, and the divergence is intentional. 6.12 and 6.6
have neither svc_sock_sendpages() nor svc_serv_maxpages().

>I don't think there is anything to fix, but would like to double check,
>thoughts ?

Nothing to fix, the patch stays. It's also a hard prerequisite for
18c1cc698861 ("SUNRPC: Return an error from xdr_buf_to_bvec() on
overflow"), which is queued immediately after it in all three series and
patches the exact svsk->sk_bvec call sites this one introduces.

Thanks for the careful review.

-- 
Thanks,
Sasha
