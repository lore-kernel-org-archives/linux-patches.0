Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C373D3CE9;
	Thu, 15 Jan 2026 18:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500034; cv=none; b=H4uTJphCu3x+Layd52+5x7Tmqczv+VGPOC/6IrOZD0DaNPqFTWZ8L1tlIwFvkmhauuNxu6uNCBxfhkHaCzFsdz/OrWk0g38SwcX5FyuoWZV/FdYWHj3r12HWNcaekd7Ejnm8uwlufju5xrVf/4jnB33eqFS7uHIODbvzzdLUkSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500034; c=relaxed/simple;
	bh=vri/PdgoNLmYixWIrj4qIlwn71uLrq4iBZ8c2m4prPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJTLwCwV6URWglo4boUJg8HxpQiLXxEKYn3KZ4BSQxAQ6INXYZjEPrZ7DzXKeURGe0B9OdNjVsqq/nQ6cpEkfe5SR1vGw2s/M1156Jpe0sp5O4q1tUV7LvINElwA3s9jyYNSvLl/bHI5OlIrxveMeiEewUTyD8zqwoB64GQ809c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4/Z72KU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4/Z72KU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575F7C116D0;
	Thu, 15 Jan 2026 18:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500034;
	bh=vri/PdgoNLmYixWIrj4qIlwn71uLrq4iBZ8c2m4prPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4/Z72KUkPw/VrhDYouCrFCKw/4x615lOHNg1E55JQMGlLtbP3TT0jWj+pK0RR5YW
	 PNc1tWyl7CwZ5bwRSS45qziR1mjOrh3VYYJDXnA6vRSuzzvdIFAWG7wNzd5lCHbzZp
	 mo4ES7MbiDS6+s0DipwtNqKAv9L/kElU+XBO8k+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yuan.gao" <yuan.gao@ucloud.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/451] inet: ping: Fix icmp out counting
Date: Thu, 15 Jan 2026 17:50:36 +0100
Message-ID: <20260115164246.683301680@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1bad851b3fc35..69612770006e2 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -842,10 +842,8 @@ static int ping_v4_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
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



