Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DD037C117;
	Thu, 15 Jan 2026 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496671; cv=none; b=qxssAKfLTI+WUMS+P2nb0IscK+sN6GwTIp6vcVK/mw34X1PdQ5qeyJ61PjqWJgoMOB17f23VgcTmvftgvdRaskfE1HuraK3TJt1hBuYuBmvLHrBCSnkzP0B8hxcHDHPZ97LewIbF+O0SoK6544C+aFsKkaQewYQpfVI2wc3pkT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496671; c=relaxed/simple;
	bh=p0+H77m1G+OOcY+PxMfPLvLL+L0XtXIISAVN9u5rx1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T63Q/BlfSy1p7cyRuTM0uFZ1UZ+Pm2FnLSZMn4KhqO4y7AGU35rqFWD/gbWHjVVv9sVyVWCWs4fepQtFdVthrbIvXXtNJUD9FIWbwgIW+sR1QrJ1+EgAh44VflSTRrVRyJX+6LT8bxXfq96x6GTBqoSOE6MZiVrRHuOQ196aErE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tH5u1D8D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tH5u1D8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19ECC116D0;
	Thu, 15 Jan 2026 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496671;
	bh=p0+H77m1G+OOcY+PxMfPLvLL+L0XtXIISAVN9u5rx1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tH5u1D8DDVI/6HclnJl2QPIyKkpA4yLKDu4nWcwMNwnHLDSr62cLzXfnKnVdbPBah
	 Xp3Yr0Nt41ofDgBfkI5yWdFWCuXXx+MLmDzHq/G9zSsjvTWaf9xImJTUWie5xDyTEa
	 xfvxqA+0vmE9dNOmCUmyr6TRk+oZDP9unVwSz/lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yuan.gao" <yuan.gao@ucloud.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/119] inet: ping: Fix icmp out counting
Date: Thu, 15 Jan 2026 17:48:02 +0100
Message-ID: <20260115164154.371549209@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 37a3fa98d904f..f62b17f59bb4a 100644
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



