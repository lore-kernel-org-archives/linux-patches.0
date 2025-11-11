Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E17130EF86;
	Tue, 11 Nov 2025 01:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825040; cv=none; b=OopWmqw0ToV3IjqTOp9OLQtwOb4RWEmaexXYYDelHDlUZDYz5n6MqpiBKlce8tXRQNsMojE/tLqS0iFQRJRODpQ6F58b9xGkj3QMAHWJy5uijUaYOxgYjghjVNbA7yO7NSy8Wus46L6JgcT0M9pPX/ktPkUfWGhA/k3oOV/AFjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825040; c=relaxed/simple;
	bh=wcuYUkrpFSmaqvi0h6AKdO/bbfZpBLOwClZT2ljb3ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lUFfFpsAYwSmUBuOH50ADuhNKvwAkwCI/5NRNFuuUOhDN+xxZO4ZnLZoG4KofISs2l4Tke70Vmb7bn7bIB+NP9FAJfuo0xMcP7VsBoiZOBVjaeUthVMqmaAje7HtqMN0Kj3Fp6ZpPN85EX5lvsNOAdgXRIB2p6DgBVc1D5oWDjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyKRWaRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyKRWaRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230B9C4CEFB;
	Tue, 11 Nov 2025 01:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825040;
	bh=wcuYUkrpFSmaqvi0h6AKdO/bbfZpBLOwClZT2ljb3ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IyKRWaRe88wQNEQcxDf8xCUR6M6/mKJ8TzcUujfofX7v3IhL4cJRlEqtjrLkpO3s3
	 JYT0Wm3ci73Sk/nfqm1dLjwQDU5ETnyx6b7gWKf24Ej+HWMvuAlOL3Qr9r4EboyMIL
	 TNmo5dWyQWybX1qkB1m9qOHDnygVfMQqJ+O797BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 636/849] scsi: mpt3sas: Add support for 22.5 Gbps SAS link rate
Date: Tue, 11 Nov 2025 09:43:26 +0900
Message-ID: <20251111004551.807053513@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 4be7599d6b27bade41bfccca42901b917c01c30c ]

Add handling for MPI26_SAS_NEG_LINK_RATE_22_5 in
_transport_convert_phy_link_rate(). This maps the new 22.5 Gbps
negotiated rate to SAS_LINK_RATE_22_5_GBPS, to get correct PHY link
speeds.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Message-Id: <20250922095113.281484-4-ranjan.kumar@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 66fd301f03b0d..f3400d01cc2ae 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -166,6 +166,9 @@ _transport_convert_phy_link_rate(u8 link_rate)
 	case MPI25_SAS_NEG_LINK_RATE_12_0:
 		rc = SAS_LINK_RATE_12_0_GBPS;
 		break;
+	case MPI26_SAS_NEG_LINK_RATE_22_5:
+		rc = SAS_LINK_RATE_22_5_GBPS;
+		break;
 	case MPI2_SAS_NEG_LINK_RATE_PHY_DISABLED:
 		rc = SAS_PHY_DISABLED;
 		break;
-- 
2.51.0



