Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7473D396DD7;
	Tue, 16 Dec 2025 12:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888397; cv=none; b=qzME5Ovv1et25NdgwYeXygWS6IQqksMCAvmBSZXAssteGoNVJtuWH84uzm5FYFSv5WI1dPD+9bRI5EPS0u/rP2K1uR7wKrKUHRhkugAOFjA3/0FM2cuPtYKxFPRrrzIPuA7TldoadwYL89Vsm7+dpsZ4oqUtKtmpA0SURQMqRJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888397; c=relaxed/simple;
	bh=UvNBjFw5OdHlK4pKBum+cRP5F+8n5fDBRirJXYMzfug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+XfPMafTA01eHtCm/Zy7Qc4q+KZqQbqTBNoQH0BM2KDN7AWa5vcVPnGB7QqvSqIfp6HULpsO3FftbsbOCXGqo4ECphbKAio9HWJvW4866vIIJ0blgTE4tZ4OpJTL3EikBEf1owZzbyFV+iMol2sq9OkqvwujfAx1Lv5bCUuQw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kH+JIlPK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kH+JIlPK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B22C4CEF1;
	Tue, 16 Dec 2025 12:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888397;
	bh=UvNBjFw5OdHlK4pKBum+cRP5F+8n5fDBRirJXYMzfug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kH+JIlPKyC22MnGxx5MixvyTtqYChuZzP4p1x9Uso2ilt9I9WpquxRC5EWGQ7vuKL
	 9vsEaN8JP6//UPzUnpV5CmpIoxuoHUi7Xx/+C2GgRT0XgyFuDkmJzxrfxK/0xSmCJf
	 BD+fVYhJ8C7AJFT08C2cHHbbNGn0lcYLLBNimjbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	George McCollister <george.mccollister@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 521/614] net: dsa: xrs700x: reject unsupported HSR configurations
Date: Tue, 16 Dec 2025 12:14:48 +0100
Message-ID: <20251216111420.248665361@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 4dbcc49a9e526..0a05f4156ef4d 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -566,6 +566,7 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	struct xrs700x *priv = ds->priv;
 	struct net_device *user;
 	int ret, i, hsr_pair[2];
+	enum hsr_port_type type;
 	enum hsr_version ver;
 	bool fwd = false;
 
@@ -589,6 +590,16 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
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



