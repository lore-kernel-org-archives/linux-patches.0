Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393353E0C5F;
	Mon, 17 Aug 2026 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976137; cv=none; b=QkD/iOQ0U4WIiaCwQjjy/gvYBAshoSRacD9E2LNHK2ymUsrzNpMLLOpcbTr/THa/udgB8iU6Lqi0iQ2j5Zu0pRPABc2X569G5kHCadcOJqU5V+R3aAQYJe2QmNnj29Jr605STTF/9h8+9IJjiZRyce8Q+/i+g45iG4mb96keS6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976137; c=relaxed/simple;
	bh=8It+jVi00QthE1/qvK8xSL3pQjueQejAd4CoubkTdro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSt3Z34V0ekSW8e4w+jRsqMUSC4yEgEuo1jzjsBIhmMmpmIo7s1cj4nhamd53xlnD5HPZE/tEDhUEHGmFMmYE3B5AHkHaJ8fYzmIbgk/SfwhSKX81WIzIQmogvzkb1CDWrpnPMyK0O+RJUPGoRG4gSAJFFydk1037WKgpEwIy24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMKsP0KI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMKsP0KI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546A21F00A3A;
	Mon, 17 Aug 2026 14:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976135;
	bh=orjA8sBKI5vOV/ZJJvLx3auj7e7jU5IakrwdVMQ1SK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KMKsP0KII4z5y4No/0Fjqb2zyqD+cNI6UJ6EukQuhnpxt7Ns3HFvhRsG7Na0FetV9
	 SD/LAbtAJATZL6iN85yHAiqw/aYD+fr9bE0DKNHdu7WTakULbb6J+ZchpWNESmrDuN
	 NtXq68HDuf78nz/+3I0LZY6NtFNdyuJFAMRV7dcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Ren Wei <enjou1224z@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 268/389] net: ipv6: clear suppressed fib6 rule result
Date: Mon, 17 Aug 2026 15:31:47 +0200
Message-ID: <20260817132549.622796081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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
@@ -300,6 +300,7 @@ INDIRECT_CALLABLE_SCOPE bool fib6_rule_s
 
 suppress_route:
 	ip6_rt_put_flags(rt, flags);
+	res->rt6 = NULL;
 	return true;
 }
 


