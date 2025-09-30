Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA3D1F152D;
	Tue, 30 Sep 2025 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244710; cv=none; b=QKiY+IQ7fNHy5J1LUYsknDvhrQ/kbCXtL3Q7tD5vAkQD5LKQ+aXYJ9JvPXqYyWNYS5PfgOQA0dlipT8HnbeOxix6SgDTftyQPAOpFE79GCKPzNimfaln7GZJuzU6SKtTSS7awDkrBkBN45ZNKuwQUAFnDl1G3FMxxxNCQ9Fx+vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244710; c=relaxed/simple;
	bh=ydZ2E5Xye4n0LVRgsIzQG9/xkaZ54mPN0fAN2LgcGBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qk7j2aLvx7zOj3Kds757aQUF9Y+wNM3KX8KpLkiJcJmFQae6In3QP2qd4IHyDs8bRuXJIH6pUt2GrdmtlpNfHDt9a8rGXTQWzWV6dzXwj/5/X0II+GkfHuCHx7rEt+Lif4BFnp9A//Wt4iM1ZYwFBEyHzUUH5Vm7/AL8il29m3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pLC7ZDW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pLC7ZDW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47567C4CEF0;
	Tue, 30 Sep 2025 15:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244709;
	bh=ydZ2E5Xye4n0LVRgsIzQG9/xkaZ54mPN0fAN2LgcGBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pLC7ZDW+005zPufT0mucbSq0VNAWu7oEJgYgCN/RpefrcQibpTb/jeijcWm35TrFO
	 91dFKwv3JVNhYwAL4xs2criuK3b5WFt0Gumq0VC0p900FdYVCd0Rv9T0BRdxI5dcn5
	 MLVe+yYyYg5hBxya8XtAL2rttiHRvR8HrmDypCC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a25ee9d20d31e483ba7b@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 058/143] xfrm: xfrm_alloc_spi shouldnt use 0 as SPI
Date: Tue, 30 Sep 2025 16:46:22 +0200
Message-ID: <20250930143833.541305076@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit cd8ae32e4e4652db55bce6b9c79267d8946765a9 ]

x->id.spi == 0 means "no SPI assigned", but since commit
94f39804d891 ("xfrm: Duplicate SPI Handling"), we now create states
and add them to the byspi list with this value.

__xfrm_state_delete doesn't remove those states from the byspi list,
since they shouldn't be there, and this shows up as a UAF the next
time we go through the byspi list.

Reported-by: syzbot+a25ee9d20d31e483ba7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a25ee9d20d31e483ba7b
Fixes: 94f39804d891 ("xfrm: Duplicate SPI Handling")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 86337453709ba..4b2eb260f5c2e 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2578,6 +2578,8 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 
 	for (h = 0; h < range; h++) {
 		u32 spi = (low == high) ? low : get_random_u32_inclusive(low, high);
+		if (spi == 0)
+			goto next;
 		newspi = htonl(spi);
 
 		spin_lock_bh(&net->xfrm.xfrm_state_lock);
@@ -2593,6 +2595,7 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 		xfrm_state_put(x0);
 		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
+next:
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			goto unlock;
-- 
2.51.0



