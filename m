Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8B848986D;
	Sat,  1 Aug 2026 02:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785551952; cv=none; b=oeTX2v03fEUMzXuJcloZnjo1GZ9hkqJ2m70KGA7AuoWmnzgtdIaMG0sfYo1f90AIFcJWlghfb0Ie+daxPFhM/xOQAEGZX1tR9n01V1RuIvYpkRBslSu6P1bnoY45fGKngBeDjQwghczhW9ceKDMgTw6GNy8+Z4UJ6W6LvSzSXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785551952; c=relaxed/simple;
	bh=FtzpyV+t1kW50IR8J+q5lPkUrEkJP7XrivXzD4uQis8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wj2obi5jC1gpKtoapNI8n1CSnJYty3TX8X77IGsyqvY60eU0+a/YFP4oSyepMXxXvoWTRqMMGmOaGmJIVsWrMOfYNFCcXa18LkSxq08hOOdpNaGn5LNSRpS9hqc1MgEefZo1nPGHa0IPEXPuUoiR7fe172ElyL7JhYVBiD2oC+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xu8ub+DP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xu8ub+DP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209C81F00AC4;
	Sat,  1 Aug 2026 02:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785551951;
	bh=XDLI6YcIcO+uBPI/uvr9bG676fcdssaScFO++CLA5nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xu8ub+DPjdykny8oG85y67kfLJyCgxWbdILdoVM9CBuOTXR1TwxagMVNlfBmHWicN
	 dH9PiWIzxZt8BJ6P2HzKhbSTSAiXlTe+qHSEvgJ3BR+oKGHVeegBE4QHu/T2biGlWO
	 B77j/cI+4ah0z1HbjH7H2hz89fCoQuw+vFJwpWPsBVNVEUwwBBoogB9B25540A/0mn
	 X8DlOhhDNqKfzSA6ZCWRqEPmXR2oe+XV2NQZ+G5P5vooHka4JF13BIaFOksDNG7rXJ
	 1N8ly1q2/gRBGm8rsoQgMCvQy+1LUDo75FToiKO66n+8TOv+cU8xK1ctN5/EtnnmHP
	 v0Eo2wMOjiK2Q==
From: Sasha Levin <sashal@kernel.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	vegard.nossum@oracle.com
Subject: Re: [PATCH 6.12 469/602] i2c: davinci: Unregister cpufreq notifier on probe failure
Date: Fri, 31 Jul 2026 22:39:07 -0400
Message-ID: <20260731223023.7d4a4ed464940f55@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <88a84d94-8c1a-4ec5-b985-f5a7b2e29b26@oracle.com>
References: <20260730141435.976815864@linuxfoundation.org> <20260730141445.818442273@linuxfoundation.org> <88a84d94-8c1a-4ec5-b985-f5a7b2e29b26@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, Jul 31, 2026 at 10:40:53PM +0530, Harshit Mogalapalli wrote:
>I think this backport is incomplete; I think route both GPIO failure
>branches through err_cpufreq:

Both IS_ERR() checks are inside "else if (dev->pdata->gpio_recovery)",
and nothing sets gpio_recovery in either tree - dead code.

They also used "goto err_unuse_clocks" before this patch, so it's a
pre-existing gap, not a regression. The patch fixes the
i2c_add_numbered_adapter() leak; dropping it is strictly worse.

And since b04ce6385979 deleted the block in v6.14, there's no upstream
commit to backport for the rest.

Thanks for the review.

-- 
Thanks,
Sasha
