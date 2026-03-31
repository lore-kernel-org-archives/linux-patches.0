Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C68329E4B;
	Tue, 31 Mar 2026 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974307; cv=none; b=e89Qi4uJ96X4QYSlAacS7x7OG4CRxrRlkFyYl+OUXIotuTaYoCP2tQ+hwfydd3JJg8aPQOPreX6nwPANcDWl+KfnuSUZ2AXxRGjBwt3TifrU3EB8nsUR4xBw51mlg/+zkUGMWThtsOpnM6ZJWVk3h+oE36vg5belqm96YAtGbDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974307; c=relaxed/simple;
	bh=5EwAz2imM/uMhZbXJCF142QAQ1CqHPdoQaTR8INBMZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZSH6HNC0ESk8SE86tcpjf01aDkVAUGUG4KFCJ3JYWCC1wcLcyxD2UYetGAY/v+pqxiT+4swjGoxWeb5atYv5hPtN+X+sbeiQc7/vy++RER535u1aWIvvMQLYfgP4k7Gigla6H/Cgk8jvQWE8uOuZUKdvyDu5lvXyuoUpRkC+sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFNRgKQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFNRgKQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE799C19423;
	Tue, 31 Mar 2026 16:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974307;
	bh=5EwAz2imM/uMhZbXJCF142QAQ1CqHPdoQaTR8INBMZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFNRgKQrnuZ6LrMLwa0zNmMSumf19f67w0XVhJZDUGjggihxsSLYnJaTbdExlc2ZW
	 jC0SmpRH7IuPlCxpoYjWNAuq2PM+Bz4FwQlfxT5q9DZT3yHvwwNhJBo77RJAmIelxU
	 ogQpqX0mxc8lVN58YHk9POjDczkD50cFYQlxUJAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/175] xfrm: call xdo_dev_state_delete during state update
Date: Tue, 31 Mar 2026 18:20:17 +0200
Message-ID: <20260331161731.002426997@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 7d2fc41f91bc69acb6e01b0fa23cd7d0109a6a23 ]

When we update an SA, we construct a new state and call
xdo_dev_state_add, but never insert it. The existing state is updated,
then we immediately destroy the new state. Since we haven't added it,
we don't go through the standard state delete code, and we're skipping
removing it from the device (but xdo_dev_state_free will get called
when we destroy the temporary state).

This is similar to commit c5d4d7d83165 ("xfrm: Fix deletion of
offloaded SAs on failure.").

Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 81e01cdc7a7d5..ca42c9b8cecc3 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2033,6 +2033,7 @@ int xfrm_state_update(struct xfrm_state *x)
 
 		err = 0;
 		x->km.state = XFRM_STATE_DEAD;
+		xfrm_dev_state_delete(x);
 		__xfrm_state_put(x);
 	}
 
-- 
2.51.0



