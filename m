Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92921E7C25;
	Thu, 30 Jan 2025 14:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247177; cv=none; b=SSqJtbFXT/TfNq8Vd0iesk+ArURg6Y4PIfqJSuxf7OlJ3Jxha9uL5hhEe7tbhM8lwP4B2agAdv3c0ha0EQN5EB8w1FJ4Sc77KEv83zlZkEMMseqX6cjusozE8BzLFZ/Hmp3ZJC+R1KUhsy9fjxeQAYWpyoZ8jl1TmSgVcRzcQqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247177; c=relaxed/simple;
	bh=bquP7pQfJklJtsvttCHnh7PcjPY9QKlenpNPUn8GX2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEXU2ShdNug8KA0tL2sCIGOLXLiotC/lSwHTUIiD9YJesH6TZpAiw5vLBLhQNHA7GvdcDP9f8Pwx8PyZHGmgcqo76YEwZIsqNgEJlQ0w7P8CfF7fpLkwNwgrA5Irx0ICZNNr4o9L0s44ZaAzc8TnaW/6wctcfLEZ3VypV+vvLzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrwdHr5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrwdHr5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DCCC4CED2;
	Thu, 30 Jan 2025 14:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247177;
	bh=bquP7pQfJklJtsvttCHnh7PcjPY9QKlenpNPUn8GX2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrwdHr5vfEQBEywGD2jasulVpAfCDT07tv80wHqdWKC7bqTZpBqzhWSeoIkLTIk1W
	 lJtateyIkj5YSLVUnLD7QX81iCv8NDsb4x+YwUcREsAajWbvDRjhHd6FNpqP/eENUC
	 +VZjqh3s6VmQTmNDggU4oRC5rLpVS5Cs9auDRmBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 109/133] fou: remove warn in gue_gro_receive on unsupported protocol
Date: Thu, 30 Jan 2025 15:01:38 +0100
Message-ID: <20250130140146.925714822@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


