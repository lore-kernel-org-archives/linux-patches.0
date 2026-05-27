Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926E83B19BB;
	Wed, 27 May 2026 19:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911358; cv=none; b=foc62orVQZlLmkIbZrwdtIigPu7SA3uPDKRcrCfrUvikSqGmxjq3PExX3K79RTYtL/K6sVikHH6QkVRHIxbKFxXoCpzWY6rXEVsDSdQXjEcKOM/h5WviOaE894Ilr1WDw32h+9Ul2inB1hSK/+CFt59WArXRJqs7zL/d4vB0zJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911358; c=relaxed/simple;
	bh=5GJFHkrSa+bxpqoV/I+Z7s+0/NL7EyQrEZSwD+hHdHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKLjO64IeO4kzb91Fo3tNWs7GN5AAXMRVk37fvCRk+8QQQ+ogne9TxFcE7itsT9hVwI+4iJWp3G/likdNZYS1/exJVAX9/t/UniHSwyc6p1P0GkvwBFhp5gpjt6g/NmqDBxMdRCPJXDOcoQkUjmG5rxFmbJHa+4nFJ43HHjqZZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V9bjadob; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V9bjadob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5071F00A3E;
	Wed, 27 May 2026 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779911357;
	bh=5GJFHkrSa+bxpqoV/I+Z7s+0/NL7EyQrEZSwD+hHdHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V9bjadobAk10i/uj2JHpqUqhCCu2pvRx9IfnZTpMRgTdp6iGkM17GBP75KnicUA8j
	 iKni3PmnWx/OWJJgV63j68CFCf98EYVTpuaXgrh5KowjXB72AuNs71qSjJY3rQRKJb
	 NcMQ9wYkt/otSylgwsKrApkZeV7QhaHtYG2EMdxbrTq9w6Ksz0hFWzqdL4g43U5H6h
	 XKUN+Cq0y46hC0CvnXM3LLGkYsit7lQ815+IxjqsRkMRp2+XWkEchOkzAYbW8MB5WZ
	 ufZDtXcafvR9vYeTDOUu0TBxa75ZYbOvASx91KahcP4e/+Siw5fGb7SzYVmFq54LuU
	 V4C3pTiYoieXQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Alice Mikityanska <alice@isovalent.com>
Subject: Re: [PATCH 6.18 648/957] ice: Remove jumbo_remove step from TX path
Date: Wed, 27 May 2026 15:48:57 -0400
Message-ID: <20260527-agent5-item003-ice@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAD0BsJXt3QurRvFmOGNzh1juYYcQEst=3aYJmHiCCf-4DCZCVw@mail.gmail.com>
References: <20260520162134.554764788@linuxfoundation.org> <20260520162148.582539866@linuxfoundation.org> <CAD0BsJXt3QurRvFmOGNzh1juYYcQEst=3aYJmHiCCf-4DCZCVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Sorry for the late reply, I see it's already applied. This commit
> depends on "net/ipv6: Drop HBH for BIG TCP on TX side" (part of the
> same series [1]). As far as I see, this dependency was not applied to
> stable trees, so removing this step from the drivers is not correct.
> Either this commit should not be backported (reverted), or the entire
> series can be backported, if eligible. This consideration applies to
> all stable trees.

Thanks for catching this. Reverted 8b76102c5e00 on 6.18, 6.12 and 6.6.

Because 8b76102c5e00 was pulled in as a Stable-dep-of for 1a303baa715e
("ice: fix double-free of tx_buf skb"), the double-free fix was reverted
on these branches as well (it would otherwise conflict). The branches
now build cleanly, and 1a303baa715e can be re-backported once a version
that does not depend on the jumbo_remove change is prepared.

--
Thanks,
Sasha
