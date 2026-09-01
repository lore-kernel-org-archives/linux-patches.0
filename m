Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D6D3AB476;
	Tue,  1 Sep 2026 01:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788225724; cv=none; b=uIaToDw/yH96l/UXK0vko/YZ4P8MY12BhjfLJZQn9Hg2qmhknSETpvaJ7IYWSxTh3Vzo8W/YwStxjkROVFf46vXbFG/GjnvlgBM4tqXAWMSWo80WYuUFMOIJm9rg6ZeKorL+jCkOd3f92ehg4E4b6ynefcpqE+kUpwPSzW5bmGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788225724; c=relaxed/simple;
	bh=tHzZD3O7R3NttHBo++nhTPdfZmlJdmYZ6LFF5YO8Tq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Po1+szF3iAEyCXkqO1+tjzxTDTpnHfxlK6K1nPO/3mYPy2pooMQk7ire4/s4rdv/CCEkWIEcxvIafntzN5sQInDkluxO7HzVTnaJ0CXBVJzIhmz6JhcTR+iVgt/UApyvwc3uXV7V8je6HN9G/IMqrif/2QspxwsPn0Y0QtxJKqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkb3BxL9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkb3BxL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7D41F00ADB;
	Tue,  1 Sep 2026 01:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788225721;
	bh=LaD8XpEZBeu8V7Z29xxCrmpsCNfNXzLRsyTj+mDzlvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkb3BxL98Wkws8/pnseF5AyxEOAqy0frU47PupzV2dcrqRZvdnzvX6i91iD4LC0rp
	 RJUf99D0D3XyfqhT31seGh04yhiStUTyagngFrl7/l3UALBNHE9fEuDkmJPTBHfFu8
	 XN7kauTtl7BFaJzbPvrcrFwpYQ0t/F2Yq8sOkUFz1F0ANKje/q/nagHC10VqmCjcJo
	 HMX99loQ91qm/oacnKAoSj/AOXR4EoyCFtehd4LyECoGNnAeySYclOhTz2BwLNsUOJ
	 MKHbyuPr0XdTw4rxOYA8GmrVqe6KDcQ03GVyHBHpdB7U3CKRnDK7qT2J/aQKmbLXX3
	 rGBZdqSkfTuuw==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: Re: [PATCH 5.15 231/456] tipc: fix use-after-free of the discoverer in tipc_disc_rcv()
Date: Mon, 31 Aug 2026 21:21:49 -0400
Message-ID: <20260831-daily-reply-0005-tipc-timer-shutdown@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4c29af2c-2a84-4d7a-81da-9b7f97246432@oracle.com>
References: <4c29af2c-2a84-4d7a-81da-9b7f97246432@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The 5.15 backport instead has:
>
>         del_timer_sync(&d->timer);
>         call_rcu(&d->rcu, tipc_disc_free_rcu);
>
> tipc_disc_timeout() and tipc_disc_remove_dest() can call mod_timer().
> Unlike timer_shutdown_sync(), del_timer_sync() does not reject a rearm
> after it returns. A concurrent rearm can therefore leave the timer
> queued while the RCU callback frees the enclosing discoverer, allowing
> a later timer callback to dereference freed memory.
>
> The timer_shutdown_sync() API is already available in this 5.15 tree.
> Maybe we should fix with a downstream patch only ?

Good catch. Could you send the del_timer_sync() -> timer_shutdown_sync() swap
in tipc_disc_delete() as a patch against 5.15.y and 6.1.y backports of this fix
- f05b3f4c7837 ("tipc: fix use-after-free of the discoverer in
  tipc_disc_rcv()") on 5.15.y, 4da2ac774941 ("tipc: fix use-after-free of the
discoverer in tipc_disc_rcv()") on 6.1.y?

-- 
Thanks,
Sasha
