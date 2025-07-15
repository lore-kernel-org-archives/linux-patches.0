Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D952E3B13;
	Tue, 15 Jul 2025 13:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585917; cv=none; b=mCqdif4A/rOFZzXGh4UlEIrMdVz1Px5bQYty8U9OT43+RigEIEV1//loGYULq1eahVAyCZsB68zZxPcdgYhOSMMpUX19ne35hA1H7O1N5tr++eppcJKeEkuEDWis7S1CZbz9uOnAol3IZr0oyM2U3xJbu95p/Q4i6zuUEAnJz1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585917; c=relaxed/simple;
	bh=xXztFy2HL5t+zg8g64xsDF6oBMbkRf85xfr6Cav2kWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkMrYOroHuHIBibx2xrELPqkezu8d6fsJDrtm7H9gEED0XVPmnByLPKvE/z2KVOqCh5S7S0InHLyTGduKyga8eSRgk0hu5uu5qFAye7K++KeBGNkf07LeNX1IQNXbkv3fxQgCEaFqScfJjZU0D4uI9IY1WQWkWteQxuUNXon7Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B3rRUsCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B3rRUsCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329B7C4CEE3;
	Tue, 15 Jul 2025 13:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585917;
	bh=xXztFy2HL5t+zg8g64xsDF6oBMbkRf85xfr6Cav2kWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3rRUsCaJnGYdrworzJ+HuXxj4JDe9y7WxCpW57PSdIXZ1gZKfBs/G+VhnRmKeAas
	 kFUZ+6MDsv9feq8Z1JdD597PHf4wWJ+DBxwAohtqIrpSub8p/xyikZXwNiCW0u5Gfd
	 hcvD5NElSA5A85y6GAw8xLzbKrnSwRHEO2UWFS40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aiden Yang <ling@moedove.com>,
	Gary Guo <gary@garyguo.net>,
	Guillaume Nault <gnault@redhat.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 039/109] gre: Fix IPv6 multicast route creation.
Date: Tue, 15 Jul 2025 15:12:55 +0200
Message-ID: <20250715130800.445562551@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3499,11 +3499,9 @@ static void addrconf_gre_config(struct n
 
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
@@ -3517,9 +3515,6 @@ static void addrconf_gre_config(struct n
 	}
 
 	add_v4_addrs(idev);
-
-	if (dev->flags & IFF_POINTOPOINT)
-		addrconf_add_mroute(dev);
 }
 #endif
 


