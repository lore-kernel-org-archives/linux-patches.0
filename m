Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8915C35C1AE;
	Tue, 21 Jul 2026 18:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658618; cv=none; b=LhowUesFb/PZ1LKsJ7RTFX8XBYb2WzUJD2XpGnwIEzGYd3nQnAldcG+AVJATVqVCp/Pw7A8c/cTjplvyt+8xjI4yrdHhHp6cni6uJh6P0nSWLPXk2eMG/CF22PakGg9oFKHGIyOhsCj0l5xPmPwXBurfwlOCeD7BwHPLNVIbnnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658618; c=relaxed/simple;
	bh=7TusS/1Th+q4jO223ta/lhS4xjz0efoVxWqa3bjZyFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRDEiVjguG+w9dEvYJXApJcr+m33dT6LJ+nXRVSDUnihQQFKDJkCVg831StsJ723KWauEHVjoRmbJdL/ak3Ox4W6qP2H1QqfgqumgxKlyu5KlHNjIeWxjVjHRFv7mBPfQSLP2qJ/9j9VVJ1annRu88SjojGBYtnK5kzxG0JhlU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8yX5URq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8yX5URq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA1D81F00A3A;
	Tue, 21 Jul 2026 18:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658617;
	bh=TnGLcMWolFcDha+uuyMKU3IyT8fOjgS84HKuFcQwrP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z8yX5URqlFCKADZDnP3y/UX/v6yGvyehjMRNNpt2pXCEGx66db6jeW+WEpm9fpeBZ
	 eVxvUYjfbbcpP3aekzExn2+grSq5y+lyMtIs+jCtaApRMvV54MZsc5kUgIezalTKCL
	 uwBXTjRG2W2mqGY3Yb4VqSb2loyqq5GlDSqKElXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 1158/1611] ASoC: SOF: ipc3-control: Fix heap overflow in bytes_ext put/get
Date: Tue, 21 Jul 2026 17:21:14 +0200
Message-ID: <20260721152541.470106821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
 


