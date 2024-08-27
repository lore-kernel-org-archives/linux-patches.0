Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A541E520;
	Tue, 27 Aug 2024 15:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771402; cv=none; b=Dbo/g4zP/WUM7vI2tayG13n/LFwJkpThpy+fEtvrdUZ+g6RI6Rpp7OTdgo9axtghrrF2xQVaDJhkTf7ZlGzQ+XX655R+i/J2AJg6qU75Sz3GSZHyjAhONWQu3OBsuh1kQ4LvtlKd9J+YtlLLpqMjAFarZpr7dzsywvvqTZypsys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771402; c=relaxed/simple;
	bh=GSeG+cGfEbHnJ3hu0RTqrn/kGivG0W1MZHbr9d1BwQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kr10FDy2ZQblDeOOYQelHQZtbEDbI1dYd4h9Q5E56E0WA2ZGIluQtFdI23hVSsTy1pxns6jrzYEjXIU1R2rtysmCOvaQIQP51utAJF8z6A5ez/BzbLuf2FlvKiKmPGYBeO5yCJtUnq9X2ckeqhTz2vU+BCoVQ+5LxD+IPeX9gyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qm5+Hkb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qm5+Hkb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D71C4AF52;
	Tue, 27 Aug 2024 15:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771402;
	bh=GSeG+cGfEbHnJ3hu0RTqrn/kGivG0W1MZHbr9d1BwQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qm5+Hkb2bsTnGwVD47CltP8GmVGWPnvEGeiFX9scZnYqYV9Ssc6dEL2vKzCuB8hDk
	 sL9WuxafgbdKSR+yFxmy/a9uvGQ929aMLFT4Ur2lAgrvQ59MWx5rWPvufSLXQVG4ql
	 tIfL8lH0t0XKcyLEyTbilfy/++tfmU2nuy9dY88M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 178/273] net: dsa: mv88e6xxx: Fix out-of-bound access
Date: Tue, 27 Aug 2024 16:38:22 +0200
Message-ID: <20240827143840.185542142@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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
index ce3b3690c3c05..c47f068f56b32 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -457,7 +457,8 @@ static irqreturn_t mv88e6xxx_g1_atu_prob_irq_thread_fn(int irq, void *dev_id)
 		trace_mv88e6xxx_atu_full_violation(chip->dev, spid,
 						   entry.portvec, entry.mac,
 						   fid);
-		chip->ports[spid].atu_full_violation++;
+		if (spid < ARRAY_SIZE(chip->ports))
+			chip->ports[spid].atu_full_violation++;
 	}
 
 	return IRQ_HANDLED;
-- 
2.43.0



