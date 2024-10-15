Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41F11EABD1;
	Tue, 15 Oct 2024 12:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994372; cv=none; b=i13zxBM3mfMfv/FYteBVI6KtaaSLtudtmKpH2/kOgwNqU6MehPERJx4g7UVmKbzaU+h0NsO9L64PihQk4jhY7LJ+sXWN09rd2EScu1TRJU1qacxFc5lvqSoN16HrDdit8npAoTjZdBuGnRoLMOBFZr5ZgfmEzTs2ZTU89jHlnHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994372; c=relaxed/simple;
	bh=UWnvE4vIBanmRx4e3pVUT8Ta7Q1gCdFW78WUpzQIG08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQYgY00dNbNQzPdzIcPCd0bLsuqhX/TOv3U9iv16VLeSW5GaD/aDe27eb3CRsgWiI1vF4/vCv+zRokYKTxoNnmrQuCCkgPHSEKi4fPUaErofy/Pu1A/6ktfVIPVRyohfIgBzyML4390xE1T0D0Rh1QJIX7UCGaF/+LX5zPSzkS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPXxvSBC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPXxvSBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DB8C4CEC6;
	Tue, 15 Oct 2024 12:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994371;
	bh=UWnvE4vIBanmRx4e3pVUT8Ta7Q1gCdFW78WUpzQIG08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPXxvSBC2vHAdxfzt0GcJ8cQzaJ3DMjDZdnXm1oUiKBM+3FILZVJqRtx5vTwik/Fp
	 LAeOK99OFNwiWeLq4pJBYshmLYuqaWbleft9bd3Xy+r3dCvNjBaECSNsWuhQuvG8M1
	 9sJzgak7mQ6xN+Yj8Qvy31wPdyECWR3ixv0p/Bac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 687/691] netfilter: ip6t_rpfilter: Fix regression with VRF interfaces
Date: Tue, 15 Oct 2024 13:30:35 +0200
Message-ID: <20241015112507.586406485@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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


