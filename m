Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19F0415F04;
	Tue, 21 Jul 2026 18:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658324; cv=none; b=ai7kPUH55iyRV0AlbrgfcDF21YCgObcqJ29jPAvlke0L6HaLk7cRxcFBlGOZrX7ckvBmHjHyZcbRefXTeJZvQ2YN+bPKFh+q88lNQUm1uJEIgwksVTy1uHC7rDvHHtVZKjJtRiSuf0EaeuMBT0xFkYS091C+bBYEKy+t06NO+r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658324; c=relaxed/simple;
	bh=q8APo81/7joGffl4pb2opnYj1TQTjM5ZOVxrz5U8Abc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFW8gnIkIBca1fgu+oEKOmQjnOEnhuOKO3GJUXAgwpLG5lm6Bd2cJ6EP2oUSGW2KIQ20IlyUJpDho9qsE+yLNGxEaYFdeW+ONziylEiUMRWLjgIO7cE9u4hTrtFT/ljnXolSMdiHYN3NkqwRxVqavC46EcQ7xtBM1vKV7hQBZUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJO6FKVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJO6FKVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A481F000E9;
	Tue, 21 Jul 2026 18:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658322;
	bh=9MI7bym7w34H1C9Nuz+TvvfkJgEbZAMwacst0dBHMHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJO6FKVJeUYMkyYCrzu+FvjHlcSVVApbA99LUwkmYTnsre6PMi/A2EI3rQRUhyQPw
	 +0pbZbpahlQvF0mNlFrn3hUCSbzCK8n/VXpYlUjLMN0NWrroW3zMasm7uF4wrdbJ4p
	 fc9s1C0gMOI8asbUWBT0Ba5c3aVZzidgicePec+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 1099/1611] ASoC: SOF: ipc4-control: Fix TOCTOU in sof_ipc4_bytes_put
Date: Tue, 21 Jul 2026 17:20:15 +0200
Message-ID: <20260721152540.136178393@linuxfoundation.org>
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
@@ -455,6 +455,8 @@ static int sof_ipc4_bytes_put(struct snd
 	struct snd_soc_component *scomp = scontrol->scomp;
 	struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(scomp);
 	struct sof_abi_hdr *data = cdata->data;
+	const struct sof_abi_hdr *new_hdr =
+		(const struct sof_abi_hdr *)ucontrol->value.bytes.data;
 	size_t size;
 	int ret;
 
@@ -465,15 +467,16 @@ static int sof_ipc4_bytes_put(struct snd
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


