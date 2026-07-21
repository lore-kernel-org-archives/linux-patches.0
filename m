Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C8E2E736D;
	Tue, 21 Jul 2026 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653968; cv=none; b=r8J4N/ht5Sgc7lDnUkg1vO8nmBXXgw0JQad8W/ejAylOF/7k9eicGg7UcNYKNiAnl1RTIkMxnd7LhZpVWgo/iMUzUBI+MfWwALMHr6Z8qWB9cndw+oBrkPUTqMRbnRbQrqRE/mlvsM4qdNHB2r5tH8wSRus4uiQBSI1/yDDktaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653968; c=relaxed/simple;
	bh=5kTl5Qc8zg5AOL0z7x+2XfBGuPsUFk4z8ZXD3SpeZSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvv6CQIDv5xkKKDU/DIA817U2zxspNTFWbzypbqedf+f4u9NwfbjcyasUZGrBqnpB4pZ+mkBIu+nqLP6uWU0+twHU7aPkzVGrqFuBoOJPymTFg5zJCob3zwrgwQuqkNef6vdRo7UOm6ewGyjTUkrhcyZdcv2nyyfC+YbmaCkwnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJHhHmgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJHhHmgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478B81F000E9;
	Tue, 21 Jul 2026 17:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653967;
	bh=yoQEOu+qF+IM5a3m63L1HDkmjGUogFj9fmK2hVS1a0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJHhHmgnTvGBJJpqCpe8eOvUxYwxo7chOYIWvB5Qv8at43qk1aueXyEZSAAXgl9ab
	 B5RTG4mWGGiEbfJYVT9uMtfaQrvkTBLvEOjaOkSyD8j7DZ7mj2Qov4wH7kaWX4ehrU
	 apMmmM+A0dX//YrIadxAFHLSPYAT16ZHXK7OXvao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 1520/2077] ASoC: SOF: ipc4-control: Fix TOCTOU in sof_ipc4_bytes_put
Date: Tue, 21 Jul 2026 17:19:53 +0200
Message-ID: <20260721152628.634167068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 3ad673e7139cf214afd24321a829aad6575f4163 upstream.

In sof_ipc4_bytes_put(), the copy size is derived from the old
data->size in the buffer rather than the incoming new data's size
field from ucontrol. If the new data has a different size, the copy
uses the wrong length: it may truncate valid data or copy stale bytes.

Fix by validating and using the incoming data's sof_abi_hdr.size from
ucontrol before copying.

Fixes: a062c8899fed ("ASoC: SOF: ipc4-control: Add support for bytes control get and put")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260609083458.31193-2-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-control.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -562,6 +562,8 @@ static int sof_ipc4_bytes_put(struct snd
 	struct snd_soc_component *scomp = scontrol->scomp;
 	struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(scomp);
 	struct sof_abi_hdr *data = cdata->data;
+	const struct sof_abi_hdr *new_hdr =
+		(const struct sof_abi_hdr *)ucontrol->value.bytes.data;
 	size_t size;
 	int ret;
 
@@ -572,15 +574,16 @@ static int sof_ipc4_bytes_put(struct snd
 		return -EINVAL;
 	}
 
-	/* scontrol->max_size has been verified to be >= sizeof(struct sof_abi_hdr) */
-	if (data->size > scontrol->max_size - sizeof(*data)) {
+	/* Validate the new data's size, not the old one */
+	if (new_hdr->size > scontrol->max_size - sizeof(*new_hdr)) {
 		dev_err_ratelimited(scomp->dev,
 				    "data size too big %u bytes max is %zu\n",
-				    data->size, scontrol->max_size - sizeof(*data));
+				    new_hdr->size,
+				    scontrol->max_size - sizeof(*new_hdr));
 		return -EINVAL;
 	}
 
-	size = data->size + sizeof(*data);
+	size = new_hdr->size + sizeof(*new_hdr);
 
 	/* copy from kcontrol */
 	memcpy(data, ucontrol->value.bytes.data, size);


