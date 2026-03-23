Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E623B7746;
	Mon, 23 Mar 2026 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278219; cv=none; b=KskNQibW6qc9A+5vJ7q/ivuJNv+gFqNi2UX/iXwBzf+WZEnxatWjYqnVG68tEEtnpWVxh9pEC1JCKsLXlsl/mDLWjoDs6LBU2IMlHc9iHAx6lbrXQDknw3EU3FB/mgzBDeWaH7kl+VD5vuVUYCa8mznOy/CHmjsdZ3ysaJXDGjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278219; c=relaxed/simple;
	bh=gbb7p8lmAsTABkarQNsPFewfSHz3yQ9jTYV6uCK6QDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kvk5K7DyE9H3riqU+952wdlVE2ZMPYUOeYBgHJLPJwS/E/dAdN5eolZ5qSRNA5ZjgOm1QYhfN2QnQSs+Q9sfRkzvTEg8EjnpNALLVgYSREY8X9/fiusXkxKXgZ/GGqiFyndJXFuypAzbey3Vr3dzNwQk86rlIwkpPeprIlK58gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tq0V+EIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tq0V+EIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE763C2BCB1;
	Mon, 23 Mar 2026 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278219;
	bh=gbb7p8lmAsTABkarQNsPFewfSHz3yQ9jTYV6uCK6QDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tq0V+EIRPVEexSnhpD5X5ZIzmcT0LfAtdmxth6W7IIIRiGZOreFlhqgT4pYdtJgoM
	 GoWKMuuMoaFCm5QPEx1w3qTfVA6eieYJLbBXJiUUucPXDgNldnTZEgjg7IgKt+gWq1
	 yMoH9AYoieUrG1TDRVSloVEzb80U9vwMHjOOeHCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/567] net: sfp: improve Nokia GPON sfp fixup
Date: Mon, 23 Mar 2026 14:42:31 +0100
Message-ID: <20260323134539.548611480@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit 5ffe330e40bdfad9c49a615c54d2d89343b2f08a ]

Improve the Nokia GPON fixup - we need to ignore not only the hardware
LOS signal, but also the software implementation as well. Do this by
using the new state_ignore_mask to indicate that we should ignore not
only the hardware RX_LOS signal, and also clear the LOS bits in the
option field.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Tested-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://lore.kernel.org/r/E1qnfXh-008UDe-F9@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 87d126852158 ("net: sfp: improve Huawei MA5671a fixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 5d1456e1449fb..c47d7232d1c6e 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -345,11 +345,26 @@ static void sfp_fixup_long_startup(struct sfp *sfp)
 	sfp->module_t_start_up = T_START_UP_BAD_GPON;
 }
 
+static void sfp_fixup_ignore_los(struct sfp *sfp)
+{
+	/* This forces LOS to zero, so we ignore transitions */
+	sfp->state_ignore_mask |= SFP_F_LOS;
+	/* Make sure that LOS options are clear */
+	sfp->id.ext.options &= ~cpu_to_be16(SFP_OPTIONS_LOS_INVERTED |
+					    SFP_OPTIONS_LOS_NORMAL);
+}
+
 static void sfp_fixup_ignore_tx_fault(struct sfp *sfp)
 {
 	sfp->state_ignore_mask |= SFP_F_TX_FAULT;
 }
 
+static void sfp_fixup_nokia(struct sfp *sfp)
+{
+	sfp_fixup_long_startup(sfp);
+	sfp_fixup_ignore_los(sfp);
+}
+
 // For 10GBASE-T short-reach modules
 static void sfp_fixup_10gbaset_30m(struct sfp *sfp)
 {
@@ -449,7 +464,7 @@ static const struct sfp_quirk sfp_quirks[] = {
 	// Alcatel Lucent G-010S-A can operate at 2500base-X, but report 3.2GBd
 	// NRZ in their EEPROM
 	SFP_QUIRK("ALCATELLUCENT", "3FE46541AA", sfp_quirk_2500basex,
-		  sfp_fixup_long_startup),
+		  sfp_fixup_nokia),
 
 	// Fiberstore SFP-10G-T doesn't identify as copper, and uses the
 	// Rollball protocol to talk to the PHY.
-- 
2.51.0



