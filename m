Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB7442CB0D;
	Mon, 17 Aug 2026 14:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977946; cv=none; b=EZ/30fruGASn8N3VXJ47eV5SxQI6rJPprHNhZaGBM3wnY+lKAoS4rjyOLeSG5eMr85R9srVAwfl/2rFYKBHo/sR3wT0Ui8JoGoiNBUu44XyvlofkrO9pkqF1shKDASKXjEk5tCQeYgOxfqFwVELzbxFC82zum/kgvm58/5+2RZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977946; c=relaxed/simple;
	bh=u1AgHiyaccYVL3ebKJao93uaYELGCZ1Vv6i/S8DSuak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3Oq3j8GlpKhtfnM/SjxpjLdl1ytc0sG/MmptJIBwm8SX0HV3cjn7jkEIyquQKO1VQrPy1he5rTrJCnftJuKX5bmCu5agXerd2soY1nHxAnHQDGpy14gBiwEpBEX7t5MZ4GUV0DW/tQzb40Dzqe9NOcqiG9e6nXCDTPl3RbuOjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/s2fWHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/s2fWHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F22D21F000E9;
	Mon, 17 Aug 2026 14:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977945;
	bh=SAmQ27DMK0a3Pj0y0HcTBgB70n8oJv/cmlI8i8D2BCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/s2fWHL+UIVBBRMQOtyIJ8OgNkcr9aO+8vN26oaUUhDTCJIi6FYLmX6Ii3Ak5Tjg
	 BLAWseqE8klM2i36/Rfmvj9G+ct3BJ6oQW5TiddWywH+epqr9ZX1S3VV3w1zL1gpGg
	 gpJZZyXhFyH6GMP0Ccho/69YLt7AFMmZuALas0XE=
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
Subject: [PATCH 6.12 049/181] bnxt_en: Refresh VNIC default ring on queue restart if needed
Date: Mon, 17 Aug 2026 15:32:23 +0200
Message-ID: <20260817132537.327976086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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
index 31971a45ac3d4..2356b7ba7fcfb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10531,6 +10531,11 @@ static int bnxt_set_vnic_mru_p5(struct bnxt *bp, struct bnxt_vnic_info *vnic,
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



