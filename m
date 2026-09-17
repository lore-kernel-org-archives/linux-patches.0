Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972804E3247;
	Thu, 17 Sep 2026 16:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661022; cv=none; b=TElvV4Zy9ny5hdZJ60TBrfl9TvJGZyIn8CA1Ct9KgllTa9S+sYqkuRmhDGQwJZLRiXJhFan0z1v9g0D/j8CIIgg1kAGz+AP7JP1/ZH2DEayEZZ22ds3wHmBwQUav3CKSYko2iYrj+QesdZ4k4FCgMmXyFMfWRhBaCUAB8Rmr95s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661022; c=relaxed/simple;
	bh=fUDl5HtfgiQfotLhbJrNpoebnqvOsIbViFmMpmTOL1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9LlqFN4pKPEbZdA5u/C340bJAp158oSL0PkVWkIuBodV30fKXdtilaFuqm/AacdCPAG1lLesWkb54Ma5KLVmVV+N6h+xQ4ujkqsSF9hcJR/XE3S8jpl0juoZDeg+S0bmHZ9Xjm/PP+DLgvgkcFo4tLF2lHFu1i0sIdhc4Wj4fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07MbmMo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07MbmMo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE79B1F000FF;
	Thu, 17 Sep 2026 16:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661021;
	bh=w60FO+AmNjyPBUVe6AGDBGPZjDtlxU8JLTO77hZ/EOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07MbmMo6swG/TYoOHGiHZL++1IP2tXulSqSaqhXcucsxjrg1XjXMGMKnKAZnboSbX
	 m2SLxICZfrnzzjmzF/Crq7Tt5lMj7W9juT4WdKkz7Vct5ybBqLht93f2X3h82sjq+v
	 kEEioHoBc4GUtaheAGQlqYpi93u16dJhj8Uzl77E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0056/1250] thunderbolt: Dont disable lane adapter if XDomain lane bonding isnt possible
Date: Thu, 17 Sep 2026 15:57:31 +0100
Message-ID: <20260917151553.457924437@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit 7c7345bcde6c611fa8fa13e624207c6005798aa8 ]

This happens when firmware connection manager is being used. It will
deal with disabling the lane 1 adapter after the tunnel has been
established and re-enabling it afterwards. For this reason only do this
when we know that lane bonding is possible (e.g running software
connection manager).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/xdomain.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 6b16fc7254b8e..b27ef872edeac 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -1951,7 +1951,13 @@ static void tb_xdomain_link_exit(struct tb_xdomain *xd)
 	if (tb_port_get_link_generation(down) >= 4) {
 		down->bonded = false;
 		down->dual_link_port->bonded = false;
-	} else if (xd->link_width > TB_LINK_WIDTH_SINGLE) {
+		return;
+	}
+
+	if (!xd->bonding_possible)
+		return;
+
+	if (xd->link_width > TB_LINK_WIDTH_SINGLE) {
 		/*
 		 * Just return port structures back to way they were and
 		 * update credits. No need to update userspace because
-- 
2.53.0



