Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1F6175A81;
	Tue, 21 Jul 2026 23:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674856; cv=none; b=gLrSZUlpB4iDQ5A5BwN118vGJx3PrcXQA2BHM6Pb862IkOHdW6TUrN1LmesFK24X+i3zWGYli0NLL1ACEHj687+ZKZ2JuQ0TWMuEPB3oipF5xOQdBcsf9gK2dEilHQJJ0FNN1dz5qa6lH1f8CTfMwvX4BtgSAd0i8Xmp4E3kvoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674856; c=relaxed/simple;
	bh=gwZ5a2Fv7e8npqs1QD2Mkdb0zRmX1h0DjmYk7hPcFs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gs4wz0erkfpxK69WSMUUzayXyUZ9qSWkYytNsJe3z7GFCm7gHclMf+NAfsuDe3snV7sj7TsFhWMxLLtl9Os1kTZK/dPv9uIG/QW1OQ1KfYS4VLXc2DuRPkfTQBGarbhjs6f9xuHOd/jLkuM5YxK7F1TvZmlgnSgg0foU/1n2Ad0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNgr2oal; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNgr2oal"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE971F000E9;
	Tue, 21 Jul 2026 23:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674854;
	bh=fPpAkRsPCw+pOxLySoSOPYoLKdkpPfSHWm4QWNmeXBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNgr2oalkko04cppbviPZIpHZ4RwEgbN4EYVzI9hvuDxqvtkxKeGfrzTvSD2Y1pFA
	 3By191b5ntEKPB5kgkdkLsLLHs/1kCxnaxVfU3KNl5x6FT8oHgj9xV5kI3qWq85wiV
	 t0+DCzrzKbNjggz1DdfmwH/LJxCWi9qaf1tVimK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Taehee Yoo <ap420073@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 698/699] ipv6: mcast: remove one synchronize_net() barrier in ipv6_mc_down()
Date: Tue, 21 Jul 2026 17:27:37 +0200
Message-ID: <20260721152411.527822520@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 17ef8efc00b34918b966388b2af0993811895a8c upstream.

As discussed in the past (commit 2d3916f31891 ("ipv6: fix skb drops
in igmp6_event_query() and igmp6_event_report()")) I think the
synchronize_net() call in ipv6_mc_down() is not needed.

Under load, synchronize_net() can last between 200 usec and 5 ms.

KASAN seems to agree as well.

Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/mcast.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2751,7 +2751,6 @@ void ipv6_mc_down(struct inet6_dev *idev
 	/* Should stop work after group drop. or we will
 	 * start work again in mld_ifc_event()
 	 */
-	synchronize_net();
 	mld_query_stop_work(idev);
 	mld_report_stop_work(idev);
 


