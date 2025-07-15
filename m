Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB892EE287;
	Tue, 15 Jul 2025 13:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587134; cv=none; b=O0KPwtKtqHaoJHv+SVZqoLYefWCQMEw8cO5FhuewtSbboQq7ribFA7xFvr862NhsmzZnlEB2eO/y6K2lEy62UVOskBaj6S8NF7yOxT7IDSzM0Uidsni/ml9PcefVT2Y4mnpRYY3imWzOgU+qnbfxIx7WiC41i3tNY9PDmQDfMmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587134; c=relaxed/simple;
	bh=cVEW7shMxoqNwAFPyCZ1Ofb3Ah5E5ETeLYyE/gEcfzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT2XK3NIgZHZuxml1A0dNRulxQXNs+H/f42Da3SF7xwjfY6APDhYhzv+wy3ayVdke+yp2ICGWOAKLCUmxe+ISb1Hv0+HczCPLaS9O1UghqlySes6XsO4+c71DFPssKj1v6dGi92y9tpXa25aus8VPoCoptR2M/G65CK6LBZfEPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5HMUJxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5HMUJxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1195FC4CEF1;
	Tue, 15 Jul 2025 13:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587134;
	bh=cVEW7shMxoqNwAFPyCZ1Ofb3Ah5E5ETeLYyE/gEcfzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5HMUJxiVTF7eLeotqSiQGRRen1hK9bccEtXMr4ux4cyBIHKHxSGmgrQ4Vo2kvcx0
	 uSZUGcTMDyJzrkqHqrZwteyZF9K+ZAhRlY83sM3bN5c69jgwmGSrUNFRUD+KRObYVj
	 cxvtqoUDQU81OgdWP71B+YxcTV2oHJD7ddb5lSSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Zhang <quic_shuaz@quicinc.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 179/192] driver: bluetooth: hci_qca:fix unable to load the BT driver
Date: Tue, 15 Jul 2025 15:14:34 +0200
Message-ID: <20250715130822.093434779@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index a2dc39c005f4f..976ec88a0f62a 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2392,10 +2392,17 @@ static int qca_serdev_probe(struct serdev_device *serdev)
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
 	case QCA_WCN3950:
-- 
2.39.5



