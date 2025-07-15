Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148C72D5426;
	Tue, 15 Jul 2025 13:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585728; cv=none; b=nRCW4hOMP/45OFMsOgPPe5ro9l88/10y0FdnyqgfFkJgTQ8lX3Szjxacr4tnFxWXyRO8N3hqSn8eCy54u7e7ovxg0RBbySiJsP0vx5R3pzXw4QLQrHbLGToVazg/9epkqtvuCuexbYL+XAVu/pPTvs2vTHfvpHyc0kgMQoJyrzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585728; c=relaxed/simple;
	bh=gRj2AecfhSPzYrYRfsfyGQ5o8ltOw83OBRmU+1Vpdyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXM/6X5eyyvZxKaitiqWUJ+L9/FxsD3XQ5U6R9dpNpDjtS2FiB280iTs0xorjGe4xlkOe8o0LAFEqpUvV3p2qu/y0VwXVv25WiBoavIAGF7X5Fk5KHKfxYdaTv12Z7PhfH9i1MdTzTVtGZKKRs/AnqmlQgc0r2r7PRCo+1G362o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqjW5xb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqjW5xb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFABC4CEE3;
	Tue, 15 Jul 2025 13:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585728;
	bh=gRj2AecfhSPzYrYRfsfyGQ5o8ltOw83OBRmU+1Vpdyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqjW5xb6uGrPPOUKj7wsj+p6AV4UCDEShERjvBTDVL7UZ6eEpqC2jHh3Jgy3qkKVL
	 4RQqcQGBCxVncGDyrTRv0W9CD+FaPEJvl6QNSVC+Ke3wKAdRliyHqjayRglAYwxHJy
	 BOoJQ8xmTy3S0pyJ3LqmcLH6IqgWeyYEr5D9EyiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Zhang <quic_shuaz@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/163] driver: bluetooth: hci_qca:fix unable to load the BT driver
Date: Tue, 15 Jul 2025 15:13:36 +0200
Message-ID: <20250715130814.769798434@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Zhang <quic_shuaz@quicinc.com>

[ Upstream commit db0ff7e15923ffa7067874604ca275e92343f1b1 ]

Some modules have BT_EN enabled via a hardware pull-up,
meaning it is not defined in the DTS and is not controlled
through the power sequence. In such cases, fall through
to follow the legacy flow.

Signed-off-by: Shuai Zhang <quic_shuaz@quicinc.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 025b9a07c0875..e6ad01d5e1d5d 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2363,10 +2363,17 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 			 */
 			qcadev->bt_power->pwrseq = devm_pwrseq_get(&serdev->dev,
 								   "bluetooth");
-			if (IS_ERR(qcadev->bt_power->pwrseq))
-				return PTR_ERR(qcadev->bt_power->pwrseq);
 
-			break;
+			/*
+			 * Some modules have BT_EN enabled via a hardware pull-up,
+			 * meaning it is not defined in the DTS and is not controlled
+			 * through the power sequence. In such cases, fall through
+			 * to follow the legacy flow.
+			 */
+			if (IS_ERR(qcadev->bt_power->pwrseq))
+				qcadev->bt_power->pwrseq = NULL;
+			else
+				break;
 		}
 		fallthrough;
 	case QCA_WCN3988:
-- 
2.39.5



