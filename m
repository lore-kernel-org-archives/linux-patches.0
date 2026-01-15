Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CC733993;
	Thu, 15 Jan 2026 17:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496892; cv=none; b=GK2IAkTrrDxiv4YugRi6MNayJFG5d/oRNO8z+8fD+myu1yoE4ZIHnuxtNCCM6cfhznrC+iSg4aJn4pKct8q6IZ5Jb+ITtlYAwKr3T1uKGAznFWEbHxbrF/PxZgO5RBicsKB3qbEvI5xd7AmoEWlPKKfkC0BJb93pgcZzn/B/rP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496892; c=relaxed/simple;
	bh=sXFCOfEcZJQ+uWFcKQPSIzIK99/dLo+HpUN+MznfeWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l57b7tbqT443YKJGD7KVHV7ktP3+nYYSFz1Hamr+qSc20OGrzGDPTm8jAS0hvjb7GH8rCayRgyC1U7lv5G8ZewkwPxk9I7YF9bIGBtBlHUEWr9HgEr7ekr0UxAO9iHXwWebck/gbdwG2cqeCI1Wo8yl129fVi4h55XNo6LnbyUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BalrG59Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BalrG59Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C95C116D0;
	Thu, 15 Jan 2026 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496892;
	bh=sXFCOfEcZJQ+uWFcKQPSIzIK99/dLo+HpUN+MznfeWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BalrG59ZOARwkXcxJmTQd5uU+s8X/3zZerhYIGzfG26Jj94LKKeqsGLuwJsoedXeN
	 22lpOUC/JprMSFaI9cY5N39mkP2nWJcS3+JVixAXi61KQQUNDDl87ECT1eKoczMY2n
	 KlE1n3XzM7Pbgvk3fdBQZTDinA3v8sU27PXYt6W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yuan.gao" <yuan.gao@ucloud.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 53/88] inet: ping: Fix icmp out counting
Date: Thu, 15 Jan 2026 17:48:36 +0100
Message-ID: <20260115164148.233877307@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5c848136bc266..47f2e7dd554ad 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -839,10 +839,8 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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



