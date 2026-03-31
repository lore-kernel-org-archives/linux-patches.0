Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D7E423A99;
	Tue, 31 Mar 2026 16:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974882; cv=none; b=eS/8HIxQG2yUPPo5PHyE6l4tu9nzXMYaezX4hauwUCUNw9SrfJKBZ8Xkt7eN9lwdy8DMeQAw59OdSiZaNjTk7tY27NFuN3gl8Ty67UqeeP8+dqmygHSN4avVfWFW6kQYUDkcL978KcmR/dCrI9xl/pBiwj43X0gT+ACWMvQ5Adg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974882; c=relaxed/simple;
	bh=C4GD7M4EKN+kCQTlKns8LfBqJSvXtfPtpgJLGEP/RWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hctv1zsBAuBDY/zFgXaPCOklebHzCttoxfWLVlQ8X1AQKOPpOugkHomt1YZbTLMPe5Br2mhkz0fgfCd3xsqUM87IE8JdfAvhc8VV5EUsf5pGNWtlaua1DsjbdFgkXNDQWDacEAW+feZAYtsOUz+09B1+4ThL044afTtZn0URt78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hfZzT0l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hfZzT0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A0EC19423;
	Tue, 31 Mar 2026 16:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974881;
	bh=C4GD7M4EKN+kCQTlKns8LfBqJSvXtfPtpgJLGEP/RWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hfZzT0l9Ut9m2bVCPApdqQYLaAjW+UI99TzjeG2xSKapEVP101BShk8/outhCe/A
	 9dooqwt6KnenQiTIkF0Iy0FaW7xlTl1WFJebt1ELuj8FVf4Dd6hxR6P2TKu8shVJrP
	 OQw0v+/1y4Jjqa0WaH2s7vF8iMkCoR2fbGPNREa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 080/342] xfrm: call xdo_dev_state_delete during state update
Date: Tue, 31 Mar 2026 18:18:33 +0200
Message-ID: <20260331161801.833806181@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



