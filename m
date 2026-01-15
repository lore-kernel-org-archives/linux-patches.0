Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C05274B43;
	Thu, 15 Jan 2026 16:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496159; cv=none; b=IBfPvi3LwwFtylImLM4MVKGc8vRld1mF+X1T8+GTbm0a3ffMlGt2G1PDkMD9jyg5Re/Kjgh4zgkNXo8K8HPdKrlLjOttKpvlnIj8weDU8H5R001yMx6rG6gL4AXH99kxF4H/nROqXrd5uIRe3aDGUe12FKAfMiCaXE1KqbejHrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496159; c=relaxed/simple;
	bh=keBG3HCdBXJpCM+/y8xvirT8Yfa+56FZlZ1DfAZ12dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKE6o6PwOysSH1irZYSqZu2eD4AgpS+a1rb8KHvij3l4wwJGY9Krb/fGHmdQC3sZxWsAL3/gH7NL/UvA7kDiW1QronjIzz7Zjvi2bonpWSAi5qejfrPoMPpJthE4/zf2fS+MpKEd4tn6kw0vdQQ1F5YyGK8f26wijl2F/yAS1D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JrEomM5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JrEomM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B36C116D0;
	Thu, 15 Jan 2026 16:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496159;
	bh=keBG3HCdBXJpCM+/y8xvirT8Yfa+56FZlZ1DfAZ12dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JrEomM5EFrWtr7dmmqUR9Y7augvuAup+HRNRX3KJli8MX/s5fu8uODOEtVLluAiV
	 7Gt1wcz1Jdeir+5IwctUu4T7f5kozvHKuoKGRsdDF+GnItF0RUuEGKv9G23azZcThY
	 JPDCH+g45JP0gT85hVLqc24CdlMbmer2IJgDTu5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yuan.gao" <yuan.gao@ucloud.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/181] inet: ping: Fix icmp out counting
Date: Thu, 15 Jan 2026 17:47:15 +0100
Message-ID: <20260115164205.858364225@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5321c5801c64d..a5227d23bb0b5 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -828,10 +828,8 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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



