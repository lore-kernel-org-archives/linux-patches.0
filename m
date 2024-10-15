Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4C61B2184;
	Tue, 15 Oct 2024 13:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998568; cv=none; b=ZsI8TSv1Nt3CaPJOJn6KvZJj43DZCwNnQcdehIi4tJLCvZXZzt5DO05P3hLHCCjBzeAOWcqgKPLE15E8SdFaemQt/aCCc5nT18GC9BeO5Pgu1dVGiZwZsC4XU2B0QO05dze3CdzE3pKy5Vvx1yMhPleHB3GhrwwhpvfFlQ9JYKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998568; c=relaxed/simple;
	bh=bs8xuSRsWYeuu9zFf1+wag3rBaFcfI23GMr7UNH6eAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vfr/D3VipbJjTRZ33hMapMZTuWwvdI41xPJcJy41RYN7USqG8psmeTyLp3UsnMezdDziqdZ3w13lR7KvyO53Ccc4LZZoHRBTcl01FWaYoUriB6AClWcldzaOA5klmJW8B1/B7kNPcL9FnPz///y1kwlzG/wdDYA2HaCfv9Dl9KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap06ws0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap06ws0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5458C4CEC6;
	Tue, 15 Oct 2024 13:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998568;
	bh=bs8xuSRsWYeuu9zFf1+wag3rBaFcfI23GMr7UNH6eAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap06ws0zKsUa90zbLkFiX3IKn+CcGY6d5KBMOkd0sa+dXcjPubuOumylm51pWzaQJ
	 GVkVtiBFn8k1zpdpe4DAVhXJtWseAVezKSS6tVcYbVyAAeGuGPG9SAmbFkHCnixcJC
	 ZfBwO2sbuRWxjKYVMaJEAgdL403lbtXdFXdOe/Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 516/518] netfilter: ip6t_rpfilter: Fix regression with VRF interfaces
Date: Tue, 15 Oct 2024 14:47:00 +0200
Message-ID: <20241015123936.903979064@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

commit efb056e5f1f0036179b2f92c1c15f5ea7a891d70 upstream.

When calling ip6_route_lookup() for the packet arriving on the VRF
interface, the result is always the real (slave) interface. Expect this
when validating the result.

Fixes: acc641ab95b66 ("netfilter: rpfilter/fib: Populate flowic_l3mdev field")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/netfilter/ip6t_rpfilter.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -72,7 +72,9 @@ static bool rpfilter_lookup_reverse6(str
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev ||
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
+	    (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);


