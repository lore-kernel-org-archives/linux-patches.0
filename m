Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE11F415F0F;
	Tue, 21 Jul 2026 18:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657848; cv=none; b=qHwFgzfQ3S8uDN1Em6dtOxC3D2wpXKaCTfmwuXWSwZ7gGjbzkM9/yTGHGhJTdNV/+MostoxOQaSzO1DWdnglzUxEbCC6FYIzK25dacUkFt21wzDFAKolg0trfvf1kdZjsUnJnqYqmoCTdYRydrhvfwuG3W3yw2YnkuqhnB3Kzn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657848; c=relaxed/simple;
	bh=T//sOXDjBuRje4KwuM+d8zdm+3Zv2aXsGgQ8/h1vjEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5zabR+AxvUo8vYRsS/6ON2NfPpugWQlBeG5aTBSO4iw/br8hDIktFkih0oRnX73kWII6hMsnkqv7H6iqceKUCed/5qG4ehz+GkxvBrdoopa9yzDf36lQBaPZznNwZRguK0rwFVZJbEjULtbLQG4S0dmwNvpRjJAfDZFWxZiRkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E+GpXa/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E+GpXa/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510BC1F000E9;
	Tue, 21 Jul 2026 18:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657846;
	bh=IvwrP8i3S17KTcWYm1f/XYxZ/HS+Tx8H9f7B/S8ac/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+GpXa/DCw1IyoC6jn1/ftdyfm3lKe7kSDKr4TPlXCCKgXxrscGV6ccj4ozj4kJWi
	 N1mM5XWHH7u7Tmv0RhpGoSGlY/Dm2AXY2Nxq8RrXAA7Z54YnO2Bni3yDQthLyVihyj
	 KyXuC74z67qzUrMFFj8h4Z/hTCKwTlH+7BaxmCag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0919/1611] ipv6: fix error handling in ignore_routes_with_linkdown sysctl
Date: Tue, 21 Jul 2026 17:17:15 +0200
Message-ID: <20260721152536.057514872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit cf4f2b14401f29ccac56393ca9e4b42a2505f540 ]

When writing to the ignore_routes_with_linkdown sysctl, if
proc_dointvec() fails to parse the input, it returns a negative error
code. The current implementation is overwriting that error for write
operations.

This results in a silent failure, it returns a successful write although
the configuration was not modified at all. When modifying the "all"
variant it can also modify the configuration of existing interfaces to
the wrong value.

Fix this by checking the return value of proc_dointvec() and returning
early on failure.

Fixes: 35103d11173b ("net: ipv6 sysctl option to ignore routes when nexthop link is down")
Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260622130857.5115-3-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 87c0cecc76bb94..1907cdb54d1dce 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6651,6 +6651,8 @@ int addrconf_sysctl_ignore_routes_with_linkdown(const struct ctl_table *ctl,
 	lctl.data = &val;
 
 	ret = proc_dointvec(&lctl, write, buffer, lenp, ppos);
+	if (ret)
+		return ret;
 
 	if (write)
 		ret = addrconf_fixup_linkdown(ctl, valp, val);
-- 
2.53.0



