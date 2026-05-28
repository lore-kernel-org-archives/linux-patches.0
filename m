Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8F3348C6E;
	Thu, 28 May 2026 20:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998750; cv=none; b=IHrawiELU8NRUxcC8DZ4GczvVTnDtkd2oKKZseFtZb4zQcsEX0UdfOBU3Y6k8VPVvEdAfTDKe++Q+/BM5ZgPs40/7ncz0RipabQ025ZbFgzilsSXcSdB7KAiF13KavipWkbTYuKMwDqAoftIHibwEUn4wBP9Ln6ZZx8ubDnMQ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998750; c=relaxed/simple;
	bh=yOxcDj44X/5Kj/p/WCG+MbBdVUc9MfD9wS/BMXAiAaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ighV7wa6DIZu0GUJNL1cnB148rTrG+l3rUiQrC6BQfkIUBg4ABI84ILXBF32x3le21TmCyvwikw0BNWakXWrzjP+zu3jH1D+Ab4xen9e/ifjJoOkAW0h5fSYIvhmOBIXbCn+RWkN8Xr9dmxCTlTAyqs3RKifr+KkQwesWDmqyAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvI7ERrd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvI7ERrd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1A81F000E9;
	Thu, 28 May 2026 20:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998749;
	bh=aQHLw+KNmN5Y3bMVx+7OD5JJJlkNdkPuCjEsWTrougQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvI7ERrdE9XdD7OjM8M8NCh0g3hKD425VhDeo5IIehmP+ELZApYab3mAQT9k/0WAz
	 md4Y99l13hAgGFeDYBC6aiELH7cMobooRiTVO70zaIbatzT315/yw7EopPY9svVmVy
	 nGEgaZgt8mKOdJ9VELH9PDGCQcKz4Tspf8rvyZPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 285/461] net: shaper: enforce singleton NETDEV scope with id 0
Date: Thu, 28 May 2026 21:46:54 +0200
Message-ID: <20260528194655.448636480@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b62b29e6de6711f5918940aa6ff2bbab6d6af502 ]

The NETDEV scope represents a singleton root shaper in the per-device
hierarchy.  All code assumes NETDEV shapers have id 0:
net_shaper_default_parent() hardcodes parent->id = 0 when returning
the NETDEV parent for QUEUE/NODE children, and the UAPI documentation
describes NETDEV scope as "the main shaper" (singular, not plural).

Make sure we reject non-0 IDs.

Fixes: 4b623f9f0f59 ("net-shapers: implement NL get operation")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Link: https://patch.msgid.link/20260510192904.3987113-10-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index eb049847fed65..4ae3ee6764a0a 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -482,6 +482,12 @@ static int net_shaper_parse_handle(const struct nlattr *attr,
 	else if (handle->scope == NET_SHAPER_SCOPE_NODE)
 		id = NET_SHAPER_ID_UNSPEC;
 
+	if (id && handle->scope == NET_SHAPER_SCOPE_NETDEV) {
+		NL_SET_ERR_MSG_ATTR(info->extack, id_attr,
+				    "Netdev scope is a singleton, must use ID 0");
+		return -EINVAL;
+	}
+
 	handle->id = id;
 	return 0;
 }
-- 
2.53.0



