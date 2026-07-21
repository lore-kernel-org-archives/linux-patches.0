Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2254F471433;
	Tue, 21 Jul 2026 19:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663516; cv=none; b=Tcb2/BYoPNHs/N0UZp7hjhrHsv4EXgmk5uJ2czUa4aUb5gLjysMArf4CRtKlvey4Eui3TKDFba4P4jJXOLWnISZzYkMpDlzwsP46rfCRCLC5hRAyvvfIfsl9wut3KcYZjEFtV0lEWyhg4xs1i0uKXHIvgq0y2TKrTypAJUDSmmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663516; c=relaxed/simple;
	bh=8NeTUQdGWhUL97ZbtE9oqwmSo/1cH8BPxJlwylWqqoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCfKTiPFDhqkb4maLpF99y4oUkhgIk0XWLfjJeQu/a56slyJL1UUrCAtnxdq5NgLvhk8+2jeqACygOyk6iIeRug/Jgb2r3+wJDVWrr3hfX6+kys+mnf9eaBgcZGjBTW181bWiePJJfCBKbsruBqjGPW4WGnYmamlrVmErTHpGPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upGM1BFR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upGM1BFR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456CC1F000E9;
	Tue, 21 Jul 2026 19:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663514;
	bh=PUModjgQAcc0u+q3a7EK3FtjAv6RtdOmf4x8i+ybf4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upGM1BFRh1yks3vbobm7s+G8Ayb6k3Yo6LZI7a81EoEy8/naYRH6yLTykibNa6U9g
	 Q7vrxUWEF13BBRbPWemVh56wsBbjWQPAWv/kUZ8iZSbHNOh/ImgRkVmZuDUjy8ggWv
	 gnm7Rc3plfQykxvY4iWUOOHuLn1S/U40Z0R2sdOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0852/1276] ASoC: SOF: ipc3-control: Fix heap overflow in bytes_ext put/get
Date: Tue, 21 Jul 2026 17:21:35 +0200
Message-ID: <20260721152505.117920400@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit fd46668d538993218eea19c6925c868ac0f2630c upstream.

The ipc_control_data buffer is allocated as kzalloc(max_size), where
max_size covers the entire struct sof_ipc_ctrl_data including its
flexible array payload. However, the bounds checks in bytes_ext_put
and _bytes_ext_get compared user data lengths against max_size
directly, ignoring that cdata->data sits at an offset of
sizeof(struct sof_ipc_ctrl_data) bytes into the allocation.

This allowed writing up to sizeof(struct sof_ipc_ctrl_data) bytes past
the end of the heap buffer from unprivileged userspace via the ALSA TLV
kcontrol interface, and similarly allowed over-reading adjacent heap
data on the get path.

Fix all bounds checks to subtract sizeof(*cdata) from max_size so they
reflect the actual space available at the cdata->data offset. Also fix
the error-path restore in bytes_ext_put which wrote to cdata->data
instead of cdata, causing the same overflow.

Fixes: 67ec2a091630 ("ASoC: SOF: Add bytes_ext control IPC ops for IPC3")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260609083458.31193-7-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3-control.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/sound/soc/sof/ipc3-control.c
+++ b/sound/soc/sof/ipc3-control.c
@@ -398,9 +398,17 @@ static int sof_ipc3_bytes_ext_put(struct
 	}
 
 	/* be->max is coming from topology */
-	if (header.length > scontrol->max_size) {
-		dev_err_ratelimited(scomp->dev, "Bytes data size %d exceeds max %zu\n",
-				    header.length, scontrol->max_size);
+	if (header.length > scontrol->max_size - sizeof(*cdata)) {
+		dev_err_ratelimited(scomp->dev, "Bytes data size %u exceeds max %zu\n",
+				    header.length, scontrol->max_size - sizeof(*cdata));
+		return -EINVAL;
+	}
+
+	/* Ensure the data is large enough to contain the ABI header */
+	if (header.length < sizeof(struct sof_abi_hdr)) {
+		dev_err_ratelimited(scomp->dev,
+				    "Bytes data size %u less than ABI header %zu\n",
+				    header.length, sizeof(struct sof_abi_hdr));
 		return -EINVAL;
 	}
 
@@ -436,7 +444,7 @@ static int sof_ipc3_bytes_ext_put(struct
 	}
 
 	/* be->max has been verified to be >= sizeof(struct sof_abi_hdr) */
-	if (cdata->data->size > scontrol->max_size - sizeof(struct sof_abi_hdr)) {
+	if (cdata->data->size > scontrol->max_size - sizeof(*cdata) - sizeof(struct sof_abi_hdr)) {
 		dev_err_ratelimited(scomp->dev, "Mismatch in ABI data size (truncated?)\n");
 		goto err_restore;
 	}
@@ -452,7 +460,7 @@ static int sof_ipc3_bytes_ext_put(struct
 err_restore:
 	/* If we have an issue, we restore the old, valid bytes control data */
 	if (scontrol->old_ipc_control_data) {
-		memcpy(cdata->data, scontrol->old_ipc_control_data, scontrol->max_size);
+		memcpy(cdata, scontrol->old_ipc_control_data, scontrol->max_size);
 		kfree(scontrol->old_ipc_control_data);
 		scontrol->old_ipc_control_data = NULL;
 	}
@@ -491,10 +499,13 @@ static int _sof_ipc3_bytes_ext_get(struc
 	}
 
 	/* check data size doesn't exceed max coming from topology */
-	if (cdata->data->size > scontrol->max_size - sizeof(struct sof_abi_hdr)) {
-		dev_err_ratelimited(scomp->dev, "User data size %d exceeds max size %zu\n",
+	if (cdata->data->size > scontrol->max_size - sizeof(*cdata) -
+				sizeof(struct sof_abi_hdr)) {
+		dev_err_ratelimited(scomp->dev,
+				    "User data size %u exceeds max size %zu\n",
 				    cdata->data->size,
-				    scontrol->max_size - sizeof(struct sof_abi_hdr));
+				    scontrol->max_size - sizeof(*cdata) -
+				    sizeof(struct sof_abi_hdr));
 		return -EINVAL;
 	}
 


