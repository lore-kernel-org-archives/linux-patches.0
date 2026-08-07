Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FCC4749C4;
	Fri,  7 Aug 2026 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116933; cv=none; b=pbgCsR1CbeQ2LPIU9ElB3hCvIsrf1uJjE86riI//Oo8qucefWASd3sGAa5CI6wR0d37jLN1iekm29yDVbrN42ETBknRbEobzQ+Bvo1ocd5UorveCt2C2ZU4tDDywcIUU/dFi7kFd1O74hIrFXfHCGtiMLLvGWg/eAfI9QEMy3PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116933; c=relaxed/simple;
	bh=agFUz7Q3PwrOq6BTAMoA/4BGWOJMybnE5Np6Nd6KqE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSFOlF5BRpH4idpVJOS0ONVp/QwXye37OYdEdlTSCeSfooBlEz1XFVa7ujCAe0i0DHRw4p+APU3vYxRodYGomET06Sc+ahAweZMjMXgfZ4wfK4W4jdzTP18r6sWW03XoNIh6ZLCH0jG8uFZTugvEZcMP5Cuu7M2SrwlZBw//UT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjVsoVqS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjVsoVqS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50FD21F000E9;
	Fri,  7 Aug 2026 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116931;
	bh=ET6Sdp/TsnvsApURiPslOY2+mB1M0qkzX1pEf5Sbf/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TjVsoVqSvOsjXbtkyi52WMTwPfb8X3NrYwpvhlRjl/v5VACL6iek4D2YPomUvTmwP
	 uutdZL+va6OrhYmRW2YGVb88MDOHmNx8huyHnUUdqIdMXsXQ+1qGmSx/28FvW0BdYd
	 ILpUqk9PepW4Tca9gRjlNCb0XZOUD9SVRqSO1pt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 141/438] Bluetooth: btintel: Validate length before parsing diagnostics TLV
Date: Fri,  7 Aug 2026 16:35:37 +0200
Message-ID: <20260807143431.009910091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit b640ff9af3c809ff5ea2077fbba17df1594ec1e4 ]

btintel_diagnostics() accesses tlv->val[0] without first validating
that the diagnostics VSE is long enough to contain that field, so
may cause reading data beyond the received frame.

Fix by validating the length before access.

Fixes: af395330abed ("Bluetooth: btintel: Add Intel devcoredump support")
Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 5e9cac090bd8f..bf567b7c5f00b 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3771,6 +3771,9 @@ static int btintel_diagnostics(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct intel_tlv *tlv = (void *)&skb->data[5];
 
+	if (skb->len < 5 + sizeof(*tlv) + sizeof(tlv->val[0]))
+		goto recv_frame;
+
 	/* The first event is always an event type TLV */
 	if (tlv->type != INTEL_TLV_TYPE_ID)
 		goto recv_frame;
-- 
2.53.0



