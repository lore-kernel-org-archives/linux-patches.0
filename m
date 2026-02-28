Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A920F4A33F1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300994; cv=none; b=SYDJsdflsI8lV0vDGPd0YxU4tHweig1kbdbD/55nqAv/HlqkfpVgQfdA8z84iA3g4by/DRl9Cv54iwdBtW0Pe7nLmnH/lSOwC5hD0+otTTy56lsw4yyQwB5vU/u69uLkIcOfjaTh8Q7pTN1teaagqFNzuKoUr+XjYFRvi1zSsk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300994; c=relaxed/simple;
	bh=iIt6d5bJBWv/HXppUH7hgW+elfsL6jgbAZ6J2R5Bz/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K16X9iuuP+A9W0/WQ2MRbxSwVbfqdn0hmdKDk7y8ZaG7zlE0oN2vP2iRR+vXKRRkLJgDZZteP6/1XHnHkrpNf1wpM/RQuUm8NTC1+DDMBc8tnlDm+6nn2DtYwaxoOt17fy10rpbC5JPXyT84mRy4ZF6vsKTjteKJ/seryCwgwG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBWvaUt0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBWvaUt0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8658BC116D0;
	Sat, 28 Feb 2026 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300994;
	bh=iIt6d5bJBWv/HXppUH7hgW+elfsL6jgbAZ6J2R5Bz/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBWvaUt06/hlzoIByzN2+uV1JU79An4CU0qmJ+A6gDLSjeW8Dk2fYN7e1DWAj/QwT
	 usZnge2I/xdfLA5VOPfDlvfbfSGJLwnk0ZBKS15l6TBJaeQyZ5jOIUB+31t8D94/s6
	 oHBTKnUfosdk3yudGzmDbd0oEi1iZHM9Rak6BKMFphDU8ttmxx0DT37DMLjA0oDrpN
	 Dw5oXEUlkPm/favWaOJYc/wbaHujOeHb6S0G6+J088r3Ga3I1sOzTC530pq4sr98Lu
	 6b4A2olSvbJDfbD0Ux8Fg8OnmOjcuRKw8g8O8hD1/CNLHOpT2ri27RN2f8DJ4D4OUG
	 zGSgGgpqTKdUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/752] ASoC: SOF: ipc4: Support for sending payload along with LARGE_CONFIG_GET
Date: Sat, 28 Feb 2026 12:37:16 -0500
Message-ID: <20260228174750.1542406-125-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit d96cb0b86d6e8bbbbfa425771606f6c1aebc318e ]

There are message types when we would need to send a payload along with
the LARGE_CONFIG_GET message to provide information to the firmware on
what data is requested.
Such cases are the ALSA Kcontrol related messages when the high level
param_id tells only the type of the control, but the ID/index of the exact
control is specified in the payload area.

The caller must place the payload for TX before calling the set_get_data()
and this payload will be sent alongside with the message to the firmware.

The data area will be overwritten by the received data from firmware.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20251217143945.2667-7-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4.c b/sound/soc/sof/ipc4.c
index a4a090e6724a6..20d723f48fff0 100644
--- a/sound/soc/sof/ipc4.c
+++ b/sound/soc/sof/ipc4.c
@@ -15,6 +15,7 @@
 #include "sof-audio.h"
 #include "ipc4-fw-reg.h"
 #include "ipc4-priv.h"
+#include "ipc4-topology.h"
 #include "ipc4-telemetry.h"
 #include "ops.h"
 
@@ -433,6 +434,23 @@ static int sof_ipc4_tx_msg(struct snd_sof_dev *sdev, void *msg_data, size_t msg_
 	return ret;
 }
 
+static bool sof_ipc4_tx_payload_for_get_data(struct sof_ipc4_msg *tx)
+{
+	/*
+	 * Messages that require TX payload with LARGE_CONFIG_GET.
+	 * The TX payload is placed into the IPC message data section by caller,
+	 * which needs to be copied to temporary buffer since the received data
+	 * will overwrite it.
+	 */
+	switch (tx->extension & SOF_IPC4_MOD_EXT_MSG_PARAM_ID_MASK) {
+	case SOF_IPC4_MOD_EXT_MSG_PARAM_ID(SOF_IPC4_SWITCH_CONTROL_PARAM_ID):
+	case SOF_IPC4_MOD_EXT_MSG_PARAM_ID(SOF_IPC4_ENUM_CONTROL_PARAM_ID):
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 				 size_t payload_bytes, bool set)
 {
@@ -444,6 +462,8 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 	struct sof_ipc4_msg tx = {{ 0 }};
 	struct sof_ipc4_msg rx = {{ 0 }};
 	size_t remaining = payload_bytes;
+	void *tx_payload_for_get = NULL;
+	size_t tx_data_size = 0;
 	size_t offset = 0;
 	size_t chunk_size;
 	int ret;
@@ -469,10 +489,20 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 
 	tx.extension |= SOF_IPC4_MOD_EXT_MSG_FIRST_BLOCK(1);
 
+	if (sof_ipc4_tx_payload_for_get_data(&tx)) {
+		tx_data_size = min(ipc4_msg->data_size, payload_limit);
+		tx_payload_for_get = kmemdup(ipc4_msg->data_ptr, tx_data_size,
+					     GFP_KERNEL);
+		if (!tx_payload_for_get)
+			return -ENOMEM;
+	}
+
 	/* ensure the DSP is in D0i0 before sending IPC */
 	ret = snd_sof_dsp_set_power_state(sdev, &target_state);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(tx_payload_for_get);
 		return ret;
+	}
 
 	/* Serialise IPC TX */
 	mutex_lock(&sdev->ipc->tx_mutex);
@@ -506,7 +536,15 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 			rx.data_size = chunk_size;
 			rx.data_ptr = ipc4_msg->data_ptr + offset;
 
-			tx_size = 0;
+			if (tx_payload_for_get) {
+				tx_size = tx_data_size;
+				tx.data_size = tx_size;
+				tx.data_ptr = tx_payload_for_get;
+			} else {
+				tx_size = 0;
+				tx.data_size = 0;
+				tx.data_ptr = NULL;
+			}
 			rx_size = chunk_size;
 		}
 
@@ -553,6 +591,8 @@ static int sof_ipc4_set_get_data(struct snd_sof_dev *sdev, void *data,
 
 	mutex_unlock(&sdev->ipc->tx_mutex);
 
+	kfree(tx_payload_for_get);
+
 	return ret;
 }
 
-- 
2.51.0

