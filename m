Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4933D19DF4C;
	Wed, 23 Apr 2025 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419795; cv=none; b=Y/TV8C1SBmG414IY1y0mRUmht8rt2hiBpEhS4hq8trgBOjwMLDRFFeQ+2X1j5/b3Vpo4rkY7FX5cY0MXeoZgHtZTH6VQAB+hyRcQfcgtV20ow92KhYSchiGDCxQZO4wVwxkiemsVDMtontdx2aMYynkY8GUnCQhPRorJVZTJG/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419795; c=relaxed/simple;
	bh=ff9ccShpa+kvHkbHOQHpbHoG0y9cDcypt3/SrxH67FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8OqfJQHnjpJ8RtW4pVH5/2jxf2lsbdtEuR32Rn55bXEGgLV/Vs9iS4peBJDXtvrFFzT/0RCmBT4pj0OLR95WXaH29eIl7PHE/Q3mJD4B6iUPar3y6Sy9NTY/QrQkoNh6Okeay+Y7VWafgnB5qj4I/C+pAj1vba/L8ewLHnVR7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b2a3Apt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b2a3Apt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF72C4CEE2;
	Wed, 23 Apr 2025 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419795;
	bh=ff9ccShpa+kvHkbHOQHpbHoG0y9cDcypt3/SrxH67FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b2a3Apt6qFN/dHVJ/dedXxrFx7HxatgCgWcgMpAgCmVRZj1eKQoEt8R1WQ4WBGXqb
	 D7yNktvvEoYo6fnaxPIiL+G5E57BZY9pMYrsjCt/nTNkws6bpFBfbcDPFErwVzZxQv
	 E4f5n57oaBF3JsQokSyV2E9r+mgAVoKmDrMPg2EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 028/241] ipv6: add exception routes to GC list in rt6_insert_exception
Date: Wed, 23 Apr 2025 16:41:32 +0200
Message-ID: <20250423142621.667120678@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit cfe82469a00f0c0983bf4652de3a2972637dfc56 ]

Commit 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list
of routes.") introduced a separated list for managing route expiration via
the GC timer.

However, it missed adding exception routes (created by ip6_rt_update_pmtu()
and rt6_do_redirect()) to this GC list. As a result, these exceptions were
never considered for expiration and removal, leading to stale entries
persisting in the routing table.

This patch fixes the issue by calling fib6_add_gc_list() in
rt6_insert_exception(), ensuring that exception routes are properly tracked
and garbage collected when expired.

Fixes: 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list of routes.")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/837e7506ffb63f47faa2b05d9b85481aad28e1a4.1744134377.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 08cee62e789e1..21eca985a1fd1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1771,6 +1771,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	if (!err) {
 		spin_lock_bh(&f6i->fib6_table->tb6_lock);
 		fib6_update_sernum(net, f6i);
+		fib6_add_gc_list(f6i);
 		spin_unlock_bh(&f6i->fib6_table->tb6_lock);
 		fib6_force_start_gc(net);
 	}
-- 
2.39.5



