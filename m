Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D94186E4B;
	Tue, 10 Sep 2024 09:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961705; cv=none; b=kr9ZjrSxk7vkcQMQHxJUYGz5UGFhFJAtqPUH8nzj7NGABfT3pSv3s/6nU4CGJh1UNU5uHewtVHdxmVWYHK+tRTtE+5hQmzx52TwT6tlHBKUlEsATmd0BN8McvZdGBGtJRYRxpbkW7hCeri5RY7LqM7uvDnpWeD5WEMsALHLfG48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961705; c=relaxed/simple;
	bh=Rg5BZ47fN2tGrDgKHhsza76jiIA5xFVYr4O/jRFvIec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfMJ8cjIzPekPMDT8GgfH3TXQOEvl7Lxwkxo19EcRnsD/SuOt89VdF6ha+dCVF034OtvWQDvmMTLI54u9RQdQ/opNfJ58KF5WHimIwYazucfOPSXJhnScDfnxzMBVT0Ci8h7LpMKNMMFlllh6QMMTouY86/vEgZpKBkEz4MnokQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsH0TZmf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsH0TZmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14CE5C4CEC3;
	Tue, 10 Sep 2024 09:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961705;
	bh=Rg5BZ47fN2tGrDgKHhsza76jiIA5xFVYr4O/jRFvIec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsH0TZmfAIC7cAY88grjedKzUmu95GvLrtdvzoRB/fnHRRxkEIyKixr3Fhr5wz1yb
	 zq0tNcON7ROuFV4+alkT8spYiOz6PV0TtsvOJ0n9JsvAqob7RkkCf88ob7Z/AP8lgE
	 ruYeHBNY2ukAhW2BGWVoMkNXURwZFwiHqMl1B8Sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daiwei Li <daiweili@google.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.10 160/375] igb: Fix not clearing TimeSync interrupts for 82580
Date: Tue, 10 Sep 2024 11:29:17 +0200
Message-ID: <20240910092627.851845467@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daiwei Li <daiweili@google.com>

[ Upstream commit ba8cf80724dbc09825b52498e4efacb563935408 ]

82580 NICs have a hardware bug that makes it
necessary to write into the TSICR (TimeSync Interrupt Cause) register
to clear it:
https://lore.kernel.org/all/CDCB8BE0.1EC2C%25matthew.vick@intel.com/

Add a conditional so only for 82580 we write into the TSICR register,
so we don't risk losing events for other models.

Without this change, when running ptp4l with an Intel 82580 card,
I get the following output:

> timed out while polling for tx timestamp increasing tx_timestamp_timeout or
> increasing kworker priority may correct this issue, but a driver bug likely
> causes it

This goes away with this change.

This (partially) reverts commit ee14cc9ea19b ("igb: Fix missing time sync events").

Fixes: ee14cc9ea19b ("igb: Fix missing time sync events")
Closes: https://lore.kernel.org/intel-wired-lan/CAN0jFd1kO0MMtOh8N2Ztxn6f7vvDKp2h507sMryobkBKe=xk=w@mail.gmail.com/
Tested-by: Daiwei Li <daiweili@google.com>
Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Daiwei Li <daiweili@google.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b6aa449aa56a..a27d0a4d3d9c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6961,10 +6961,20 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 
 static void igb_tsync_interrupt(struct igb_adapter *adapter)
 {
+	const u32 mask = (TSINTR_SYS_WRAP | E1000_TSICR_TXTS |
+			  TSINTR_TT0 | TSINTR_TT1 |
+			  TSINTR_AUTT0 | TSINTR_AUTT1);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 tsicr = rd32(E1000_TSICR);
 	struct ptp_clock_event event;
 
+	if (hw->mac.type == e1000_82580) {
+		/* 82580 has a hardware bug that requires an explicit
+		 * write to clear the TimeSync interrupt cause.
+		 */
+		wr32(E1000_TSICR, tsicr & mask);
+	}
+
 	if (tsicr & TSINTR_SYS_WRAP) {
 		event.type = PTP_CLOCK_PPS;
 		if (adapter->ptp_caps.pps)
-- 
2.43.0



