Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B06443B3F7;
	Mon, 14 Sep 2026 10:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789382251; cv=none; b=dlOApodXHPIB/S5145rR0LT1gMAMgLyanc5MorQ6nrm3YtzF2m5XufLEla8eMFJRPGubzZNb1T54acu03LI3b4feKZsjkFoDLU7/00DfhaphuSPCYgnO8JHoR16vuoL6YOq8dkzntJqkO1n9ZzCV9aPKgSg0WLVX7mJNyadcTnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789382251; c=relaxed/simple;
	bh=Q/IrkwYMTMmFRicPO1PKgg6aGMq/BUCup1NpUfqpkUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ix/u3ATIj8RfmtZ+eftqpscO+K20xOe+4Cr0uOlkviZZzG3131hI8u34khfC6ns1z0XpJ6mG80VxZAeJirm3ZQI7RDViUG73W+oJFI3Z+7FvJlV7ji1JGbmMV3jUqx8wbscgLe8pM2FGPbmefNxTAnrZUsc23RHjGWX9yrRxtFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKT4N3hk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKT4N3hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AD01F000FF;
	Mon, 14 Sep 2026 10:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789382250;
	bh=TLvJYvB7FF6yU2legDlKHmoK1osKfx+N6H5kFfyHnEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hKT4N3hk5Gg+FfjdmRtLcNNCy6CkVQsuCez9/bDFVYe5IDnvZub7vsiH6IPnK/1pv
	 hQ2sGtTaoe64vLvuqMeHJ18XXMFM3H/bvynzU41zVOOznR0E1qaLj8ZTE58e8rQTxn
	 zh+hXiDGyxZLhVrY6eys2Cfs+rYbRMc1ujaT5j/A=
Date: Mon, 14 Sep 2026 12:37:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and
 release
Message-ID: <2026091453-unwary-delete-b272@gregkh>
References: <20260912065526.833703348@linuxfoundation.org>
 <20260912065546.976652519@linuxfoundation.org>
 <20260913202907.3100-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913202907.3100-1-kmehltretter@gmail.com>

On Sun, Sep 13, 2026 at 10:29:07PM +0200, Karl Mehltretter wrote:
> Please hold this patch unless the applicable L2CAP hunks from upstream
> commit f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock") can also be
> included.
> 
> The connected receive path already holds chan->lock when it calls
> l2cap_sock_recv_cb(), so the lock added here recursively acquires the same
> mutex and blocks hci_rx_work.
> 
> I reproduced this on the exact 5.15.221-rc1 tip
> 0dce236725a538e8ddc0601eb0fb0bc43fc2c87b in QEMU with two linked virtual
> BR/EDR controllers. One normal 64-byte basic-mode L2CAP SDU triggered
> lockdep's recursive-lock deadlock report, left the hci0 receive worker
> blocked in __mutex_lock(), and was not delivered to the receiver.
> 
> With the two applicable f1a8f402f13f hunks applied, the same test received
> all 64 bytes, both endpoints completed, lockdep stayed silent and no worker
> was blocked.
> 
> The tested adaptation removes the callback's channel hold and lock, and
> adds channel locking within l2cap_conless_channel().

Now dropped from 5.10.y and 5.15.y as for some reason this is marked as
adep of something that is not actually in the queue.

thanks,

greg k-h
