Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8486FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:29:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61D9C433C1;
	Wed, 30 Nov 2022 18:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832986;
	bh=pc4BtaUrD98jt9H/7KGSKKaWznqoptWwvMgCmmOT+A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tm1sb+qghxZZ0+6Ur1kCWhy/hXrLz0VG9upRXb6zNYu57WuUC9WaEPdUg48EuecEY
	 1pJG9083hGC0V3/If/LVhORIB3fXHiwv4bQJ72Y8+LG98QZcUgg0mIl61kMsBh2cY5
	 C9UZs0w0E8YJFUSb9y1BjhiDCusHwqG+t/7W5PvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/162] ceph: fix off by one bugs in unsafe_request_wait()
Date: Wed, 30 Nov 2022 19:23:12 +0100
Message-Id: <20221130180531.497679959@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 708c87168b6121abc74b2a57d0c498baaf70cbea ]

The "> max" tests should be ">= max" to prevent an out of bounds access
on the next lines.

Fixes: e1a4541ec0b9 ("ceph: flush the mdlog before waiting on unsafe reqs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 5bd76b8de5b7 ("ceph: fix NULL pointer dereference for req->r_session")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/caps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 2fa6b7cc0cc4..f14d52848b91 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -2343,7 +2343,7 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_dirops,
 					    r_unsafe_dir_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds > max)) {
+				if (unlikely(s->s_mds >= max)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					goto retry;
 				}
@@ -2357,7 +2357,7 @@ static int unsafe_request_wait(struct inode *inode)
 			list_for_each_entry(req, &ci->i_unsafe_iops,
 					    r_unsafe_target_item) {
 				s = req->r_session;
-				if (unlikely(s->s_mds > max)) {
+				if (unlikely(s->s_mds >= max)) {
 					spin_unlock(&ci->i_unsafe_lock);
 					goto retry;
 				}
-- 
2.35.1



