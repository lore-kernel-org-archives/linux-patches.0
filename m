Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA2F1428FC;
	Thu, 13 Jun 2024 11:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278769; cv=none; b=Yg2v339P30vGDnW1mLz70vbkZ3yap4ygXxwxSWeJXCS1Es/sCbYKm80ElGNWmh0jVnfuhsG1LqSDLeB1kYKp0SaIw1vaOQDEGHXSi4LqugNN4HCVwGFdxYYe3uJBikV+f0+LIYNWw3duh6O07ksjGLSCwrLG2S4h41pyZNnug+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278769; c=relaxed/simple;
	bh=5gyRr9PIz23thwBVXpZdMYNOoHBehwpRNTHl/CC4LTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JepM9JpV58mAEmdbIL556c0aTzHyN3P5PAuZhLjOpzwC2CL9W3wg13YtGyZju5Kuvt5/MOsfITk644VGsHXIO9bkBdnQN+kXCDHy1iinQfgXZvBqRlZ152buggBQ15+sLUU6tG3sWBhr9hBRjUi97zxRjAI2Sn56fVWib4hd2S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy/Adc65; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy/Adc65"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008A0C2BBFC;
	Thu, 13 Jun 2024 11:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278769;
	bh=5gyRr9PIz23thwBVXpZdMYNOoHBehwpRNTHl/CC4LTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uy/Adc65qQxJxw6Qa5udwcT7LKJnQ5Xwq9YCzqY6zG3D6scSulfTfB13a8PPYAGhv
	 QE8sE1ojC4b79TeVcMKuqKCAUh3PyU4/OiV0wbYcxOJm26yrbvzZJhSu8fZcDGZd+k
	 vuQPyb2sYLftf+bdbnBfSZS/zkSVI3LyOEY1oaNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 064/213] ipv6: sr: fix invalid unregister error path
Date: Thu, 13 Jun 2024 13:31:52 +0200
Message-ID: <20240613113230.479831652@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 160e9d2752181fcf18c662e74022d77d3164cd45 ]

The error path of seg6_init() is wrong in case CONFIG_IPV6_SEG6_LWTUNNEL
is not defined. In that case if seg6_hmac_init() fails, the
genl_unregister_family() isn't called.

This issue exist since commit 46738b1317e1 ("ipv6: sr: add option to control
lwtunnel support"), and commit 5559cea2d5aa ("ipv6: sr: fix possible
use-after-free and null-ptr-deref") replaced unregister_pernet_subsys()
with genl_unregister_family() in this error path.

Fixes: 46738b1317e1 ("ipv6: sr: add option to control lwtunnel support")
Reported-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-4-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 9810ce81dee81..605d270d8c109 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -484,6 +484,8 @@ int __init seg6_init(void)
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 out_unregister_genl:
+#endif
+#if IS_ENABLED(CONFIG_IPV6_SEG6_LWTUNNEL) || IS_ENABLED(CONFIG_IPV6_SEG6_HMAC)
 	genl_unregister_family(&seg6_genl_family);
 #endif
 out_unregister_pernet:
-- 
2.43.0



