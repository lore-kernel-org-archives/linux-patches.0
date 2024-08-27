Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB0419F485;
	Tue, 27 Aug 2024 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772551; cv=none; b=DlcDHIdRGs5QmulS5mKmufhFI+wj53JHiNCAfNYK3NjijEuOuNM2YbhUSdmD2C7/RSi7z5taKrbuSAYGgMlCLQLRMJ25fPusYpoV//PJcW1/y7sW2Bq57v4AwZUxamayUaCZPa8hQDjhDZQjdacy3ramN7hGAY1qIzN0C67hstg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772551; c=relaxed/simple;
	bh=Vv4tBNx9pH7CyYplIOfEJ6aZtkQnNPq3MovZL7LUMFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkAX+5ngP5tZauucSoyE/I6ZkfRdJPf4wBosYjPOM9bsA6GC4YaetjYXz9vslWqei2YPcIG0Xcxwn9pwI0L3VP6v9fYlZpYtjdVfn6nhqHCzVf/GOtZtOFYqreUN5vGOjcdfESmzvGfO/JdLru39juN93893Yr6E1VvcvuB1kqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDLy0MgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDLy0MgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B83C6107E;
	Tue, 27 Aug 2024 15:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772550;
	bh=Vv4tBNx9pH7CyYplIOfEJ6aZtkQnNPq3MovZL7LUMFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDLy0MgB1GXlZAla3C/zbm5k3srvVQ/v+J6fEN/kwPrj6tf+UCD/NQ+EJ42sjSsz7
	 HAPq/b4Kexh542fXbsnsKGE8qdgi6yi2/QwoGklYrGqAOqMcmaxJ/rkEDK8t4daptP
	 WGPIZv4Ko5ez9PiiXqGzY7LcnnSYIJuadypW4SEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 249/321] net: dsa: mv88e6xxx: Fix out-of-bound access
Date: Tue, 27 Aug 2024 16:39:17 +0200
Message-ID: <20240827143847.723581130@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



