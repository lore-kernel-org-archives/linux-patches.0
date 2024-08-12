Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC7616D9B8;
	Mon, 12 Aug 2024 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480241; cv=none; b=Qwjlo30yXIjgFIU0Kf8/GrLBu6Dawsme+JW2lmSV6ZU3l3d3A/Z9oOchVD/IWoH/QOlyDho1pAAg/8TPHEo1PsCjNo3rwHGxVeGVyIZP/uv1UmuoE91v20CV2tTSlC6jCDxsTZSAkJuymFpEVy42wHoKQjHAqe04uHbZObXcxhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480241; c=relaxed/simple;
	bh=kzREYptvXYI6XyPosbct001zxYa0ooDKAXbKBhCVK+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fq+txIZSR+QTeNXrKw0jxfsR8IAujIKSx9GylwcyxT+lkP4RjeyMtJJClmNNtQTRA8lcavemXEt6QwhTJ/p77qt4bfgRKSg6S3nC8vonXr5WRPW3AQyutf4s1DTTcctYS4mf/u0JvQ09VMTXN3W9q5U3COXMbDvz/tdE3TUNEKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppMFm/DF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppMFm/DF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E79C4AF09;
	Mon, 12 Aug 2024 16:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480241;
	bh=kzREYptvXYI6XyPosbct001zxYa0ooDKAXbKBhCVK+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppMFm/DFmvEk+or4s98o2D3w6W96LBD25zKyjFelz7OvzQ/egq8V2GS2PhwG3pF5z
	 A8bIE8Nz7CeZSXZStbQxIDNKrrIL8NncGKfKXAKtnL1lmbmSUCzrh1jYmm9wZBrsyq
	 D+myOv36c+YIDp8VElxSVhS4GNb3tUggNYWAHYRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Dickson <steved@redhat.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 137/263] nfsd: dont set SVC_SOCK_ANONYMOUS when creating nfsd sockets
Date: Mon, 12 Aug 2024 18:02:18 +0200
Message-ID: <20240812160151.792983243@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 91da337e5d506f2c065d20529d105ca40090e320 ]

When creating nfsd sockets via the netlink interface, we do want to
register with the portmapper. Don't set SVC_SOCK_ANONYMOUS.

Reported-by: Steve Dickson <steved@redhat.com>
Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index c848ebe5d08f1..0f9b4f7b56cd8 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2053,8 +2053,7 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 			continue;
 		}
 
-		ret = svc_xprt_create_from_sa(serv, xcl_name, net, sa,
-					      SVC_SOCK_ANONYMOUS,
+		ret = svc_xprt_create_from_sa(serv, xcl_name, net, sa, 0,
 					      get_current_cred());
 		/* always save the latest error */
 		if (ret < 0)
-- 
2.43.0



