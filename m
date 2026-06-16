Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A6535292A;
	Tue, 16 Jun 2026 18:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633975; cv=none; b=QxL961WW7LgPFNZYjXk8iRrxDyYzLLR69sV+Vic+pQHk2rYAAwM3O6Ka2fjO5lvDdEMhJiUTzkTw6u4YSTASEwyWzpzM5p9szIhJu4mK/MWv/YplCaK0O6P3xPkHABwCa3bVPnrXf01v954D98n+iZU14WfVQHyJ9tZJ5rIQUwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633975; c=relaxed/simple;
	bh=7tOE+TDCYFkxF0dXyuG0BA7b1se+pBBKAH5skS+YpxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNUAWmzlpD9zEggTCcHrsmHANH7PgaQKZGqSdehbdaK0SfZR4G0u8o6lQkblReuG1WOrX/ksl1XDS7EeAOmCFOqoXgwNsjnlLdDotv+UXf7IYyZa/X7ocs/KRsWAIBRIOAR6N0B4osI67GPO8wzn+0Qj2ZNZD/cNcqzPK6EhbAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY/aC8+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY/aC8+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AC31F000E9;
	Tue, 16 Jun 2026 18:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633974;
	bh=ckOEMVNMsN6j9N2636h1L6V6NRELlZvWOlUB6VPzI7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY/aC8+XNXXgNIkVaY/PDpAmYB7tNjFw4aYBqtximrTKQBYRA6dlJp46pDxW4awNg
	 5vtCrOo6yZBPCESdgJHzCSoe8CpqEDj5kbq5A89mCBAgqSATXJPedCroCbLgQvc6jb
	 WhXX0mWvFZlaMinWMdcewwvJFj5RCigxu3x3XNic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/411] tun: free page on build_skb failure in tun_xdp_one()
Date: Tue, 16 Jun 2026 20:26:56 +0530
Message-ID: <20260616145110.142181045@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit aa8963fdce667a42fb7f0bdd2909fadcab02f9a8 ]

When build_skb() fails in tun_xdp_one(), the function sets ret to
-ENOMEM and jumps to the out label, which returns without freeing the
page that vhost_net_build_xdp() allocated for the frame. As with the
short-frame rejection path, tun_sendmsg() discards the per-buffer error
and still returns total_len, so vhost_tx_batch() takes the success path
and never frees the page. Each build_skb() failure in a batch leaks one
page-frag chunk.

Free the page before taking the error path, matching the put_page() the
other error exits of tun_xdp_one() already perform.

Fixes: 043d222f93ab ("tuntap: accept an array of XDP buffs through sendmsg()")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260521163312.1479805-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
(cherry picked from commit aa8963fdce667a42fb7f0bdd2909fadcab02f9a8)
[Harshit: Backport to 5.15.y/5.10.y, use err instead of ret, no change
needed]
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/tun.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 803cb4722dbf4a..aad0760c8d92b7 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2468,6 +2468,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 build:
 	skb = build_skb(xdp->data_hard_start, buflen);
 	if (!skb) {
+		put_page(virt_to_head_page(xdp->data));
 		err = -ENOMEM;
 		goto out;
 	}
-- 
2.53.0



