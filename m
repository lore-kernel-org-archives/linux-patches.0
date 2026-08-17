Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333743E3C4F;
	Mon, 17 Aug 2026 13:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974880; cv=none; b=J86AjQ/Yr6KbJfxlURzoaEG+/eBQELjIkwIukJJiSCkXhSH+sv6QfpsU0QhyIsENB1Pm0XD7UzMo1ZBvRyRwbwZlvzv4M6GRhpqPURroqf5aL+iCyeptkWHCCKVHafDdWMx6aliQ9i6HNcpRkR2ZDlYyUoMA6DIWLu38GuSXxjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974880; c=relaxed/simple;
	bh=OKWR0f0U+V7evtTUNuN6TadbPJboaxC0nw+NHMlhTvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfQSBOjb7qIEpGtPcay/oT7WzX9CAa9aKb12GtIt09JkUlWgEqBKJr++LHBRASn1+cUSAMR8cXvXANzSO3V8yoixizNclm4jqpAahULy6is9TjvP1xCsyV3yrvjKh6jdJABVyJeEr4cxRDJ93tI8GbWLY8h5bkxDyVi6GPXpFYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0tQB7/L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0tQB7/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3C71F00A3A;
	Mon, 17 Aug 2026 13:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974876;
	bh=JWx9ZH8sRE3RIZwgsXRflujlx15lCiPw5ipQTbccbck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H0tQB7/Llz1RehPa09a6KlBIRr3ZCDQf090hg9CGZA2JKYqMvuryfazHOZNuvzPOD
	 nx5KjEXfMT5PEn+a1cb5irT8TvJUBGymh+0bZFyy0mTolP+adxOHuM+8OH8n+RfAk+
	 GmFSQhec1drQDlzfG07foPCeX1WhMo8GnYOmt4GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/250] bnxt_en: Refresh VNIC default ring on queue restart if needed
Date: Mon, 17 Aug 2026 15:30:47 +0200
Message-ID: <20260817132539.984138230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Shravya KN <shravya.k-n@broadcom.com>

[ Upstream commit 0b137529a8997caf67190ca1d71ba8bbdb44fbfb ]

When a queue is restarted, refresh VNIC_CFG for all VNICs whose
default RX ring is the restarted ring.  This will eliminate this
possible FW warning caused by a stale default ring in the VNIC:

FW reported unknown error type 10

Fixes: 5ac066b7b062 ("bnxt_en: Fix queue start to update vnic RSS table")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20260731190937.807270-4-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index df5fd228d84ae..0d6b6866154ab 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10954,6 +10954,11 @@ static int bnxt_set_vnic_mru_p5(struct bnxt *bp, struct bnxt_vnic_info *vnic,
 				   vnic->vnic_id, rc);
 			return rc;
 		}
+		if (rxr_id == vnic->default_rx_ring) {
+			rc = bnxt_hwrm_vnic_cfg(bp, vnic);
+			if (rc)
+				return rc;
+		}
 	}
 	vnic->mru = mru;
 	bnxt_hwrm_vnic_update(bp, vnic,
-- 
2.53.0



