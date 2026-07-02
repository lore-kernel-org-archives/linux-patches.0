Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BA03A5429;
	Thu,  2 Jul 2026 16:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010980; cv=none; b=Sp66g1TRKdfljfjAvi6fFQOUBYnV1lgVaTCLwnLuM7DSLKIYwt11wxZyjjc5YlH5xra4Xda3vyaLlcPq1XvJ8qlI9pExAqIE7h89iIdGwZtd7V/KdAXCAwFQJ7kc4l68HV36JZBt4ip6jJ8MYvzNNUoEzBKeFMwnTzlVMC/HqfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010980; c=relaxed/simple;
	bh=NSGpUNdG8C/zF3T++S8cbrcEeLG1D6asga/5VS4GJGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRVknmy2m+rokV38p2K7+r73bCz7gpP4AkX3PsI8yhC5/IKwJZXUnmbUUVOjbNJ0wqbrfZ6uCsdoO+9crFbVp/+4uAI2YQnrNnN/nBlhnkV/inGgpPQKK7ptZHCom6SVQ+8PU++zszN7HSP7nbf6jP5paAe/OiupM+Mwk0IfR7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4lqGizO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4lqGizO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F141F000E9;
	Thu,  2 Jul 2026 16:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010978;
	bh=+1AFYfjqLF3B3CBC4+dDRq1y5i9WILIPyAq5pYiLDZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k4lqGizOR4y5+Jymfqmm5+Kqil66ktw0f14ScN1KxI11AdvOq6gPGc0IWmkYTQeeV
	 Yt5uW7j4R977Gjqcu7RV9g2kB2cvaAfzad+hNBNHzAz74GlPiUE2Yqdo9iWSbs1+8d
	 m1jEWK63bqjk2SKTpyOrFfPD8/NKdn2ZkxP4ow1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/175] batman-adv: tt: dont merge change entries with different VIDs
Date: Thu,  2 Jul 2026 18:20:12 +0200
Message-ID: <20260702155118.099161200@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit f08e06c2d5c3e2434e7c773f2213f4a7dce6bc1e upstream.

batadv_tt_local_event() merges/cancels events for the same client which
would conflict or be duplicates. The matching of the queued events only
compares the MAC address - the VLAN ID stored in each event is ignored.

If a MAC would now appear on multiple VID, the two ADD change events (for
VID 1 and VID 2) would be merged to a single vid event. The remote can
therefore not calculate the correct TT table and desync. A full translation
table exchange is required to recover from this state.

A check of VID is therefore necessary to avoid such wrong merges/cancels.

Cc: stable@kernel.org
Fixes: c018ad3de61a ("batman-adv: add the VLAN ID attribute to the TT entry")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 7041cd69e20070..69a42bc3fa02e6 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -485,6 +485,9 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 		if (!batadv_compare_eth(entry->change.addr, common->addr))
 			continue;
 
+		if (entry->change.vid != tt_change_node->change.vid)
+			continue;
+
 		/* DEL+ADD in the same orig interval have no effect and can be
 		 * removed to avoid silly behaviour on the receiver side. The
 		 * other way around (ADD+DEL) can happen in case of roaming of
-- 
2.53.0



