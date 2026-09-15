Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A653CF217;
	Tue, 15 Sep 2026 02:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789437829; cv=none; b=dEqUqubHZ+J295qd6a+GiR4z/79/+jKuzL8pn9+rVO/BcFHN2WKM/PF8tdObtB6zek/bEhSe41cIU5PjxkW1BtT5yoG3WK2fDZYUIJn4i1lm/u15C9mYeS8dIbvAI9lrbkuIU+ZAzixvP+98fWi0ifRNosQl3aIr+Doq28CeT/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789437829; c=relaxed/simple;
	bh=XZliUDjIlV+uESp04ACHXemRcdXx/zvj1haR+q7n8wk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrEFRe5Yq3KhUGNngkLiFLs0AfbHy1MzreHCRnfW7kXhkzCBdFkcniWs1x9tmlPw6ch2yuNmfinmWFmThxUSZ44SFJCMie7mpO9E5yLuE0oxt97BgglendiO44ERpteRXZUNQWAoNYnHoIofpFKMyZqBHliccc8ZWyKn5JvfGmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I0iIIzQA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I0iIIzQA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63451F00898;
	Tue, 15 Sep 2026 02:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789437827;
	bh=/OH6Pa7R3GVNBqXa2u3d6yQ03bDvkdtW05VK5jG/7Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I0iIIzQAViLj1egDNj3MC5y4lqfINVk5xxSsu1pBu37PauIYebPs7nWhwlBpXB94N
	 PBCdFC0iYEjxEOKLNlWBB5qx7oFxESoOhifD8KJVx6Z5ZDLfLElxX+BnmlV33YW7hl
	 05wH/wFRC2QcUodQIkD3QJ5XEE6yw0n7auuWY2USxkscla9Hfv8V0TqQUenr4FScmd
	 szPKHph5lp+/kAwLjPtlHrSf+EyrB9sWQsb3BUuWrnMGz/53pBJ0wrFCqek/I6CTDa
	 UnuE4pOtPwMv0lod/5bnb608S9ORncqDp/Qz8nDHZ9f1DxcsW6SdhXLBIK71FREc8V
	 t7L1e0IbadmTA==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Edward Adam Davis <eadavis@qq.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.15 879/935] bluetooth/l2cap: sync sock recv cb and release
Date: Mon, 14 Sep 2026 22:03:24 -0400
Message-ID: <daily-reply-0008-re-l2cap-recv-cb-deadlock@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260913202907.3100-1-kmehltretter@gmail.com>
References: <20260913202907.3100-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please hold this patch unless the applicable L2CAP hunks from upstream
> commit f1a8f402f13f ("Bluetooth: L2CAP: Fix deadlock") can also be
> included.

Your analysis matches what I see, and thank you for the reproducer.

There is no way to bring the upstream fix to these trees, though.  f1a8f402f13f
("Bluetooth: L2CAP: Fix deadlock") touches include/net/bluetooth/hci_sync.h and
net/bluetooth/hci_sync.c, and neither file exists on 5.15 or 5.10. Its own
follow-up 87be7b189b2c ("Bluetooth: Fix usage of __hci_cmd_sync_status") is
unlandable for the same reason. So the only options here are hand written hunks
or leaving the recursive lock in place.

Separately, while looking at this: both 5.15 and 5.10 carry c531e63871c0
("Bluetooth: l2cap: always unlock channel in l2cap_conless_channel()") without
its prerequisite, so l2cap_conless_channel() calls l2cap_chan_unlock() on a
mutex it never acquired.

-- 
Thanks,
Sasha
