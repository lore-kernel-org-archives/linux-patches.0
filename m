Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B0047F2CE;
	Thu, 20 Aug 2026 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248038; cv=none; b=gw9doAyp2V99vfZQLpqzXqzuYnEWpRE599Dho1qUd1Nxhn7wMDSacrOwPwiutcD0LwqJbY+f3hUycjWdZK2UL9AV97wKPcygdA3E6+0tpGS63X93zwH8B2J2YfDvf5+sSM5Vf9/dJZbREvmhGzm9V3avB8YyOF6xt/rDGXjpZfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248038; c=relaxed/simple;
	bh=LTSBTFgoMUMqeeDgoYMaKNMrPOq+0dPsxm/RGR5FqqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgaoJSC3sw4wbsnX0yVpnEbdGY8yuWLlPiRQkg03gTr0aOy/UCuiAzM52dbaBtKGu7C7YAWK6jF7BcCGi3MFPRj64tyygugLZXA1hCvl4HkdorR/G6fsAJaiMtitH2JCGAvK99bGh+ZxBscag5QvwY5bxQiuuDjuMFSy40Cc+PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKaI+N5t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKaI+N5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAA01F000E9;
	Thu, 20 Aug 2026 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248035;
	bh=kiFDKfm48ZjHFxqNvfS+f+DQnCaQs1I750nnwh6Qbr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKaI+N5tMccocGPvcU2VCDv/1HnvFiqUaowcor7h3d21ZSrCpKm9gTZOzJ7RQfu++
	 HS9yG+vQVHCxNWhA4+q/z+1Ljr8GJ3S+UaKX9th1JdfmQ5UCduS58ZE4XgDylqSyHP
	 NxEwMBn+o0gTEKHRyk1SvvxUJEplxXZVtj4N52g0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/303] ASoC: SOF: ipc3-control: Fix heap overflow in bytes_ext put/get
Date: Thu, 20 Aug 2026 16:53:44 +0200
Message-ID: <20260820145255.947247621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

[ Upstream commit fd46668d538993218eea19c6925c868ac0f2630c ]

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
[ replicated the single shared-helper bounds-check fix into the two standalone get functions and dropped the err_restore memcpy hunk absent in 6.1 ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3-control.c |   34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

--- a/sound/soc/sof/ipc3-control.c
+++ b/sound/soc/sof/ipc3-control.c
@@ -363,10 +363,13 @@ static int sof_ipc3_bytes_ext_get(struct
 	cdata->data->abi = SOF_ABI_VERSION;
 
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
 
@@ -412,9 +415,17 @@ static int sof_ipc3_bytes_ext_put(struct
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
 
@@ -440,7 +451,7 @@ static int sof_ipc3_bytes_ext_put(struct
 	}
 
 	/* be->max has been verified to be >= sizeof(struct sof_abi_hdr) */
-	if (cdata->data->size > scontrol->max_size - sizeof(struct sof_abi_hdr)) {
+	if (cdata->data->size > scontrol->max_size - sizeof(*cdata) - sizeof(struct sof_abi_hdr)) {
 		dev_err_ratelimited(scomp->dev, "Mismatch in ABI data size (truncated?)\n");
 		return -EINVAL;
 	}
@@ -482,10 +493,13 @@ static int sof_ipc3_bytes_ext_volatile_g
 		return ret;
 
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
 


