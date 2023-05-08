Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7560171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:38:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6284FC433EF;
	Mon,  8 May 2023 11:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545908;
	bh=cRF8IdYJmcwdjIwJ+X3lG1wehdBLCNHu8UCeGwYF150=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5Ds1TFhxlsA1ryc1PPCHVdMc3mMImPsBnw8fyyYnqIp2kRy6GgpAPMNLbdHeJcJh
	 vIqeBQvHnC4SsiTXxKGReYY+U05Fu+vVhXgeFoE3+sctu8u/dlnEynHU/4ioLQcGNp
	 5orrrCMNnLekwAHIqhmDpl0m4nvnxS6/3pNHswpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/371] net: pcs: xpcs: remove double-read of link state when using AN
Date: Mon,  8 May 2023 11:46:04 +0200
Message-Id: <20230508094818.576346677@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit ef63461caf427a77a04620d74ba90035a712af9c ]

Phylink does not want the current state of the link when reading the
PCS link state - it wants the latched state. Don't double-read the
MII status register. Phylink will re-read as necessary to capture
transient link-down events as of dbae3388ea9c ("net: phylink: Force
retrigger in case of latched link-fail indicator").

The above referenced commit is a dependency for this change, and thus
this change should not be backported to any kernel that does not
contain the above referenced commit.

Fixes: fcb26bd2b6ca ("net: phy: Add Synopsys DesignWare XPCS MDIO module")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index fd4cbf8a55ad7..556ca98843565 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -309,7 +309,7 @@ static int xpcs_read_fault_c73(struct dw_xpcs *xpcs,
 	return 0;
 }
 
-static int xpcs_read_link_c73(struct dw_xpcs *xpcs, bool an)
+static int xpcs_read_link_c73(struct dw_xpcs *xpcs)
 {
 	bool link = true;
 	int ret;
@@ -321,15 +321,6 @@ static int xpcs_read_link_c73(struct dw_xpcs *xpcs, bool an)
 	if (!(ret & MDIO_STAT1_LSTATUS))
 		link = false;
 
-	if (an) {
-		ret = xpcs_read(xpcs, MDIO_MMD_AN, MDIO_STAT1);
-		if (ret < 0)
-			return ret;
-
-		if (!(ret & MDIO_STAT1_LSTATUS))
-			link = false;
-	}
-
 	return link;
 }
 
@@ -847,7 +838,7 @@ static int xpcs_get_state_c73(struct dw_xpcs *xpcs,
 	int ret;
 
 	/* Link needs to be read first ... */
-	state->link = xpcs_read_link_c73(xpcs, state->an_enabled) > 0 ? 1 : 0;
+	state->link = xpcs_read_link_c73(xpcs) > 0 ? 1 : 0;
 
 	/* ... and then we check the faults. */
 	ret = xpcs_read_fault_c73(xpcs, state);
-- 
2.39.2



