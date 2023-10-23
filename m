Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A431640B
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jxpHW+xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DC5C433D9;
	Mon, 23 Oct 2023 11:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061316;
	bh=cDMc2o9eofNcoIErJEvzrHBQefibJo8DUS55DHV0kKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxpHW+xvrgqXpCly481WyeGwRPq8yTmsvYnfNFwnpEoGySEV2IWG7O1sQL8tjCHTJ
	 w80re/czzzjnHruyhvtKbUBviErvEI1HJ/ZsWF+mS7KKJ6HUAyCXTVxWJSYkBQ9KpV
	 xT7KbuUV7sm+s+JBekV3D7X4Ja66qyN9D8OHpMqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Xin Long <lucien.xin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/137] xfrm6: fix inet6_dev refcount underflow problem
Date: Mon, 23 Oct 2023 12:58:14 +0200
Message-ID: <20231023104825.293800344@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit cc9b364bb1d58d3dae270c7a931a8cc717dc2b3b ]

There are race conditions that may lead to inet6_dev refcount underflow
in xfrm6_dst_destroy() and rt6_uncached_list_flush_dev().

One of the refcount underflow bugs is shown below:
	(cpu 1)                	|	(cpu 2)
xfrm6_dst_destroy()             |
  ...                           |
  in6_dev_put()                 |
				|  rt6_uncached_list_flush_dev()
  ...				|    ...
				|    in6_dev_put()
  rt6_uncached_list_del()       |    ...
  ...                           |

xfrm6_dst_destroy() calls rt6_uncached_list_del() after in6_dev_put(),
so rt6_uncached_list_flush_dev() has a chance to call in6_dev_put()
again for the same inet6_dev.

Fix it by moving in6_dev_put() after rt6_uncached_list_del() in
xfrm6_dst_destroy().

Fixes: 510c321b5571 ("xfrm: reuse uncached_list to track xdsts")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/xfrm6_policy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -120,11 +120,11 @@ static void xfrm6_dst_destroy(struct dst
 {
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 
-	if (likely(xdst->u.rt6.rt6i_idev))
-		in6_dev_put(xdst->u.rt6.rt6i_idev);
 	dst_destroy_metrics_generic(dst);
 	if (xdst->u.rt6.rt6i_uncached_list)
 		rt6_uncached_list_del(&xdst->u.rt6);
+	if (likely(xdst->u.rt6.rt6i_idev))
+		in6_dev_put(xdst->u.rt6.rt6i_idev);
 	xfrm_dst_destroy(xdst);
 }
 


