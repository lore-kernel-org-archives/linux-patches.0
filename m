Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1646046EC9A;
	Tue, 21 Jul 2026 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661152; cv=none; b=MSjF1wNu2+VoGyrggEvJOM/lEeoCvOp32S65LyrUs9wbjVJao6w1FVWoDAUChSE9gZnxg4UsAWfdW5DIQjNRMJS5R8Ht7A0YJwZQYtOuVn98qm9f91DHKzeX/KUPqZv+G1UdN+C8i1VZjE444B8n6KUiE5bF/FTMMluFkr7xnok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661152; c=relaxed/simple;
	bh=eLYLmYlFshQL0eqKqNODBjdFpgzihl4ySR8kxSN9RZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArdS1UtxI4U+3LzwbJt8hD1bnk/cYGL17tpsXLp8Wo4Ym9ptB4px3P3CvZ5LjRYHnIA7rYFYPIkSrFXUsRNH6DJmqpncSfwh2cg8bfPAOE77DQyheEK1LYdmaQrNWYFZJk0DekGwlqwcGStAR6k5lafFMGhzUWUI92R3tJfg/Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sofBXCvI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sofBXCvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3EB1F000E9;
	Tue, 21 Jul 2026 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661151;
	bh=NrUQJsEAOHqwawMx1uCi8um29erBJh0z+D3nv+Yfxsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sofBXCvIK0289jnnVchgs0bJ/Vx2eOuEwHPTNW6Zsm9IwFfl+IIRC5+zjtlIfBH7Q
	 b/EjZFOJ4VPtJOL9WUBbez3r20m3cF10yFcLsvcH4Shbc9KuJkYkIhOY00grviAY7l
	 Bn8QJy/bHD0RCt2i+VOiaARe82mICUdHiTFGP3TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1243/2077] PCI: endpoint: pci-epf-vntb: Exclude reserved slots from db_valid_mask
Date: Tue, 21 Jul 2026 17:15:16 +0200
Message-ID: <20260721152622.132578371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 823468a4ea1613f1c1235bd16af8b9c6eb9c9677 ]

In pci-epf-vntb, db_count represents the total number of doorbell slots
exposed to the peer, including:

  - slot #0 reserved for link events, and

  - slot #1 historically unused (kept for compatibility).

Only the remaining slots correspond to actual doorbell bits. The current
db_valid_mask() exposes all slots as valid doorbells.

Limit db_valid_mask() to the real doorbell bits by returning
BIT_ULL(db_count - 2) - 1, and guard against db_count < 2.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260513024923.451765-7-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 01d28a7d35df4c..ff9db8f980af56 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1268,7 +1268,10 @@ static int vntb_epf_peer_mw_count(struct ntb_dev *ntb)
 
 static u64 vntb_epf_db_valid_mask(struct ntb_dev *ntb)
 {
-	return BIT_ULL(ntb_ndev(ntb)->db_count) - 1;
+	if (ntb_ndev(ntb)->db_count < EPF_IRQ_DB_START)
+		return 0;
+
+	return BIT_ULL(ntb_ndev(ntb)->db_count - EPF_IRQ_DB_START) - 1;
 }
 
 static int vntb_epf_db_set_mask(struct ntb_dev *ntb, u64 db_bits)
-- 
2.53.0



