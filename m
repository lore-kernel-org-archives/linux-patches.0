Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDF93DFC7D;
	Tue, 31 Mar 2026 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974899; cv=none; b=HE4vfwuz9HLIZ96Pu8iVocH94Uou8X45fpglJ45/qupM8j10g6yvB279h0G31RD8GCzBuJsNRMsPKdun9Kqls83rGB+AMKbSdby4oU0dBVjUvJ3zwFD4AyroiUiuEoYT+EO2BA//PxfNmkUfqS3L4PWxby4wFbQIKWXIKEwGs4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974899; c=relaxed/simple;
	bh=iezaEJNXceF08QeCsWj4hffWewsyvmgWPOEW87Bn9WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5gd9Pg0mfXbmJFjU+Eli+SulzzECGO+FbPsnBxI4yvVoaiKYHUll4pIFOzG3WEDzV2DSHXcqqB+bi0ZzHjABETgvA1/jO424RQDg9dWfbrRcbKBmxFyNfvntXWlnGxJ7oR+5Bl0ryYOThNws/M5SzluGVLZNLMeO0Om3xlGAJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KkYWs+8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KkYWs+8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7413FC19423;
	Tue, 31 Mar 2026 16:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974899;
	bh=iezaEJNXceF08QeCsWj4hffWewsyvmgWPOEW87Bn9WY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkYWs+8X1UlJw7OR0aI2+epDdMKf+CXkWouyui3MgjnCoCX6GFUGKRZlFaWHd6u6v
	 k9NcWX2X7T+UbhEU2Nlo+8eA7bZ/MY7bIQM4PDIH4ey4aQxsFGDnf1KUkNzzLuYYyB
	 +jp6WL4r+DrsJ6WLjJbTvboM2VQcd+AmCTyq2aJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 086/342] xfrm: Fix work re-schedule after cancel in xfrm_nat_keepalive_net_fini()
Date: Tue, 31 Mar 2026 18:18:39 +0200
Message-ID: <20260331161802.186642202@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit daf8e3b253aa760ff9e96c7768a464bc1d6b3c90 ]

After cancel_delayed_work_sync() is called from
xfrm_nat_keepalive_net_fini(), xfrm_state_fini() flushes remaining
states via __xfrm_state_delete(), which calls
xfrm_nat_keepalive_state_updated() to re-schedule nat_keepalive_work.

The following is a simple race scenario:

           cpu0                             cpu1

cleanup_net() [Round 1]
  ops_undo_list()
    xfrm_net_exit()
      xfrm_nat_keepalive_net_fini()
        cancel_delayed_work_sync(nat_keepalive_work);
      xfrm_state_fini()
        xfrm_state_flush()
          xfrm_state_delete(x)
            __xfrm_state_delete(x)
              xfrm_nat_keepalive_state_updated(x)
                schedule_delayed_work(nat_keepalive_work);
  rcu_barrier();
  net_complete_free();
  net_passive_dec(net);
    llist_add(&net->defer_free_list, &defer_free_list);

cleanup_net() [Round 2]
  rcu_barrier();
  net_complete_free()
    kmem_cache_free(net_cachep, net);
                                     nat_keepalive_work()
                                       // on freed net

To prevent this, cancel_delayed_work_sync() is replaced with
disable_delayed_work_sync().

Fixes: f531d13bdfe3 ("xfrm: support sending NAT keepalives in ESP in UDP states")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_nat_keepalive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_nat_keepalive.c b/net/xfrm/xfrm_nat_keepalive.c
index ebf95d48e86c1..1856beee0149b 100644
--- a/net/xfrm/xfrm_nat_keepalive.c
+++ b/net/xfrm/xfrm_nat_keepalive.c
@@ -261,7 +261,7 @@ int __net_init xfrm_nat_keepalive_net_init(struct net *net)
 
 int xfrm_nat_keepalive_net_fini(struct net *net)
 {
-	cancel_delayed_work_sync(&net->xfrm.nat_keepalive_work);
+	disable_delayed_work_sync(&net->xfrm.nat_keepalive_work);
 	return 0;
 }
 
-- 
2.51.0



