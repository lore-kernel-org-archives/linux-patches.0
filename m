Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18B28F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46539C433C7;
	Sun, 16 Jul 2023 19:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537325;
	bh=6tfKpFk38z+lIxK0i8bKaBeo3sURUowwR5b+MUjuYC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1tyCwLLmjmJkPRRcrEx7XOgcEN/4mCcEjiF4e2re/6bq1VT2VTrYIn5ZRZW3jy57
	 rlejjBVPXglIjnGeV/3tpWNjYAdFzYEPzwiol/jfClS5XWH16gcEUbTya6Pyx+zQRs
	 EJZ3SN3mUID9INk15NZiBx+b/BWkvwDpw5Ei+5mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@idosch.org>,
	NeilBrown <neilb@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 028/800] lockd: drop inappropriate svc_get() from locked_get()
Date: Sun, 16 Jul 2023 21:38:01 +0200
Message-ID: <20230716194949.752884443@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 04ba95b83d168..22d3ff3818f5f 100644
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
2.39.2



