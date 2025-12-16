Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D5C342C8E;
	Tue, 16 Dec 2025 11:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884845; cv=none; b=R7B9HvlEFQ5yeoIQyn07sTZ8o9avUardyuID7LjfLxC2ogic9dTjJHA+mcWYCZ9YTq4jHhObBDUKFMp/Rv4zr6uaGo9JIoyudfAiEjFos53+WIUFxNqnyZ0uq9CgQ019OfI+DIOobZHn/oveIaUoteCPZZn0k+VNZf1D/Y1USJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884845; c=relaxed/simple;
	bh=05Z5NdcpsOgarlo/3/v7DA6Nd2C0gOEH7uPw/kyHLUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mS2qJFFsCCIuCQVowOR+gNPpGQZ5jqsrTWpPc6XhdcfSQaIeHcYFi8p/Gbj+IhjYEpRXctaaMtUIWzyVj7WadfVNTfokapqTMBVyDJ7khaFUIAureWOON05GHUDwfcRJQw4OfnKojTh8nffNBHYmD04X69PQ7CeR13jsqKUQnos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElOouqUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElOouqUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C938AC4CEF1;
	Tue, 16 Dec 2025 11:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884845;
	bh=05Z5NdcpsOgarlo/3/v7DA6Nd2C0gOEH7uPw/kyHLUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElOouqUlQfHzqoqN4/EjgPY+E0iTwuvivYxHU1wf2Wr91qxZ2sDFejxxyLC5zpmKI
	 KsfcmY93naU/bLxZNNQrAfIRHvQQnKqlf2hshdvvtxdrLXM3yiHKo8H6ajf2KJ23lT
	 mm3Evd/fOqyFEHI3MkBOON8LrVv7hVa4dTySNPrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	George McCollister <george.mccollister@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/354] net: dsa: xrs700x: reject unsupported HSR configurations
Date: Tue, 16 Dec 2025 12:14:10 +0100
Message-ID: <20251216111331.166738557@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 30296ac7642652428396222e720718f2661e9425 ]

As discussed here:
https://lore.kernel.org/netdev/20240620090210.drop6jwh7e5qw556@skbuf/

the fact is that the xrs700x.c driver only supports offloading
HSR_PT_SLAVE_A and HSR_PT_SLAVE_B (which were the only port types at the
time the offload was written, _for this driver_).

Up until now, the API did not explicitly tell offloading drivers what
port has what role. So xrs700x can get confused and think that it can
support a configuration which it actually can't. There was a table in
the attached link which gave an example:

$ ip link add name hsr0 type hsr slave1 swp0 slave2 swp1 \
	interlink swp2 supervision 45 version 1

        HSR_PT_SLAVE_A    HSR_PT_SLAVE_B      HSR_PT_INTERLINK
 ----------------------------------------------------------------
 user
 space        0                 1                   2
 requests
 ----------------------------------------------------------------
 XRS700X
 driver       1                 2                   -
 understands

The switch would act as if the ring ports were swp1 and swp2.

Now that we have explicit hsr_get_port_type() API, let's use that to
work around the unintended semantical changes of the offloading API
brought by the introduction of interlink ports in HSR.

Fixes: 5055cccfc2d1 ("net: hsr: Provide RedBox support (HSR-SAN)")
Cc: Lukasz Majewski <lukma@denx.de>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: George McCollister <george.mccollister@gmail.com>
Link: https://patch.msgid.link/20251130131657.65080-5-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/xrs700x/xrs700x.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index de3b768f2ff9c..7e9a2ba6bfd95 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -568,6 +568,7 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	struct xrs700x *priv = ds->priv;
 	struct net_device *user;
 	int ret, i, hsr_pair[2];
+	enum hsr_port_type type;
 	enum hsr_version ver;
 	bool fwd = false;
 
@@ -591,6 +592,16 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 		return -EOPNOTSUPP;
 	}
 
+	ret = hsr_get_port_type(hsr, dsa_to_port(ds, port)->user, &type);
+	if (ret)
+		return ret;
+
+	if (type != HSR_PT_SLAVE_A && type != HSR_PT_SLAVE_B) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Only HSR slave ports can be offloaded");
+		return -EOPNOTSUPP;
+	}
+
 	dsa_hsr_foreach_port(dp, ds, hsr) {
 		if (dp->index != port) {
 			partner = dp;
-- 
2.51.0



