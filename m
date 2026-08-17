Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2071E43BDA7;
	Mon, 17 Aug 2026 13:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974117; cv=none; b=lmcw04vtYNunfl8eqr5dRgL20SqBaPo4px1Hte0sVA6d5qpPqVv9MqTk4/cN4PCnVDe6dMwJXHVF6NwHaTnBy3pucVMzlaWNT7RQwNhsvT7kA0FRv3Km5yTVIGtk5Si7C/puKTLueqb0ZzTWQ8mr79IBvKIgxbY6iw8w2sL/vhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974117; c=relaxed/simple;
	bh=5MT1o3Og/ihoqYukMi+RunXLjkl9xWaxAHQJ+rvADnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8vvvnFFC+4+gKVJB9pxcp901bqKYfgb+iEj/DgRjwvLdz+g0RNDrWhXk66q61tcmPFt7dTGc59zzrH5u1OgBVYKgtd+psHb86m/GwNKZ79Kp5me0t/2NB8n9PMKmqyf/Y/THHds2cAl84Fg+sae+atYybgcd3L/yOrlqkl9urI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ilsO/acJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ilsO/acJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646871F00A3D;
	Mon, 17 Aug 2026 13:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974114;
	bh=7yCs2sK9lI3Ss9itzOFiD9+67mQPAjHYzrK4ATsKjEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ilsO/acJ2KCrRAREpRyPdVxDhrEN2NsukaU3aV7ciCoT54ZU1OtzYTZrihBSSJ6eT
	 0QkFUWUfsq12uJIBfj4p1CMIIyrJrBhMN4oIm7qdEuA8DaT/4HDbe3ClrkfvRBxPA7
	 YOETr7SgSti1o1Xr0UGWA7X1zZVPqiPukF9quyjg=
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
Subject: [PATCH 7.1 095/271] bnxt_en: Refresh VNIC default ring on queue restart if needed
Date: Mon, 17 Aug 2026 15:30:20 +0200
Message-ID: <20260817132540.690115013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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
index 4ea6adfc5c22a..e7145537f3e73 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11098,6 +11098,11 @@ static int bnxt_set_vnic_mru_p5(struct bnxt *bp, struct bnxt_vnic_info *vnic,
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



