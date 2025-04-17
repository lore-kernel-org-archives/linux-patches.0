Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6686261388;
	Thu, 17 Apr 2025 17:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912616; cv=none; b=e94ufqL/cggoCDB2bRVdes2ojLWtFonvsQMIjRnQvKQ5oDozJxInd1XWGt/YdaGGbFhqeNp6WuqJmN/1Z27qMiFxi1nl0GT+ojnaYpajXW2he0ylKh390ZPgcFdqDgwlfzyYTFcBsCqn8zsdg1FsP9RkCbVk8uT2o4KQuMMvqXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912616; c=relaxed/simple;
	bh=cdaxvLcCCdJkJAo8TaWsTos73sb68ClCMueDdP+Jqwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXIFB6cRUsF6dv9zbEZIj0zkVUOYgZZsrv7tzTiQYVHdICyIxhW/w7R0YNPfaZEPOthXBjCgUcBMlPFmmN0uL4AMe+Yox+OlAM94qpJKMYZ9M29MxAjAFU4OOgAR3khTwFrLT3BJrnM4H9+apk4Kjb1AguxTxmuYXenAjRQqyc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMur/qLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMur/qLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444B1C4CEE4;
	Thu, 17 Apr 2025 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912616;
	bh=cdaxvLcCCdJkJAo8TaWsTos73sb68ClCMueDdP+Jqwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMur/qLNNTYdkaIpX1Lfjesyjbj4TvIrsqV3OJUUEalEE+V5V9VaiczD7+8yoIEwz
	 fHA0gFY8lVSzFz/lJhk+QYG9JAmRX2YcbqP2RYh5MIFoBbR8j+4jvi6hQYJfI9uCHg
	 MVmQeZb3S31Zwmy4NuHPWsJqj+2BtNJ4I9SfTkNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 040/449] ipv6: Align behavior across nexthops during path selection
Date: Thu, 17 Apr 2025 19:45:28 +0200
Message-ID: <20250417175119.604609712@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 6933cd4714861eea6848f18396a119d741f25fc3 ]

A nexthop is only chosen when the calculated multipath hash falls in the
nexthop's hash region (i.e., the hash is smaller than the nexthop's hash
threshold) and when the nexthop is assigned a non-negative score by
rt6_score_route().

Commit 4d0ab3a6885e ("ipv6: Start path selection from the first
nexthop") introduced an unintentional difference between the first
nexthop and the rest when the score is negative.

When the first nexthop matches, but has a negative score, the code will
currently evaluate subsequent nexthops until one is found with a
non-negative score. On the other hand, when a different nexthop matches,
but has a negative score, the code will fallback to the nexthop with
which the selection started ('match').

Align the behavior across all nexthops and fallback to 'match' when the
first nexthop matches, but has a negative score.

Fixes: 3d709f69a3e7 ("ipv6: Use hash-threshold instead of modulo-N")
Fixes: 4d0ab3a6885e ("ipv6: Start path selection from the first nexthop")
Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Closes: https://lore.kernel.org/netdev/67efef607bc41_1ddca82948c@willemb.c.googlers.com.notmuch/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250408084316.243559-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 169a7b9bc40ea..08cee62e789e1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -470,10 +470,10 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 		goto out;
 
 	hash = fl6->mp_hash;
-	if (hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound) &&
-	    rt6_score_route(first->fib6_nh, first->fib6_flags, oif,
-			    strict) >= 0) {
-		match = first;
+	if (hash <= atomic_read(&first->fib6_nh->fib_nh_upper_bound)) {
+		if (rt6_score_route(first->fib6_nh, first->fib6_flags, oif,
+				    strict) >= 0)
+			match = first;
 		goto out;
 	}
 
-- 
2.39.5



