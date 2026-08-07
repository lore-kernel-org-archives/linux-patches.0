Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE8C305665;
	Fri,  7 Aug 2026 14:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113981; cv=none; b=ILI/5kxkoAnU573R2/4ZloGfNuIKP5loRcztADnAh3+cE5pjHU4gpJC70t/KuFX/rGtLbp3W+7U9U3XzaQ+E3Zga7/bE7oQJ8k0n565zwu8aKZtQ/GwkfsRm9fVLyYeEq6FzmldGMh7MMD0IVFtIxDjW+ca2m9usDk6BROKY+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113981; c=relaxed/simple;
	bh=vdFSLVpoqhr31uOGgWYdNzzLQPmM0bvacQgT517xPRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIroXv8/Whxx1E5a6W/fC4lrcdGr0M5MVAxQvotJpn9dLSZKd7bY5JzdNKoBbffVxMWP30gdUNdgWYwKiaktPEA1lLhcXrrQa4dQbwy/JDH12IJfFEysf68ppw8w4z5KgEsZ4vs3YjVkFYyY1ZKmJfant4d/YX9nTU92oJN5oDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FOPe3zu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FOPe3zu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7178F1F000E9;
	Fri,  7 Aug 2026 14:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113980;
	bh=kO8QTvL0ulqT6Xxh37cQlI33rB6s8Mao0iGntOMK398=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FOPe3zuPHJ74JnHtsG4HCYBNC/Lw9Uu2gHL98qtV4/wnBSM3bRFXeLOhHZYlBfVF
	 d1bbF8uRAXlymksD9epoBQ+K5XsAbOo1k5g/nit8zpOdWf+UEvYOqdZG1zrwEuX+pT
	 aA7rjGb9RBad5Ww09hyva07aEfHzFghD+B9OMnr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/337] Bluetooth: btintel: Validate length before parsing diagnostics TLV
Date: Fri,  7 Aug 2026 16:35:05 +0200
Message-ID: <20260807143420.749433528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6e3e4a817e727..cb948423a9bd8 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -3335,6 +3335,9 @@ int btintel_diagnostics(struct hci_dev *hdev, struct sk_buff *skb)
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



