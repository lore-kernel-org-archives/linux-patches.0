Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAA12EA49C;
	Tue, 15 Jul 2025 13:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586836; cv=none; b=rKmk2qKb47AOemcb/TSZeE06GftMpiwtorgMiWhYLGzgBMhOsS/7XpysX+pEwkulLNrnldVLmc8WM/A1sfxwYEFedA0YHRGmJl122uv0f5YaHuvHINZEOSHeOR8IQyTZ5iOHZ76YEvquVuFTI5WR4Rd4oqjAZDrGxhhiHb2WdSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586836; c=relaxed/simple;
	bh=wg+dlCNc3yovJ4uBRPNQ/z6oo1OkwKCW65dKxMst+RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAvdPfSIRpJ7Fi/c99ljZSKARvco6Epei8IKm2ZAPUz7dV+QfzlVPkUXTaLPj3gt2RAxRdS6PfFcwCpR3BVbFIL7iBSWYTCMzNBjUtaAhXAa3vp10dt6QYvmqJrHcPy3G3DM6j9ZhCLeiJxWhmTC3KvmdOxvx707cPJUNZsglMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvvzX2+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvvzX2+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FCAFC4CEE3;
	Tue, 15 Jul 2025 13:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586835;
	bh=wg+dlCNc3yovJ4uBRPNQ/z6oo1OkwKCW65dKxMst+RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uvvzX2+uKxER33AjsaySHQ9Ihnatx31pz6pOrLDgsKX36Bc+czz3lg2X74mq+nd3Q
	 XtyRozATCbENws1MZLRNQ1qTkBgI77pjmjP1/BoduSTQ91kdtX4H5pEZISBgvSFcog
	 oBMeWoMGzPjmcTf0TXvGB2YMkyu0w3GTB+7sl7L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aiden Yang <ling@moedove.com>,
	Gary Guo <gary@garyguo.net>,
	Guillaume Nault <gnault@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 067/192] gre: Fix IPv6 multicast route creation.
Date: Tue, 15 Jul 2025 15:12:42 +0200
Message-ID: <20250715130817.627318973@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

commit 4e914ef063de40397e25a025c70d9737a9e45a8c upstream.

Use addrconf_add_dev() instead of ipv6_find_idev() in
addrconf_gre_config() so that we don't just get the inet6_dev, but also
install the default ff00::/8 multicast route.

Before commit 3e6a0243ff00 ("gre: Fix again IPv6 link-local address
generation."), the multicast route was created at the end of the
function by addrconf_add_mroute(). But this code path is now only taken
in one particular case (gre devices not bound to a local IP address and
in EUI64 mode). For all other cases, the function exits early and
addrconf_add_mroute() is not called anymore.

Using addrconf_add_dev() instead of ipv6_find_idev() in
addrconf_gre_config(), fixes the problem as it will create the default
multicast route for all gre devices. This also brings
addrconf_gre_config() a bit closer to the normal netdevice IPv6
configuration code (addrconf_dev_config()).

Cc: stable@vger.kernel.org
Fixes: 3e6a0243ff00 ("gre: Fix again IPv6 link-local address generation.")
Reported-by: Aiden Yang <ling@moedove.com>
Closes: https://lore.kernel.org/netdev/CANR=AhRM7YHHXVxJ4DmrTNMeuEOY87K2mLmo9KMed1JMr20p6g@mail.gmail.com/
Reviewed-by: Gary Guo <gary@garyguo.net>
Tested-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/027a923dcb550ad115e6d93ee8bb7d310378bd01.1752070620.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/addrconf.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3525,11 +3525,9 @@ static void addrconf_gre_config(struct n
 
 	ASSERT_RTNL();
 
-	idev = ipv6_find_idev(dev);
-	if (IS_ERR(idev)) {
-		pr_debug("%s: add_dev failed\n", __func__);
+	idev = addrconf_add_dev(dev);
+	if (IS_ERR(idev))
 		return;
-	}
 
 	/* Generate the IPv6 link-local address using addrconf_addr_gen(),
 	 * unless we have an IPv4 GRE device not bound to an IP address and
@@ -3543,9 +3541,6 @@ static void addrconf_gre_config(struct n
 	}
 
 	add_v4_addrs(idev);
-
-	if (dev->flags & IFF_POINTOPOINT)
-		addrconf_add_mroute(dev);
 }
 #endif
 


