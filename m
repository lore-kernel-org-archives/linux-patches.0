Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C975E418A48;
	Tue, 21 Jul 2026 21:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669934; cv=none; b=CknrPRX89UrBViTELHviDQDMH2910pe30kJxu/r0TzIVnBrKfcPxaDeyYsoL63btZc6cGfQKgl7BDoXwBPXm7WhvQHLNOEAkpSkKKITEGDcxnrsXpHb3+YlvpP1xlI0KTSzXzCWhIqbuOl41SRlZOGITxvqTbYfdTxcym9vVArU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669934; c=relaxed/simple;
	bh=lkjwj0xuZLFoI6jvGAE6RXR49etTPc2aEmC0K2wbWD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuz/vw9ehV0+F/cQ6USNgMO6/ysi06JU8XoLzMG9BzyS/Ldy29FDeBBx9m6HDD0xUovDQIbsxjhRbEEbIEQLCpe0Ob7e/FoYnqTRLPHeOpLBCM0iqhEc9K+7tXXt2QL+FiA5rTOn6GZk4ceQL4TmjMYu8psEQ2ajLlW8jq+9BoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4B6nM1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4B6nM1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE661F000E9;
	Tue, 21 Jul 2026 21:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669933;
	bh=ICgz6nxw1gChxZDXfI9KtYX38RodfjUyz6KhEFh38TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4B6nM1wfa2QOWceNNqDt18xj02jX0D5KmUweJkduECGdbFfPOsvYLjtO/kxrI2M3
	 FVRUARMIuSEyop0Bd9gfzCvY9mOjZ3oL10mbzxAurLz6C0IKD8zi6CmhjjwrsF1B5O
	 OOIa8eYQTEcC9q47OZCDi9nRKdHeyjW6dLML8ALE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0740/1067] ASoC: SOF: ipc3-control: Validate size in snd_sof_update_control
Date: Tue, 21 Jul 2026 17:22:21 +0200
Message-ID: <20260721152441.134269796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 390aa4c9339bb0ec0bc8d554e830faf93ca9d49e upstream.

In snd_sof_update_control(), firmware-provided cdata->num_elems is
checked against local_cdata->data->size but never against the actual
allocation size. If local_cdata->data->size was previously set to an
inconsistent value, the memcpy could write past the allocated buffer.

Add a bounds check to ensure num_elems fits within the available space
in the ipc_control_data allocation before copying.

Fixes: 10f461d79c2d ("ASoC: SOF: Add IPC3 topology control ops")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260609083458.31193-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3-control.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/soc/sof/ipc3-control.c
+++ b/sound/soc/sof/ipc3-control.c
@@ -522,6 +522,15 @@ static void snd_sof_update_control(struc
 			return;
 		}
 
+		/* Verify the size fits within the allocation */
+		if (cdata->num_elems > scontrol->max_size - sizeof(*local_cdata) -
+					sizeof(*local_cdata->data)) {
+			dev_err(scomp->dev,
+				"cdata binary size %u exceeds buffer\n",
+				cdata->num_elems);
+			return;
+		}
+
 		/* copy the new binary data */
 		memcpy(local_cdata->data, cdata->data, cdata->num_elems);
 	} else if (cdata->num_elems != scontrol->num_channels) {


