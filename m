Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FB943C06B;
	Tue, 21 Jul 2026 20:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666994; cv=none; b=PoLhdiB+UT0BPnFN87Ojj5gg6oZpxouYjXPrgK3/gAiOrMFwxFusLbBnNjk2JxQyuSLHs8T17E2OVDAt9i1NYd0syYcD1ku6aj5py0MGsh5TAK+HeYhYLiDLW7TaTiUVZMcYktXm0mQzOQ87BMT71FCWI4y7E3ojons/ccsFLas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666994; c=relaxed/simple;
	bh=QMqlDWFvKbFdAV+3n1gDIgx/ZayjKwHRWQ3cf0OFAN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHl7Pr4sjDL022LO0/hITq5S06HUPmSEqW6CSrZ09ZgeQDQta1R+uCeSF5sRa0j4h/n4e4jFglworS76GOgJBL909sz1i2/H9hkta6kcilJoyUZ1DIAO1J8HnwXYGnKpU93Dw7TbzDhGZn0kaontqeNMh7a68zwNCS+Fx5ks2h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jL4kKCms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jL4kKCms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BAB91F00A3E;
	Tue, 21 Jul 2026 20:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666990;
	bh=j0iAvm+6CLxujYKxZbsQQw5tUnE/nMKosuSuukJSTwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jL4kKCmsS4b7c8+ELl+LCx0RUAYnhweak90lruM7aTC39iHNhDeigeOoUCT/ItJyZ
	 4OnK6XG157bhSiOzZiORpT+3urpfENsoXel3HDVuCCIBSzCi7J4JGlSLIbWwEBWR7F
	 UJDvyNESLHmecB9g4Y2VfM/Tv0Tw0UDb4hVEfxXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0892/1266] ASoC: SOF: ipc4-control: Fix TOCTOU in sof_ipc4_bytes_put
Date: Tue, 21 Jul 2026 17:22:09 +0200
Message-ID: <20260721152501.807659382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -407,6 +407,8 @@ static int sof_ipc4_bytes_put(struct snd
 	struct snd_soc_component *scomp = scontrol->scomp;
 	struct snd_sof_dev *sdev = snd_soc_component_get_drvdata(scomp);
 	struct sof_abi_hdr *data = cdata->data;
+	const struct sof_abi_hdr *new_hdr =
+		(const struct sof_abi_hdr *)ucontrol->value.bytes.data;
 	size_t size;
 	int ret;
 
@@ -417,15 +419,16 @@ static int sof_ipc4_bytes_put(struct snd
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


