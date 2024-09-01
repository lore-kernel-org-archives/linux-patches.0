Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A1B2C6AF;
	Sun,  1 Sep 2024 17:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210294; cv=none; b=GpFfwcBbXNap6AnIrc8538aVpNWhaRZ0I1TQgHrxu2e+FAv+LTDUiUDltRVMkZEaxne+D6DsdPqe80ycWdlsYKWCT28Dcq23waezBiNa8S3BqE/R6Rg8n81ia/siHx+uXd25QBW0FiZLXFBcns9gdX+EsjnbSw9+NWylbziuUSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210294; c=relaxed/simple;
	bh=ScyNYBPrsAacAEjVtagoECfsUx2KrPcih82ibX24EPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAYJADUT1Dl+gxJ9hCy0Uk/0H+M8B+uzfAG+UxZBIqXEB/SG1nxjg6bjFy+4wA2YlqCTxsrzqTNOYpSzpolsvnvIMotQrufHnUVQCBe5Y7uCtVsBOo0ee3cEvi1B7jNOY7Q7MOMOB7u0OGU/VGy8qzQ0i/SKooTjb4Rwa7BmCQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaVXBsJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaVXBsJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DD8C4CEC3;
	Sun,  1 Sep 2024 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210294;
	bh=ScyNYBPrsAacAEjVtagoECfsUx2KrPcih82ibX24EPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaVXBsJYYONI9xGTmjdr2LQ2rjPILZiyiBrIAuqn5BRMzE+fbwKMPG23ZD7ilUt30
	 UlabONeu3vcwiyz1os/3qQf+p9lTTLszk061JTnITb3VHSUqVHIO+7hOhu2xpc3r79
	 f0hI5TK4KmPO44OdSkFkZuXyLauAAHn3KpzJqLqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/215] net: dsa: mv88e6xxx: Fix out-of-bound access
Date: Sun,  1 Sep 2024 18:17:39 +0200
Message-ID: <20240901160828.922952006@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Huang <Joseph.Huang@garmin.com>

[ Upstream commit 528876d867a23b5198022baf2e388052ca67c952 ]

If an ATU violation was caused by a CPU Load operation, the SPID could
be larger than DSA_MAX_PORTS (the size of mv88e6xxx_chip.ports[] array).

Fixes: 75c05a74e745 ("net: dsa: mv88e6xxx: Fix counting of ATU violations")
Signed-off-by: Joseph Huang <Joseph.Huang@garmin.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20240819235251.1331763-1-Joseph.Huang@garmin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 7c513a03789cf..17fd62616ce6d 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -453,7 +453,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 		trace_mv88e6xxx_atu_full_violation(chip->dev, spid,
 						   entry.portvec, entry.mac,
 						   fid);
-		chip->ports[spid].atu_full_violation++;
+		if (spid < ARRAY_SIZE(chip->ports))
+			chip->ports[spid].atu_full_violation++;
 	}
 	mv88e6xxx_reg_unlock(chip);
 
-- 
2.43.0



