Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE3143E073;
	Tue, 21 Jul 2026 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669869; cv=none; b=ojw1Z1C8HOnbTHSsNFnF+WLrCy/Wf/0bT4SFbg+aY1iKGrppPHLTMXXONb9Dvj5WX9wDbPP8P2k+IGFeEPUZCxAZoJZKhEyq8Fy33Afm62ivS35iCEBkBT/DH+VaD1qquFxbcy7JsTjcq02m4FPtKVU4pw7GfJnSyUioDJUzUj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669869; c=relaxed/simple;
	bh=bFmkZUSxJHajKZY+VkoF3/Sotl/GZ6VxDu5HYGcbx8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=njVe4eePhZr0ACfYqdwtL3t7GHsW4Dvg0dxMg6kuNiafCRT9c2xRgCEF4JGmg613ITFt0rL6rDeus0WJcAYXgpnH40QZ2RlzIcu5EdOkiohkhnfipijJDcf3vZGGTf0sjMmxjfy8mNA8+QCQ9PfV15Ftg+i3rLF6/wXDc1Bn/s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0Ebryjp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0Ebryjp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD4C1F000E9;
	Tue, 21 Jul 2026 21:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669867;
	bh=/rYpH8aJX/jBokNK/ZDoTKVE2p2SHtmSVkySukYlLyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0EbryjplYcBfqVGVOp4BSTvSfMrNTfS0F/yL+U4gcMI/qQiu0pv98rY5DkPsNOhE
	 Pk2X6KfBN3+qYv0y9QIOKahOBO8ILAPlA+ZX26LO+Lfcu3xM0fUjgL/MR33kilJcyv
	 ai3BssgqoEcUQND+0QLowwtFGacMmhm4saJXAGlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0718/1067] ASoC: SOF: ipc3-control: Fix TOCTOU in bytes_put and bytes_get
Date: Tue, 21 Jul 2026 17:21:59 +0200
Message-ID: <20260721152440.650073053@linuxfoundation.org>
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

commit 1f97760417b5faa60e9642fd0ed61eb17d0b1b39 upstream.

In sof_ipc3_bytes_put(), the size used for the memcpy is derived from
the old data->size already in the buffer, not the incoming new data's
size field. If the new data has a different size, the copy length is
wrong: it may truncate valid data or copy stale bytes.

Similarly, sof_ipc3_bytes_get() checks data->size against max_size
without accounting for the sizeof(struct sof_ipc_ctrl_data) offset
of the flex array within the allocation.

Fix bytes_put to validate and use the incoming data's sof_abi_hdr.size
from ucontrol before copying. Fix bytes_get to subtract sizeof(*cdata)
from the bounds check to match the actual available space.

Fixes: 544ac8858f24 ("ASoC: SOF: Add bytes_get/put control IPC ops for IPC3")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260609083458.31193-6-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3-control.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/sound/soc/sof/ipc3-control.c
+++ b/sound/soc/sof/ipc3-control.c
@@ -281,10 +281,13 @@ static int sof_ipc3_bytes_get(struct snd
 	}
 
 	/* be->max has been verified to be >= sizeof(struct sof_abi_hdr) */
-	if (data->size > scontrol->max_size - sizeof(*data)) {
+	if (data->size > scontrol->max_size - sizeof(*cdata) -
+				    sizeof(*data)) {
 		dev_err_ratelimited(scomp->dev,
 				    "%u bytes of control data is invalid, max is %zu\n",
-				    data->size, scontrol->max_size - sizeof(*data));
+				    data->size,
+				    scontrol->max_size - sizeof(*cdata) -
+				    sizeof(*data));
 		return -EINVAL;
 	}
 
@@ -302,6 +305,8 @@ static int sof_ipc3_bytes_put(struct snd
 	struct sof_ipc_ctrl_data *cdata = scontrol->ipc_control_data;
 	struct snd_soc_component *scomp = scontrol->scomp;
 	struct sof_abi_hdr *data = cdata->data;
+	const struct sof_abi_hdr *new_hdr =
+		(const struct sof_abi_hdr *)ucontrol->value.bytes.data;
 	size_t size;
 
 	if (scontrol->max_size > sizeof(ucontrol->value.bytes.data)) {
@@ -310,14 +315,18 @@ static int sof_ipc3_bytes_put(struct snd
 		return -EINVAL;
 	}
 
-	/* scontrol->max_size has been verified to be >= sizeof(struct sof_abi_hdr) */
-	if (data->size > scontrol->max_size - sizeof(*data)) {
-		dev_err_ratelimited(scomp->dev, "data size too big %u bytes max is %zu\n",
-				    data->size, scontrol->max_size - sizeof(*data));
+	/* Validate the new data's size, not the old one */
+	if (new_hdr->size > scontrol->max_size - sizeof(*cdata) -
+				    sizeof(*new_hdr)) {
+		dev_err_ratelimited(scomp->dev,
+				    "data size too big %u bytes max is %zu\n",
+				    new_hdr->size,
+				    scontrol->max_size - sizeof(*cdata) -
+				    sizeof(*new_hdr));
 		return -EINVAL;
 	}
 
-	size = data->size + sizeof(*data);
+	size = new_hdr->size + sizeof(*new_hdr);
 
 	/* copy from kcontrol */
 	memcpy(data, ucontrol->value.bytes.data, size);


