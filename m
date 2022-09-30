Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B696137B
	for <patches@lists.linux.dev>; Fri, 30 Sep 2022 00:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A5BC43140;
	Fri, 30 Sep 2022 00:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664499022;
	bh=oDmFdti2cyUR9jedMqIwc5dR+zlMJeHAAAri4fHdknQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0uxHNa6VksjexCPd+S/8v/xU2CGnp2MW4FLz1zKR9D6fxbQ1CR7m6qd8zroWGm66
	 2CCCoKB3ZkuKmfmMQdjBlR2R2NhZvFJo0ApVuVp8fE4vWh0MKIkLnFxmQM/bYI7Mbg
	 DxGVZbremckemw8j/DuV1szvsrl1KyOkvGMTEDHOQ+/vjmsX13ThrpDrV+4xCzGkgH
	 GVrl9rhQnMdAr8NEwsuQKX5hwVZFer4/2beNKmpBRpCmI0hEai6bUwaJWaICXO4Xmq
	 DfBsuRCdzsR1DN/PEkhl57BA4HnnrZW5LQXaNiyMqRe5Oi8qtFo8Q2KLTAX7spXcrC
	 Kq5zEL7nx28jw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: David Collins <collinsd@codeaurora.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Fenglin Wu <quic_fenglinw@quicinc.com>
Subject: [PATCH 8/9] spmi: pmic-arb: block access for invalid PMIC arbiter v5 SPMI writes
Date: Thu, 29 Sep 2022 17:50:17 -0700
Message-Id: <20220930005019.2663064-9-sboyd@kernel.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220930005019.2663064-1-sboyd@kernel.org>
References: <20220930005019.2663064-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Collins <collinsd@codeaurora.org>

The system crashes due to an access permission violation when
writing to a PMIC peripheral which is not owned by the current
ee.  Add a check for PMIC arbiter version 5 for such invalid
write requests and return an error instead of crashing the
system.

Signed-off-by: David Collins <collinsd@codeaurora.org>
Signed-off-by: Fenglin Wu <quic_fenglinw@quicinc.com>
Link: https://lore.kernel.org/r/1655004286-11493-8-git-send-email-quic_fenglinw@quicinc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index cf92abc51689..39f25bc26233 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1133,6 +1133,11 @@ static int pmic_arb_offset_v5(struct spmi_pmic_arb *pmic_arb, u8 sid, u16 addr,
 		offset = 0x10000 * pmic_arb->ee + 0x80 * apid;
 		break;
 	case PMIC_ARB_CHANNEL_RW:
+		if (pmic_arb->apid_data[apid].write_ee != pmic_arb->ee) {
+			dev_err(&pmic_arb->spmic->dev, "disallowed SPMI write to sid=%u, addr=0x%04X\n",
+				sid, addr);
+			return -EPERM;
+		}
 		offset = 0x10000 * apid;
 		break;
 	}
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

