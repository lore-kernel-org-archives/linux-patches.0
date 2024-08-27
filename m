Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6F81C4601;
	Tue, 27 Aug 2024 14:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770558; cv=none; b=O7YfWZhr4m6YU5zPPHrGAyDRKzfaIUSKwBcO8MU2wwryur//IgYBr4pz0PGeSEpM31Qh4ZWtGGaBen0VdCQC209yb6qsCHC31+ZfB1hziJertt/99jf5uPp4qRXP+/jfOrwAFJhjGaQzd+wD34+IkMNsw8zFcUzBD0Dq6tjJAx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770558; c=relaxed/simple;
	bh=6Mq2D+wQ1OuhftmFRp9lD8out6l5yAhyUIommGXiXt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gc57dZ+aUOiaURGds59CnyP/TmoiXNSFWY0wYoqykb2V+PRYIxE4Wf4olYckd0ZQlgFqHlkD9D48PLbbuFtor66voncddeEiGy+bGvMSmfgQ2FmR6E1uwrnN1S0FIayTqWiL3BLsOKyBAI8FVtNQ3W36lVMB2QKHtgodIseq3/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kToLhfhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kToLhfhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A54C4E699;
	Tue, 27 Aug 2024 14:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770558;
	bh=6Mq2D+wQ1OuhftmFRp9lD8out6l5yAhyUIommGXiXt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kToLhfhukIgimr6Jcg/fsAUL+4+zdonftVpeoARgwYeHnV/nlDh4jwdmfPjgMijEK
	 0jxdaLA6GLxq8sfIYFTNqx4lG4U9wRoD1toTVZcUQw6mHIZN/Kha5ba8euE2A0Ormk
	 jLlQaTaFpxOBWogfhjIdKmpsqmwZ8fRMfu7McfG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Huang <Joseph.Huang@garmin.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/341] net: dsa: mv88e6xxx: Fix out-of-bound access
Date: Tue, 27 Aug 2024 16:38:16 +0200
Message-ID: <20240827143853.490130442@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



