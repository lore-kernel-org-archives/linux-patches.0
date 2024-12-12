Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4058A205501;
	Thu, 12 Dec 2024 17:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023551; cv=none; b=b29zGkY4QHBQDlk8T7tYB2PGZd7EvTELGmEs+1uiL8WMcnXoalSZGazUPGVEtCWQak1A7L5NdGrMPvnQQnsQX8lPKd7oULRPyH29VZo4Mks8MgEQgEGh1sZwn6Mvb/RBEgssu65JqeW4DGzZlSbj7EGmGSpFsok1XTAffTU8GoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023551; c=relaxed/simple;
	bh=eL7vu4UMtqu8S9yOH7e4B96cH94JlR+RMhbFHQQQeA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctkBjombdT/qojkao5UwFjSVmZnicK6MlcxiuB1tcWybko0zmLkvne6/3bYFXB2GB+PXha+U4iq3+UW1ag/JCsu89NTo80Tc/QgXf8H/5jbpfShtrIH0WhtSHGxW4qsugZalHTMHHtbfOo4Wg420rrbdcEFDYcmHH4/UO/sA9Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY8vL8qP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY8vL8qP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF947C4CED0;
	Thu, 12 Dec 2024 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023551;
	bh=eL7vu4UMtqu8S9yOH7e4B96cH94JlR+RMhbFHQQQeA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY8vL8qPKdTt+0St4WDKhpsnEuoxu43JdU8uwY0JU+bSyf1Bhkr1w7skLOksKpdlA
	 p7XDSyU78twGWS33pcI/PHIaB1uA2hziF29mt447W4lf++d1/Uoib1T4+SNgb8BbvW
	 jU+KBfd9YmRynASNXIXEuAXQZkgdFo5vd3FnwyhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Libo Chen <libo.chen.cn@windriver.com>
Subject: [PATCH 5.15 552/565] fou: remove warn in gue_gro_receive on unsupported protocol
Date: Thu, 12 Dec 2024 16:02:27 +0100
Message-ID: <20241212144333.677176813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Willem de Bruijn <willemb@google.com>

commit dd89a81d850fa9a65f67b4527c0e420d15bf836c upstream.

Drop the WARN_ON_ONCE inn gue_gro_receive if the encapsulated type is
not known or does not have a GRO handler.

Such a packet is easily constructed. Syzbot generates them and sets
off this warning.

Remove the warning as it is expected and not actionable.

The warning was previously reduced from WARN_ON to WARN_ON_ONCE in
commit 270136613bf7 ("fou: Do WARN_ON_ONCE in gue_gro_receive for bad
proto callbacks").

Signed-off-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240614122552.1649044-1-willemdebruijn.kernel@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Libo Chen <libo.chen.cn@windriver.com>
---
 net/ipv4/fou.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -453,7 +453,7 @@ next_proto:
 
 	offloads = NAPI_GRO_CB(skb)->is_ipv6 ? inet6_offloads : inet_offloads;
 	ops = rcu_dereference(offloads[proto]);
-	if (WARN_ON_ONCE(!ops || !ops->callbacks.gro_receive))
+	if (!ops || !ops->callbacks.gro_receive)
 		goto out;
 
 	pp = call_gro_receive(ops->callbacks.gro_receive, head, skb);


