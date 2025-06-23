Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EB9222576;
	Mon, 23 Jun 2025 22:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716857; cv=none; b=pJT3a6a/oAoZLjU4BxArllAViwLbLR+xACBmNjbYY5b0svS2E8MH+EpEd3xCZC353eyrn+rS/kMbGp0kPWZqePinTSbE0kTGcj/78xx06ocf6oqT+UToCn9kFxRmHaGYpvuFQqB9IgEtZZVBATozileEba/iiF4UfptLpFA/yno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716857; c=relaxed/simple;
	bh=401bkhnEdqCZBTUgD4GpZT9o6NbNWqQWxQNg/28yCD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1XUWPUyOQI1nsMtxX0QlRZVVOaEATvTQWvK8qRV9wJE0jUuexNtB1UCB9eWqpvgbp/hBwTpagKg7CiljE4MZWCQ5Kear1vmU7Fj81+jyQ065EtAExMdPf+g288WOA9huXuYWA7nfn3K2uR7DTvzi82V1PRUdUu8xQCYZ0rnDN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RN9Z4qb9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RN9Z4qb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7B0C4CEEA;
	Mon, 23 Jun 2025 22:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716857;
	bh=401bkhnEdqCZBTUgD4GpZT9o6NbNWqQWxQNg/28yCD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RN9Z4qb9bnJRrM+r7qHdHzfUCUOCfnzP0mmOtJhszS2n5eL954EUYAQtAcMjsRWNm
	 AY6/27K64f5oKl2cv5blKSUiGdwhDFYBWnwMpd5lYwzJuil5eN/ZkOHEGGos+HJLPw
	 YmS7KlnmEEebGeobtRafUmaqHIpMAmku3aFJcut4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Meetakshi Setiya <msetiya@microsoft.com>,
	zhangjian <zhangjian496@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 563/592] smb: client: fix first command failure during re-negotiation
Date: Mon, 23 Jun 2025 15:08:41 +0200
Message-ID: <20250623130713.833420593@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhangjian <zhangjian496@huawei.com>

commit 34331d7beed7576acfc98e991c39738b96162499 upstream.

after fabc4ed200f9, server_unresponsive add a condition to check whether client
need to reconnect depending on server->lstrp. When client failed to reconnect
for some time and abort connection, server->lstrp is updated for the last time.
In the following scene, server->lstrp is too old. This cause next command
failure in re-negotiation rather than waiting for re-negotiation done.

1. mount -t cifs -o username=Everyone,echo_internal=10 //$server_ip/export /mnt
2. ssh $server_ip "echo b > /proc/sysrq-trigger &"
3. ls /mnt
4. sleep 21s
5. ssh $server_ip "service firewalld stop"
6. ls # return EHOSTDOWN

If the interval between 5 and 6 is too small, 6 may trigger sending negotiation
request. Before backgrounding cifsd thread try to receive negotiation response
from server in cifs_readv_from_socket, server_unresponsive may trigger
cifs_reconnect which cause 6 to be failed:

ls thread
----------------
  smb2_negotiate
    server->tcpStatus = CifsInNegotiate
    compound_send_recv
      wait_for_compound_request

cifsd thread
----------------
  cifs_readv_from_socket
    server_unresponsive
      server->tcpStatus == CifsInNegotiate && jiffies > server->lstrp + 20s
        cifs_reconnect
          cifs_abort_connection: mid_state = MID_RETRY_NEEDED

ls thread
----------------
      cifs_sync_mid_result return EAGAIN
  smb2_negotiate return EHOSTDOWN

Though server->lstrp means last server response time, it is updated in
cifs_abort_connection and cifs_get_tcp_session. We can also update server->lstrp
before switching into CifsInNegotiate state to avoid failure in 6.

Fixes: 7ccc1465465d ("smb: client: fix hang in wait_for_response() for negproto")
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Acked-by: Meetakshi Setiya <msetiya@microsoft.com>
Signed-off-by: zhangjian <zhangjian496@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4193,6 +4193,7 @@ retry:
 		return 0;
 	}
 
+	server->lstrp = jiffies;
 	server->tcpStatus = CifsInNegotiate;
 	spin_unlock(&server->srv_lock);
 


