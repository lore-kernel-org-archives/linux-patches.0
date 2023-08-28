Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CDC11C8E
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:30:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10D29C433C7;
	Mon, 28 Aug 2023 10:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218659;
	bh=XrWXZLWK2q0hBWDMo32aHlkB1VBq6FlK5fm2zssFzMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSXkUy1RHbf8DKx/ZyYap1f5yuj/i9GIC1F8dWbBRZCmW+BUfK3dJmUEuJf3zVNy+
	 2upVeDLNzpjIP2jyp2tv4DAjV8n4KZddLagndGU+0Wi3PGlFPDmRGr9IQinUK+0OWY
	 hJN2GKpnk+jC77l/fbPSUF0j11K31RMpOBnC63GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/122] net: dsa: mt7530: fix handling of 802.1X PAE frames
Date: Mon, 28 Aug 2023 12:12:32 +0200
Message-ID: <20230828101157.647251270@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arınç ÜNAL <arinc.unal@arinc9.com>

[ Upstream commit e94b590abfff2cdbf0bdaa7d9904364c8d480af5 ]

802.1X PAE frames are link-local frames, therefore they must be trapped to
the CPU port. Currently, the MT753X switches treat 802.1X PAE frames as
regular multicast frames, therefore flooding them to user ports. To fix
this, set 802.1X PAE frames to be trapped to the CPU port(s).

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530.c | 4 ++++
 drivers/net/dsa/mt7530.h | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 51d2ef0dc835c..b988c8a40d536 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1005,6 +1005,10 @@ mt753x_trap_frames(struct mt7530_priv *priv)
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
 		   MT753X_BPDU_CPU_ONLY);
 
+	/* Trap 802.1X PAE frames to the CPU port(s) */
+	mt7530_rmw(priv, MT753X_BPC, MT753X_PAE_PORT_FW_MASK,
+		   MT753X_PAE_PORT_FW(MT753X_BPDU_CPU_ONLY));
+
 	/* Trap LLDP frames with :0E MAC DA to the CPU port(s) */
 	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
 		   MT753X_R0E_PORT_FW(MT753X_BPDU_CPU_ONLY));
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 9a45663d8b4ef..6202b0f8c3f34 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -64,6 +64,8 @@ enum mt753x_id {
 /* Registers for BPDU and PAE frame control*/
 #define MT753X_BPC			0x24
 #define  MT753X_BPDU_PORT_FW_MASK	GENMASK(2, 0)
+#define  MT753X_PAE_PORT_FW_MASK	GENMASK(18, 16)
+#define  MT753X_PAE_PORT_FW(x)		FIELD_PREP(MT753X_PAE_PORT_FW_MASK, x)
 
 /* Register for :03 and :0E MAC DA frame control */
 #define MT753X_RGAC2			0x2c
-- 
2.40.1



