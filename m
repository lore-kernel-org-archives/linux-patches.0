Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A819144A730;
	Sat, 28 Feb 2026 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301280; cv=none; b=C178pXNK+KHHFjEoPdGeVymLSibGw9uEFqRcSiWYz35b4WkrbHvz294uVZYfzvOz6qtRmeGxxruV9glcCHBtBa+qtnGCnAE1kIgcqyWh2sB4dHfBYCyDKFabdBjW7iIAx7ZhW5UntgaAIrUWgWCpiDDphBBkt09Dt27bv4rHjCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301280; c=relaxed/simple;
	bh=auVoWXV1RNh0FwXOVbRVyFBpw7870SHSuTh2DfWtG9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o78+kmK7w+HOWs/HGd1+IStWbU8T4tGwFeeRYURKLB9CNrE1mmBotzrcGR1yp+XFWUflhRinqPW1+J25IoovIj8FHAlPX+vK7aGTOm+kihphQn8Ft13caT30moHTXH9LfTADdgSjLNNn3bDcmVRmHtrFTvyQNBO9zDcZ7Da00lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rc44y7o8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rc44y7o8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A82C116D0;
	Sat, 28 Feb 2026 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301280;
	bh=auVoWXV1RNh0FwXOVbRVyFBpw7870SHSuTh2DfWtG9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rc44y7o8kg2pojuA1oRfBzIAvuxx79Z6N7BSXlQR/9+uLKoIgsDqFCHHNzdS4oUW2
	 yWLNBtF61Lns+TZ08XBbn1qPiDZmWbXO5LIh+8VIo3tmEAqq5wnZ8uF19UKzRaptCQ
	 nDfLovY83+YW3lKKgdEoA5ZTKGc63LOfpxSJFOE7Po5LveEtfP3DHdWvSCF0whw/K3
	 6RZV2xoNIcswee9kpTUZOKXf9Ed3mj0Wf5/vRqH1vX4ZKdA0+aACbAQNoLdbFb/pJ5
	 jPsaUzzFWKRbqhvKSXvGUJD6n/z51dcPDWLdB/2JHnMqcj3ah+uVkOD3P7zsb1BbYS
	 BK6wdLTPZYjgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	stable@vger.kernel.org,
	Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 464/752] ASoC: SOF: ipc4-control: Keep the payload size up to date
Date: Sat, 28 Feb 2026 12:42:55 -0500
Message-ID: <20260228174750.1542406-464-sashal@kernel.org>
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

[ Upstream commit ebcfdbe4add923dfb690e6fb9d158da87ae0b6bf ]

When the bytes data is read from the firmware, the size of the payload
can be different than what it was previously.
For example when the topology did not contained payload data at all for the
control, the data size was 0.
For get operation allow maximum size of payload to be read and then update
the sizes according to the completed message.

Similarly, keep the size in sync when updating the data in firmware.

With the change we will be able to read data from firmware for bytes
controls which did not had initial payload defined in topology.

Fixes: a062c8899fed ("ASoC: SOF: ipc4-control: Add support for bytes control get and put")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Seppo Ingalsuo <seppo.ingalsuo@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20251217143945.2667-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-control.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sof/ipc4-control.c b/sound/soc/sof/ipc4-control.c
index 80111672c1796..453ed1643b89c 100644
--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -426,13 +426,21 @@ static int sof_ipc4_set_get_bytes_data(struct snd_sof_dev *sdev,
 	msg->extension = SOF_IPC4_MOD_EXT_MSG_PARAM_ID(data->type);
 
 	msg->data_ptr = data->data;
-	msg->data_size = data->size;
+	if (set)
+		msg->data_size = data->size;
+	else
+		msg->data_size = scontrol->max_size - sizeof(*data);
 
 	ret = sof_ipc4_set_get_kcontrol_data(scontrol, set, lock);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(sdev->dev, "Failed to %s for %s\n",
 			set ? "set bytes update" : "get bytes",
 			scontrol->name);
+	} else if (!set) {
+		/* Update the sizes according to the received payload data */
+		data->size = msg->data_size;
+		scontrol->size = sizeof(*cdata) + sizeof(*data) + data->size;
+	}
 
 	msg->data_ptr = NULL;
 	msg->data_size = 0;
@@ -448,6 +456,7 @@ static int sof_ipc4_bytes_put(struct snd_sof_control *scontrol,
 	struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(scomp);
 	struct sof_abi_hdr *data = cdata->data;
 	size_t size;
+	int ret;
 
 	if (scontrol->max_size > sizeof(ucontrol->value.bytes.data)) {
 		dev_err_ratelimited(scomp->dev,
@@ -469,9 +478,12 @@ static int sof_ipc4_bytes_put(struct snd_sof_control *scontrol,
 	/* copy from kcontrol */
 	memcpy(data, ucontrol->value.bytes.data, size);
 
-	sof_ipc4_set_get_bytes_data(sdev, scontrol, true, true);
+	ret = sof_ipc4_set_get_bytes_data(sdev, scontrol, true, true);
+	if (!ret)
+		/* Update the cdata size */
+		scontrol->size = sizeof(*cdata) + size;
 
-	return 0;
+	return ret;
 }
 
 static int sof_ipc4_bytes_get(struct snd_sof_control *scontrol,
@@ -581,6 +593,9 @@ static int sof_ipc4_bytes_ext_put(struct snd_sof_control *scontrol,
 		return -EFAULT;
 	}
 
+	/* Update the cdata size */
+	scontrol->size = sizeof(*cdata) + header.length;
+
 	return sof_ipc4_set_get_bytes_data(sdev, scontrol, true, true);
 }
 
-- 
2.51.0

