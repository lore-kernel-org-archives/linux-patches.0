Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27ED1330B1F;
	Fri, 17 Oct 2025 15:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716411; cv=none; b=hOC8fztOt1y24bukr9C8NrU6X3aCds6hjat/5aBHNnVLOwXVNyq/1d0Y73pouRm5ksvbGgKUijF8HapyvgMCnoQTcLVgpLwJ2yj3mbc+YoAGaabZTfceIhzHnXVMaHFefEy4aLfsDuYVxRr1D9LK/69BbW6groZisNIBMd5ii/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716411; c=relaxed/simple;
	bh=b7V0KUifPXVhl2cLin2edyVU8QHkRD8jEzNCA9Dm0zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpwvxw8iXZJOg7z/Jw17kslvdTGkChtdtJe6c6PBVPZwphp/upL2ewfrOB1flWhgfzlKCBQ3Rc7jCbvGmBIptm2csB0S7vnQlKS37Yvq8fK/AnbIxjoHR2tqdQ+N01pMKW7rsWiX/8LpxkH8EuDnNDD9kqVh4Uzood1AyJs3lIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BftHGoZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BftHGoZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A34C6C4CEE7;
	Fri, 17 Oct 2025 15:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716411;
	bh=b7V0KUifPXVhl2cLin2edyVU8QHkRD8jEzNCA9Dm0zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BftHGoZb5FbTr4SC5iZozI8Y5cUXKhW6V/GuHlOoWCqZkcuCrGF5zkBX22d2al4Jn
	 w4HlPEyhoXtG02hnqIg9VkvfoB9LB89AYS4eKqQN0G/cXvX/jwIFpsfC8EMnafWBIJ
	 GeNFxoxMBeicIZnZC4YHdOTRVCBIiQ/tqfsQDalI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr Sapozhnikov <alsp705@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/276] net/sctp: fix a null dereference in sctp_disposition sctp_sf_do_5_1D_ce()
Date: Fri, 17 Oct 2025 16:54:02 +0200
Message-ID: <20251017145147.919428915@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandr Sapozhnikov <alsp705@gmail.com>

[ Upstream commit 2f3119686ef50319490ccaec81a575973da98815 ]

If new_asoc->peer.adaptation_ind=0 and sctp_ulpevent_make_authkey=0
and sctp_ulpevent_make_authkey() returns 0, then the variable
ai_ev remains zero and the zero will be dereferenced
in the sctp_ulpevent_free() function.

Signed-off-by: Alexandr Sapozhnikov <alsp705@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Fixes: 30f6ebf65bc4 ("sctp: add SCTP_AUTH_NO_AUTH type for AUTHENTICATION_EVENT")
Link: https://patch.msgid.link/20251002091448.11-1-alsp705@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/sm_statefuns.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/sm_statefuns.c b/net/sctp/sm_statefuns.c
index b5f5ee233b59d..5a883bd722f5d 100644
--- a/net/sctp/sm_statefuns.c
+++ b/net/sctp/sm_statefuns.c
@@ -880,7 +880,8 @@ enum sctp_disposition sctp_sf_do_5_1D_ce(struct net *net,
 	return SCTP_DISPOSITION_CONSUME;
 
 nomem_authev:
-	sctp_ulpevent_free(ai_ev);
+	if (ai_ev)
+		sctp_ulpevent_free(ai_ev);
 nomem_aiev:
 	sctp_ulpevent_free(ev);
 nomem_ev:
-- 
2.51.0



