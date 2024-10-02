Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433881D07B0;
	Wed,  2 Oct 2024 13:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877297; cv=none; b=XNTiv3aJzyxJsgGfZ0GPFCZqSJK95erkdFV3UsBJ5ylkzgJrJPotUKvv0rogShwHxos0PfKjMSBasw4DUGiEZhQQ8n9PR6rhOBALD73QEp3L3OmY/SYCEVaA2veWg1I7hWLkiliZM8HHf7PUlVfGIGTSXXzhXKewZ0xRFBYoXTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877297; c=relaxed/simple;
	bh=toWg0ItJcfceo9kyf4ikkS6GjK6BKMPxssE+MohZ/xM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js+TtqPWRYhtArDBgufZ4Rd5OK4VOodr7w+gNxBec3Aicc0Czf2aOIDwrgCfd1UIPPdA+XxW7PNHZu0Lrx6vvs1KP01CLdYzEdpSbsGaHoM856X+kkbWXEjqewEC+BsaN6vZnTNPzZ9pb9hwwMY7GIkeD1yZb29Bc6CR4TcyC1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfPOgp9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfPOgp9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ACEC32781;
	Wed,  2 Oct 2024 13:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877296;
	bh=toWg0ItJcfceo9kyf4ikkS6GjK6BKMPxssE+MohZ/xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfPOgp9m3IaeTXAv2GuQN0zoeiu9LonyUNOiNp26TUsbgXJ53yleVIhdu44qKfOxz
	 EPCeEv18pMeqnFaPIbroPULAckKqVowyeMcIp+TIcsT/CxUXvlAj55YP46DAyUMyU1
	 LUM/R4mM2vLENb8gnU+aDa+Go2QtEtsPf7IR0eL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Witwicki <michal.witwicki@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 007/634] crypto: qat - ensure correct order in VF restarting handler
Date: Wed,  2 Oct 2024 14:51:47 +0200
Message-ID: <20241002125811.378960772@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Witwicki <michal.witwicki@intel.com>

[ Upstream commit cd8d2d74292c199b433ef77762bb1d28a4821784 ]

In the process of sending the ADF_PF2VF_MSGTYPE_RESTARTING message to
Virtual Functions (VFs), the Physical Function (PF) should set the
`vf->restarting` flag to true before dispatching the message.
This change is necessary to prevent a race condition where the handling
of the ADF_VF2PF_MSGTYPE_RESTARTING_COMPLETE message (which sets the
`vf->restarting` flag to false) runs immediately after the message is sent,
but before the flag is set to true.

Set the `vf->restarting` to true before sending the message
ADF_PF2VF_MSGTYPE_RESTARTING, if supported by the version of the
protocol and if the VF is started.

Fixes: ec26f8e6c784 ("crypto: qat - update PFVF protocol for recovery")
Signed-off-by: Michal Witwicki <michal.witwicki@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
index 0e31f4b41844e..0cee3b23dee90 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_pfvf_pf_msg.c
@@ -18,14 +18,17 @@ void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
 
 	dev_dbg(&GET_DEV(accel_dev), "pf2vf notify restarting\n");
 	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
-		vf->restarting = false;
+		if (vf->init && vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK)
+			vf->restarting = true;
+		else
+			vf->restarting = false;
+
 		if (!vf->init)
 			continue;
+
 		if (adf_send_pf2vf_msg(accel_dev, i, msg))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to send restarting msg to VF%d\n", i);
-		else if (vf->vf_compat_ver >= ADF_PFVF_COMPAT_FALLBACK)
-			vf->restarting = true;
 	}
 }
 
-- 
2.43.0



