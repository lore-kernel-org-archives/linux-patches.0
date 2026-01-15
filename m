Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392A72750ED;
	Thu, 15 Jan 2026 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497109; cv=none; b=KtCjUB73LmE4KREUR/QBq9R23YuZCB8mEL5DiGJcZGj8OY8eXLfH0mdtj0E4I4znGy6R6FHgbLRB/BTDT/ssAhaxnCI/cpbaowRhR3HWnjvV5SdFKUxKJ8e6kGzTTwOwN4k5vZ0LJpor6rdM8AdRuedYOVbOsCfX6JJb7FO9SB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497109; c=relaxed/simple;
	bh=aEbeb3aZVUCxJSZ7yw06vBbUeqWnKhSnad7h7zPqZTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4Xn962aaFsdKE7CiIRee5EfTzcSUDuoNDQFWNSwzRdRcShZIfzReLMDlO29jrvfbHlQ6VELWyU/p54seQAQhyUyNjAl6ZwOhAqZYVfmZ4MfcUG+/T1pJSTlfENlE6oOOKMifzD5Cuu5tpo7ZnJoxP+mMtr1oXxIESt8loEUgzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRYc7b9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRYc7b9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5C08C116D0;
	Thu, 15 Jan 2026 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497109;
	bh=aEbeb3aZVUCxJSZ7yw06vBbUeqWnKhSnad7h7zPqZTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tRYc7b9OUyTtGVvwub3T5ojW+R3WGWwRtKQDp8i3z8WwmXhQYcg8XdV8Ps/sPIZbm
	 GgBpzxp4v3AHSJi7wqeEQAn0P5XTeamdJrTwfW3BJ4OoMMqyU/NHWj2lWdVP5f/MoN
	 11N+FQ8nR0YcMywMy7d1uLoTpXa25gGyIMZTEC1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yuan.gao" <yuan.gao@ucloud.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 39/72] inet: ping: Fix icmp out counting
Date: Thu, 15 Jan 2026 17:48:49 +0100
Message-ID: <20260115164144.911527798@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: yuan.gao <yuan.gao@ucloud.cn>

[ Upstream commit 4c0856c225b39b1def6c9a6bc56faca79550da13 ]

When the ping program uses an IPPROTO_ICMP socket to send ICMP_ECHO
messages, ICMP_MIB_OUTMSGS is counted twice.

    ping_v4_sendmsg
      ping_v4_push_pending_frames
        ip_push_pending_frames
          ip_finish_skb
            __ip_make_skb
              icmp_out_count(net, icmp_type); // first count
      icmp_out_count(sock_net(sk), user_icmph.type); // second count

However, when the ping program uses an IPPROTO_RAW socket,
ICMP_MIB_OUTMSGS is counted correctly only once.

Therefore, the first count should be removed.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Signed-off-by: yuan.gao <yuan.gao@ucloud.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251224063145.3615282-1-yuan.gao@ucloud.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ping.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 5178a3f3cb537..cadf743ab4f52 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -848,10 +848,8 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 out_free:
 	if (free)
 		kfree(ipc.opt);
-	if (!err) {
-		icmp_out_count(sock_net(sk), user_icmph.type);
+	if (!err)
 		return len;
-	}
 	return err;
 
 do_confirm:
-- 
2.51.0



