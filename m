Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B5A7E0FF;
	Mon, 23 Dec 2024 16:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970341; cv=none; b=ZtNWrrbwZFYgx/J/Nfm6Mv1K8FRcdIOLbLKKobD1m287Xe/26Ll+8UA6yLOE98vCfaN2U/8pZQ7pC5rQLOeSLFF4D1A5WUwdgzVCENHDjRp5xb+SkOZo5Df47PVT6Ro5T0eFUPgJMMvRCcLye4sI31H7P/3H+/o/AgPKeE0lHzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970341; c=relaxed/simple;
	bh=0vDYUxYqNi02bJfYltoxueq+4EEssjmD0n+AtcSbV3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmWzfm8xUPGsNC+j6wRFjVTM1yzdy6G9YWiDa6gswePLXqV3zaf9kWgT16vKPf6QFH8EST+2+zD/eXimzr43n5D9KES7T2AmqLDoj+EuZfVw+2LreWu2wZ9K9fnz3SMZ25jHRxm7gkdscxfpzcX6EbMevQ8WjvagfUHOehc4NAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j3A7tGv/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3A7tGv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42701C4CED3;
	Mon, 23 Dec 2024 16:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970341;
	bh=0vDYUxYqNi02bJfYltoxueq+4EEssjmD0n+AtcSbV3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3A7tGv/seWbj41fmEcpVdnrLw+W8AQ89teMMrULHsuaXmB6hsX9jUiWsK7KBp+Yj
	 8najEjzR6+3MvE+s1pr/pikkGZ9zNOTygp9mRtNA8nSkZRAUaz2KB2VL99vHnRDDJ1
	 1Xm9B+Pp3XGTxnbTw8NWpoPZlmyNK71zhvDh20Qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	David Laight <david.laight@aculab.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/116] ipvs: Fix clamp() of ip_vs_conn_tab on small memory systems
Date: Mon, 23 Dec 2024 16:58:44 +0100
Message-ID: <20241223155401.664994726@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
References: <20241223155359.534468176@linuxfoundation.org>
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

From: David Laight <David.Laight@ACULAB.COM>

[ Upstream commit cf2c97423a4f89c8b798294d3f34ecfe7e7035c3 ]

The 'max_avail' value is calculated from the system memory
size using order_base_2().
order_base_2(x) is defined as '(x) ? fn(x) : 0'.
The compiler generates two copies of the code that follows
and then expands clamp(max, min, PAGE_SHIFT - 12) (11 on 32bit).
This triggers a compile-time assert since min is 5.

In reality a system would have to have less than 512MB memory
for the bounds passed to clamp to be reversed.

Swap the order of the arguments to clamp() to avoid the warning.

Replace the clamp_val() on the line below with clamp().
clamp_val() is just 'an accident waiting to happen' and not needed here.

Detected by compile time checks added to clamp(), specifically:
minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/all/CA+G9fYsT34UkGFKxus63H6UVpYi5GRZkezT9MRLfAbM3f6ke0g@mail.gmail.com/
Fixes: 4f325e26277b ("ipvs: dynamically limit the connection hash table")
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: David Laight <david.laight@aculab.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 9065da3cdd12..8182833a3582 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1494,8 +1494,8 @@ int __init ip_vs_conn_init(void)
 	max_avail -= 2;		/* ~4 in hash row */
 	max_avail -= 1;		/* IPVS up to 1/2 of mem */
 	max_avail -= order_base_2(sizeof(struct ip_vs_conn));
-	max = clamp(max, min, max_avail);
-	ip_vs_conn_tab_bits = clamp_val(ip_vs_conn_tab_bits, min, max);
+	max = clamp(max_avail, min, max);
+	ip_vs_conn_tab_bits = clamp(ip_vs_conn_tab_bits, min, max);
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
 	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
 
-- 
2.39.5



