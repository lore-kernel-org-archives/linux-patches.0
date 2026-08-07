Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7EB471275;
	Fri,  7 Aug 2026 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114998; cv=none; b=QKzDlgB1FulsiCVTNJpKAQOS5cpTlWblOukaqdxqEcNPM+betmCNZASYgQutIk05AsLQ5SvqIeTGxJyJE0TjhXa7/8U0u4ztS98OrzU3vw0lo4T0IThUhv5jtsY6X6eq+qfEM+ZYg+D+qIXAxdPX66LhbmLfQoM7HWqPs4hDAPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114998; c=relaxed/simple;
	bh=TOd95fw/axbFRcOhjL4E5PRxScWPnsV3s4eoFJeeTYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHJQlgwyEEWkfSGk9ZNoYJLwTsa+gJPhNVzpEPASeJe6QCOWUvIHW4JrJtwsRgtq8+32/58PaUc6br7tp5Py8Ja5kcBsfWt62xJPx8AaftWWwA2QnAEP8lKjHkgBO1gBLWI+9cnAEmEeFjYRdkmRCqWoSQ8jJ9uYg935pEONYqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuRhlxDY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuRhlxDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455A81F000E9;
	Fri,  7 Aug 2026 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114996;
	bh=cjOFo7lrbsi1+8WQ6jGJoriv3wyJs+wY7qGyJSlQxZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yuRhlxDYqIcZBrrJSmc8ufMLxPJ7EUwf3o8mCOz2yMJswQwODNJHhHQnBv3k8SUXR
	 NBxrig/SUak+dgWoF9NiPGDErHcGSTH2zvfM1eUWAdnaKJJuZc+EkVEDK8jS+9hmXp
	 XPq9SAU9UGUfx2haYZzmLghm3IUwBigJ+P7Zk0Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 121/396] Bluetooth: btintel: Validate length before parsing diagnostics TLV
Date: Fri,  7 Aug 2026 16:34:41 +0200
Message-ID: <20260807143426.915660121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5e0a05edcbfd1..4d6b6bbb4267e 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3694,6 +3694,9 @@ static int btintel_diagnostics(struct hci_dev *hdev, struct sk_buff *skb)
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



