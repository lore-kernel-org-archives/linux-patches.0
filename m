Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DA5335BCD;
	Fri,  9 Jan 2026 12:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962586; cv=none; b=jYZbreye2LwAWUCqOYj20olOOFalABiTzUduYMr59bJ9D4V5np52OaCS+P5ZiXeJxz/qVs6sR1WlhjD/Hmphvu34t9qMaGGKct/5lWpB7vr7N1lbo6PXtR+u+9i/vBCQUVXeLBL5feBFcAdZA2QSNEHYi9Jln+X6Ms+Epz4KLCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962586; c=relaxed/simple;
	bh=Grk4mJYg/W3PCOjkZPGV8GHx1nX6RFIG/SurwoSukJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUD8vWbfEbduUm0iyge3i8dEsbCQM9eAosdSAQu7+XTqFR756QiuvJqSmcHdEuEPyqDL6jbBm4XRvdZRQZJL+yZ45snPa64GO4tsyRRr3KGEU/ntGbEX70mukEBnUsZ8C4RxDp8zqHUG58eGPrqY7Es88DusRbGFRx0JX4vBmg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IxtR9wxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IxtR9wxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C342C4CEF1;
	Fri,  9 Jan 2026 12:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962586;
	bh=Grk4mJYg/W3PCOjkZPGV8GHx1nX6RFIG/SurwoSukJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IxtR9wxUh68jdCD066R9ImFTmNwGHF+iJWq5zbjgu4VpJHAy0bCfCjtIxOEi+BUp6
	 T3D5dBt4Xdk2y+8wh3ZcgfQU+Q9mcUPoD9RZSe0q24BP+bjVnzi8nOJd932LSoXuT6
	 aNqbtCSpPCo8Y1MS/7DuusgI+ubhke6u2hTRA4sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 416/634] net: dsa: b53: skip multicast entries for fdb_dump()
Date: Fri,  9 Jan 2026 12:41:34 +0100
Message-ID: <20260109112133.189742148@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bdbb873fe6eb..49fb610db484 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1815,6 +1815,9 @@ static int b53_fdb_copy(int port, const struct b53_arl_entry *ent,
 	if (!ent->is_valid)
 		return 0;
 
+	if (is_multicast_ether_addr(ent->mac))
+		return 0;
+
 	if (port != ent->port)
 		return 0;
 
-- 
2.51.0



