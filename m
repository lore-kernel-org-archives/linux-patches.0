Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAF15013D9;
	Tue, 13 Oct 2026 12:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892952; cv=none; b=hB9I/scNOOmAhiEtsXPuOpMG7RiBVxMswgFhpIJCdyyjEkdHOO9xU/QhlbkBgGxq2l4EK1ztdjqHbnHBeXj/guzTRKdfN+RxLz8CzDuWFxjftjzeL0heV955FqUDxk09fpZR3F5x/roxBo4D0T8/sgaIr/oHl91EoKwwI2k80vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892952; c=relaxed/simple;
	bh=70i6CRlEEo29xH2TCd0lLxQv4NSSU96LyaXIg+ER29s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz8wYp46NwHuv3rCi5VX/4Q0vbS8btOTa0cqJcesVWn1s/InvY661h8kD7sjLBvbxKRMtb2l4buBFXjmGJTzvKiXgJrrsC8uLYObFGnzlK/nSKW40J0tpcz/NHqv7uRgzPHx0fmX2x990k+eqQzK64CyedeKm4iKYMM4ERmli50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPOjzBH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPOjzBH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3331F00898;
	Tue, 13 Oct 2026 12:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892951;
	bh=tr8y6X9lE7hNwRaZtN57xO2bZ3JnV00yItDynNAd520=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPOjzBH4kFYKCqkUG4AQ/qvsCHWJSj+TmIzCLaAurHPDzbT3Ype9WIuZGRtQvfUtu
	 Ay2STa2fifgcb2K0n1miGu4NVbXWsrI14lUZH0TnFEaPbeiIDtY3jp2juT/nljMdEZ
	 Hor915t+S1V46GF6xxI6hktdLsT+U/7C2IVmcKKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 019/621] ipv4: stop exception dump when nexthop group shrinks
Date: Tue, 13 Oct 2026 13:30:14 +0200
Message-ID: <20261013112921.320552625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit 4f4afc07dcb2edd4f9afa36595373f8cdb9b58c2 upstream.

Commit 4ce5dc9316de ("inet: switch inet_dump_fib() to RCU
protection") allowed IPv4 FIB dumps to run concurrently with nexthop
replacement.

fib_dump_info_fnhe() uses fib_info_num_path() as the loop bound,
then fib_info_nhc() independently reloads nh->nh_grp. If
RTM_NEWNEXTHOP replaces a group with fewer paths between those loads,
fib_info_nhc() returns NULL and the dump dereferences it through
nhc_flags.

Stop the walk when the indexed path is absent. Nexthop groups are
dense, so the current snapshot has no later path.

Fixes: 4ce5dc9316de ("inet: switch inet_dump_fib() to RCU protection")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261001170513.GA1657889@shredder/
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/5bb7bd97411eb9db454464bf449107395e760f26.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3168,6 +3168,9 @@ int fib_dump_info_fnhe(struct sk_buff *s
 		struct fnhe_hash_bucket *bucket;
 		int err;
 
+		if (!nhc)
+			break;
+
 		if (nhc->nhc_flags & RTNH_F_DEAD)
 			continue;
 


