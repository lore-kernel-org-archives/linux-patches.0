Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0DA189537;
	Tue, 30 Jul 2024 16:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358751; cv=none; b=HurqmJU+QosOr8TjGAfwTg2WyaF4/4MuCLDZrLFu7e4xnDftSd1VwzGAxpimMpbSZHhgKPTWwxYyY0uQCQ3+stwgkZN5FOQl1pPd4/b0tFJNXE2KlqLielnPGe5NzGDkP3OqQmon7z6ZeUwzX4BvrhczKhYK1BWLOr2IRHvaBR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358751; c=relaxed/simple;
	bh=dnBSZLiYe0rcJXblxn5NVVDXHhxucpBP9dXUfv99yLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2kiB5asgSHPgra9ekooUuK5TXxmP1XehyU/fGC12JYyKYi7wbHryMmKAwHdxPk8ig47pDseLgXGjVjX7no/xvnOGRiuR+E225WaZMUdHASrOMKwTyFtwAC936M+HmwgqTB76gJQ5OnPIVjHA1KlXGEfNx3QdW4OHVhnb2oL9vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFGUrDFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFGUrDFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABB6C32782;
	Tue, 30 Jul 2024 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358751;
	bh=dnBSZLiYe0rcJXblxn5NVVDXHhxucpBP9dXUfv99yLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFGUrDFvWwM3yNIkX/BELCAYjiOPpHzuyxq46o7Km8TKTFfxdyaUMcXbvqYYVtpEb
	 oGLCGJszw65DIS7Pd3+y0BCqpDvRsdbxKtGr6o96z1z8fUMrA7Owg1RDy7g0js/5kP
	 X0ys/Q59T6l5zKIDN0763V2EMM78eCQi9ax7zdp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 373/568] ipv6: take care of scope when choosing the src addr
Date: Tue, 30 Jul 2024 17:48:00 +0200
Message-ID: <20240730151654.441932644@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit abb9a68d2c64dd9b128ae1f2e635e4d805e7ce64 upstream.

When the source address is selected, the scope must be checked. For
example, if a loopback address is assigned to the vrf device, it must not
be chosen for packets sent outside.

CC: stable@vger.kernel.org
Fixes: afbac6010aec ("net: ipv6: Address selection needs to consider L3 domains")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240710081521.3809742-4-nicolas.dichtel@6wind.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1839,7 +1839,8 @@ int ipv6_dev_get_saddr(struct net *net,
 							    master, &dst,
 							    scores, hiscore_idx);
 
-			if (scores[hiscore_idx].ifa)
+			if (scores[hiscore_idx].ifa &&
+			    scores[hiscore_idx].scopedist >= 0)
 				goto out;
 		}
 


