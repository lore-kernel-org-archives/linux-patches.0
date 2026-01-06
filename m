Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643AC33993;
	Tue,  6 Jan 2026 17:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720817; cv=none; b=UaAPNmQ6RXzZi9dIdqkVMU50IcbZL+c9lwanDZt2p9zb9dOP2EsUQM0KnEnJuxZWruG2CUO9TVvQYvLPP9BLxxll1gc4nAflJ69dVLWw138uGKygG3uj7yMp2boSPsq/8wF9NfYBxKaiFbo8Tp0J+B1WeiGKsK19HDxi3BHzle0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720817; c=relaxed/simple;
	bh=TsVxJMXKP8gvH6quXV+mExHAKZUwO6MKbuhIo05iJz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTSl1+lhHPeoZqo12N7ncG/eMHde7fiAZPvBAVA0kA/564fPrUzHm4Bssev8zMyQiVU9iVqcUDhT+blD/mVeoG+qzZDd8Ke0TNMAANw42MuB6IWBCI04EjSvln1h+jxnuqaC2jS/OcLLlSS9JS0+Z8zMAOmAVrINoidPX1gnIWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AumGM8vk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AumGM8vk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7284C116C6;
	Tue,  6 Jan 2026 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720817;
	bh=TsVxJMXKP8gvH6quXV+mExHAKZUwO6MKbuhIo05iJz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AumGM8vkhhzqSpH9PZrnhyg6bvhSARoz85pbmUeIw0XjkHclSq2AbDoX/DDj2VdKY
	 slWRayfQUwyD8kqSb6ft942YX5HcikdMEiB9gx/1le0XoC7B2HJ9Ys5vBRAHSXAUiJ
	 bdcazZC9BH+w8djMHQr5GD465mk0wrEOWg9PQXWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 318/567] net: dsa: b53: skip multicast entries for fdb_dump()
Date: Tue,  6 Jan 2026 18:01:40 +0100
Message-ID: <20260106170503.090830647@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit d42bce414d1c5c0b536758466a1f63ac358e613c ]

port_fdb_dump() is supposed to only add fdb entries, but we iterate over
the full ARL table, which also includes multicast entries.

So check if the entry is a multicast entry before passing it on to the
callback().

Additionally, the port of those entries is a bitmask, not a port number,
so any included entries would have even be for the wrong port.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20251217205756.172123-1-jonas.gorski@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 01eb62706412..0b666a77ea97 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1972,6 +1972,9 @@ static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
 	if (!ent->is_valid)
 		return 0;
 
+	if (is_multicast_ether_addr(ent->mac))
+		return 0;
+
 	if (port != ent->port)
 		return 0;
 
-- 
2.51.0



