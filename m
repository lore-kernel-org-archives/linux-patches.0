Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8901C3318;
	Thu, 28 May 2026 20:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000160; cv=none; b=UkmzVJOILwqM4QdQbkQuDl1Ribuv0OycwxWyhB+odRrsaeFDFHFJonA8197OBOPPDUj+EQ5/jW4fSKbjsm6mpxv1N3rGRq8gIbHs0/e5YJQZpMcS9CK0ldxqZV0FPE7DbAS/Wa/+xD1lelU6yLKX/MLuarBa5/LNmctvN8rCxoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000160; c=relaxed/simple;
	bh=tmB68RTZtPPbE+F5ozsXtx3CxtLTVzVAqJLw41DsGuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSu8+C0D9tgqwgBTyI9Aj2KiNqDcg1zDegYDfcB8oBwcE9zlpU7BWCeL3TYInNzKd2Ocpp152NIrCQuYlBVE7Q6jITbIzIdrWmmfLQF3aAXrjmEoEIAEVKnHTEdSC4CwxY0+uOjva2ibUmzB4G5UVeu5pCQPZBmH8g1oIu2b978=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbTcwVbx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbTcwVbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E375F1F000E9;
	Thu, 28 May 2026 20:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000159;
	bh=d1/DJty51tJxVc7DD6BiRFXbw2jlpI4Pu4kGE2Jp1vI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbTcwVbxloEW6w+qA2qllbtG2ER9MuOQtgLEJPkkc10l6MVaQaFFVCSZHtm8vdgGs
	 7YXSOTltgsnScHwAublGaluvGXkLLPLDrHXwnmlWTO1lpecg5ETDCqcShRN0deY2jE
	 nuERYr7J2FOxRbXbTMwXukHyQBTNl/639v18Fp2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <kohei@enjuk.jp>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 324/377] igc: set tx buffer type for SMD frames
Date: Thu, 28 May 2026 21:49:22 +0200
Message-ID: <20260528194647.788601828@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Kohei Enju <kohei@enjuk.jp>

[ Upstream commit 5acc641e590e008caaed480ed9ffae47cf7ecbdf ]

Sashiko pointed out that igc_fpe_init_smd_frame() initializes
igc_tx_buffer fields for an SMD skb, but does not set the buffer type:
https://sashiko.dev/#/patchset/20260415025226.114115-1-kohei%40enjuk.jp

Since igc_tx_buffer entries are reused, a stale XDP or XSK type can
remain and make TX completion use the wrong cleanup path.

Set the buffer type to IGC_TX_BUFFER_TYPE_SKB.

Fixes: 5422570c0010 ("igc: add support for frame preemption verification")
Signed-off-by: Kohei Enju <kohei@enjuk.jp>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260515182419.1597859-9-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_tsn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index 02dd9f0290a34..52de2bcbadbec 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -34,6 +34,7 @@ static int igc_fpe_init_smd_frame(struct igc_ring *ring,
 		return -ENOMEM;
 	}
 
+	buffer->type = IGC_TX_BUFFER_TYPE_SKB;
 	buffer->skb = skb;
 	buffer->protocol = 0;
 	buffer->bytecount = skb->len;
-- 
2.53.0



