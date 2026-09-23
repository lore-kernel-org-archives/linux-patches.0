Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13143750BE;
	Wed, 23 Sep 2026 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173992; cv=none; b=WsiGS1ORIyXRaEEm2JZ1bml/gWvtYTbjiOeQlvupkcH9s+/DXQxcg8zph+AdLWJtpnwwaLp+YEbHt7C59aQMN5jnyjtabXkbvhQbiaQQJ86yNMff1/GyHKulxarsjHJ/yhxnXIUBS9eV0UFgENyUQjbWBCSHn10kN+oWgVsEB7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173992; c=relaxed/simple;
	bh=eliuGSgZZOFhO9srPNj9uPDkbJI6B6aYdxJcXr6LQ7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDkFC0rVpoRfhp3sQsxivK14U3yiqKA8hxFeg9JrGbVt8Ls3NgRVP0izfKd1WttT8sCKTRdKXbiDqQbJHRSczP5mXk3gCFRYjW2UnkxSwy2F0XkbCt+V9opx6Q0by6OxERBElqe06u6C26pYGVCpKAufSL3ZQOmu2eChtFqLVRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXWG40Ok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXWG40Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5FC1F000FF;
	Wed, 23 Sep 2026 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173991;
	bh=lA5fbqALJaf1kWU6+u/0ULueZaiPO4nWvjKW+uJ4qQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oXWG40Ok5a/tRyH/+1p5qPhjztVVFp45yh0Y/bg873qi5vgO3jOJan8BQFwe3rocC
	 T4jMrcJ3kCqYNj594j3GOjgRydfk4bahIyRuo8QCuD8KN8xJOUaN5++ARVw+5RGotJ
	 0fcHZawod/8I3bDV2SVqEcMiqztcECaAeG2H8vjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.2 399/438] wifi: mac80211: refuse to make a monitor active when it has no queue
Date: Wed, 23 Sep 2026 16:07:00 +0200
Message-ID: <20260923140655.233521506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

commit 2b04d6556964ae9f89819b86a0a7801e39c3aae5 upstream.

A monitor interface only gets a TXQ if it's created active, and one can't
be added later. Setting the flag on a down interface is still allowed, so
the driver is handed a monitor with no queue. ath9k dereferences it:

  BUG: kernel NULL pointer dereference, address: 0000000000000066
  RIP: 0010:ath_tx_node_init+0x49/0x170 [ath9k]
   ath9k_add_interface+0x10c/0x140 [ath9k]
   drv_add_interface+0x54/0x250 [mac80211]
   ieee80211_do_open+0x32f/0x800 [mac80211]

Reached with CAP_NET_ADMIN by "iw dev X set monitor active" followed by
"ip link set X up". RTNL is held, so netlink operations block behind it.

Refuse the flag when there is no queue to give.

Fixes: 79af1f866193 ("mac80211: avoid allocating TXQs that won't be used")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260904200338.10829-1-lucid_duck@justthetip.ca
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/cfg.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -115,6 +115,10 @@ static int ieee80211_set_mon_options(str
 			return -EBUSY;
 	}
 
+	/* TXQs are reserved in ieee80211_if_add() and cannot be added later */
+	if ((params->flags & MONITOR_FLAG_ACTIVE) && !sdata->vif.txq)
+		return -EOPNOTSUPP;
+
 	/* validate whether MU-MIMO can be configured */
 	if (!ieee80211_hw_check(&local->hw, WANT_MONITOR_VIF) &&
 	    !ieee80211_hw_check(&local->hw, NO_VIRTUAL_MONITOR) &&


