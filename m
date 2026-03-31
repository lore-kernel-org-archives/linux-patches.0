Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE563A1E8C;
	Tue, 31 Mar 2026 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976377; cv=none; b=P/2tgrLN++fM4imlVDEPzcS9SeRc/hxIGIFTHGQbdyW5yKGN/5UAF45nujmM83gf2t5BvlT6SqT4LMQPHJ44DHskqYfhE9p/GBXmJc8BE9KqogDRAABjfPq+qRQSWIbM0GVWDp9ABqD2C8OFntDgM6qTMJr2KURKTuo9p76KAts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976377; c=relaxed/simple;
	bh=VmTZLdz7sDVJgAxlPQp183jPVAKsrJO+07qrJgzmLn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPXCbeZUtlhhh2uWjSQq3HtTJStSPqlCcHLzEOIATVc3WHzdLulk1ALD48XVGPGNIcnUZfaF0ic47V285SJoweFaCFSgH8u5QOlap2ot6URU8/Mtld5w2xBvz1+Ne8Cv6trqT2xlTA+8oYjWHwH/2wg8UV830jdK6ZJ1FXvm3Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ypuxUcXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ypuxUcXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61857C19423;
	Tue, 31 Mar 2026 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976377;
	bh=VmTZLdz7sDVJgAxlPQp183jPVAKsrJO+07qrJgzmLn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ypuxUcXwC8LjqYnPpE6mmf8vbJGwBQzlY09fUR79g817uNZkvBX/LHoFUuOSIp6Ni
	 nh8ziHSIvYa8bBxdKQ7nJ5khbemZXOk1IVMvWb41taCkAf38EAQSisjKfV+blU1PhN
	 D8t/gnkRz2yD5nKfe7u7T6j7vaz510yVr9IOfdD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/309] xfrm: call xdo_dev_state_delete during state update
Date: Tue, 31 Mar 2026 18:19:33 +0200
Message-ID: <20260331161756.064482859@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 98b362d518363..a00c4fe1ab0ce 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2264,6 +2264,7 @@ int xfrm_state_update(struct xfrm_state *x)
 
 		err = 0;
 		x->km.state = XFRM_STATE_DEAD;
+		xfrm_dev_state_delete(x);
 		__xfrm_state_put(x);
 	}
 
-- 
2.51.0



