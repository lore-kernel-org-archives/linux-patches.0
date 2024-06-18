Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F8E515A857;
	Tue, 18 Jun 2024 13:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716822; cv=none; b=nApivXcdht2PERopKIi3jNLTZ73czG4v7VkYpK0AFrdj5X5GPQxs6y1m0ES6osWo8to8IstRS9o0KqRQ9iDMfp1bdInTPjx0wydQmslZUsYXi7mNn32PXmcJHV326YJ2Wc5jcz+BZaoAP9pQYavYTHrnDm0ztmATOI9mJuVuLGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716822; c=relaxed/simple;
	bh=IT3/P5sE3tdjqOn/82ts5WZd7jH7cku38AQiyyhIUa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIZTGuIFDzgzSDH5LcUwOSmoxaklmilLL+ai7Hn/FbHAS0TkWB8vrjb9QMl9tHhzMayf3YiDKhGPVMKHh1SqEnPgxsDNsIyA/9OF9AOyC7YKCiwQvKLir8jTTF1skoIuYFFeQOYzxnyFUzYk+fgEfZKj2Shbx+Bari3JM/mjWg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JF2eUssZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JF2eUssZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6E7C3277B;
	Tue, 18 Jun 2024 13:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716822;
	bh=IT3/P5sE3tdjqOn/82ts5WZd7jH7cku38AQiyyhIUa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JF2eUssZzR2LuuceyqdcdDwq1TwwzqGLXdhS+W3TBG7eUjGQiFZphOxIvxjiu4DtG
	 PCIdn493I/IcFJbVsZqS7ZMjyg01xLxU7dnFeKd6kTSo7czwWHS9ofvnU/avhASrUj
	 hSwoFoukDFIwAiPvZJbQKijrFRL/J9V2jskoC9Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@idosch.org>,
	NeilBrown <neilb@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 757/770] lockd: drop inappropriate svc_get() from locked_get()
Date: Tue, 18 Jun 2024 14:40:10 +0200
Message-ID: <20240618123436.487195259@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 665e89ab7c5af1f2d260834c861a74b01a30f95f ]

The below-mentioned patch was intended to simplify refcounting on the
svc_serv used by locked.  The goal was to only ever have a single
reference from the single thread.  To that end we dropped a call to
lockd_start_svc() (except when creating thread) which would take a
reference, and dropped the svc_put(serv) that would drop that reference.

Unfortunately we didn't also remove the svc_get() from
lockd_create_svc() in the case where the svc_serv already existed.
So after the patch:
 - on the first call the svc_serv was allocated and the one reference
   was given to the thread, so there are no extra references
 - on subsequent calls svc_get() was called so there is now an extra
   reference.
This is clearly not consistent.

The inconsistency is also clear in the current code in lockd_get()
takes *two* references, one on nlmsvc_serv and one by incrementing
nlmsvc_users.   This clearly does not match lockd_put().

So: drop that svc_get() from lockd_get() (which used to be in
lockd_create_svc().

Reported-by: Ido Schimmel <idosch@idosch.org>
Closes: https://lore.kernel.org/linux-nfs/ZHsI%2FH16VX9kJQX1@shredder/T/#u
Fixes: b73a2972041b ("lockd: move lockd_start_svc() call into lockd_create_svc()")
Signed-off-by: NeilBrown <neilb@suse.de>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index 59ef8a1f843f3..5579e67da17db 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -355,7 +355,6 @@ static int lockd_get(void)
 	int error;
 
 	if (nlmsvc_serv) {
-		svc_get(nlmsvc_serv);
 		nlmsvc_users++;
 		return 0;
 	}
-- 
2.43.0



