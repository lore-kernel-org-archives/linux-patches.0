Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA67944684F;
	Mon, 17 Aug 2026 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979984; cv=none; b=IS7WjOxL1JjDdcjIPbvCx3mK/iSOSJC5nIXDrL2S0Xga5QWiHwZtknalLtMP1Z3QGUVlj4qu/t+BOYoOaKHdOeXd2QG/hR7fSpvjz6iOoFFWCtSaZKX6yxEA80ZWG5Oqo/OWBcBfVD2t8++4DXUuagcbei6y4ZQmkx1Om8TZ2Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979984; c=relaxed/simple;
	bh=V6R70vKiJNjiAMVx5archAv+ktdEvxJ9OSpWYLxLlkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf0nyCg1q8IiF9EH6gRkBZcvs6FRHP+1mlBS7ff5F841mdZlyrGHYNpXl4bjFaroRjkJi5yyou8Wc8NysJ4sTOHGONlr3NfPB8osUxAog6Zbt6unIJytNfnQHAHjGxBuQNALqlbvmFTROT3KtjXXFllgYmJ1Kes3G0uZ7cALsLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tI3LRkLs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tI3LRkLs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249381F000E9;
	Mon, 17 Aug 2026 15:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979982;
	bh=loRONd3V+ZxYVmY+4r2Yl1/7+EBAUGUrgmrnNgwFiGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tI3LRkLssKLHlztDLqkpr1DvdlZ6AwH2JBLkotvvztiqn34RBFkUfEHKB8uLpkyfo
	 kDASQPT8esIVHpyZTRL7uC7RK5NV9txfZ6dokuokeprFlB8S9frmhHQbiXKDuGro4o
	 Kd0I91dSvSEe8N14640XegaQ5KnvzRhuJ5XVMkqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 416/609] net: ipv6: clear suppressed fib6 rule result
Date: Mon, 17 Aug 2026 15:31:52 +0200
Message-ID: <20260817132558.056960855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

commit 6aea62e433fe1b586202a5fee8b5807ce635e1d7 upstream.

fib6_rule_suppress() drops a suppressed route with ip6_rt_put_flags(),
but leaves res->rt6 pointing at the released rt6_info.

If no later rule supplies a replacement, fib6_rule_lookup() still sees
res.rt6 and returns that stale dst to its caller. A suppressing rule can
therefore leak a released route back to rt6_lookup(), and the next put
hits rcuref_put_slowpath() from dst_release().

Clear res->rt6 when suppressing the route so suppressed lookups fall
through to the null dst instead of reusing the released one.

Fixes: cdef485217d3 ("ipv6: fix memory leak in fib6_rule_suppress")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/4b8acb7787d54e440155585dd32ebdf0bef7d122.1784710966.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/fib6_rules.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/fib6_rules.c
+++ b/net/ipv6/fib6_rules.c
@@ -301,6 +301,7 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_s
 
 suppress_route:
 	ip6_rt_put_flags(rt, flags);
+	res->rt6 = NULL;
 	return true;
 }
 


