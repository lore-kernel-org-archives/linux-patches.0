Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91C819049B;
	Tue, 21 Jul 2026 17:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654149; cv=none; b=YO+RA860ug2rsNbYV3pngVcD5g8NGU9PydjY5CNqz9MreABoUkwO8aHYrPx30Vr9SvZkyPE4tqtwEbO+NFELgyWGhQfI/wjFbsQ14PXR0wJseXkpEPs0yaxQOOCJF8icMwQKY/pf4dkgx4T2lRkY+8TTIFQ1dXa/oKyon0hsmTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654149; c=relaxed/simple;
	bh=8CDnuxLWQeXfPHcUeb7wtGFWJ5pr0lWNWADAdHXlciU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PGR6rewreAjrW+BU8GwnHumW2/6Xjo8B+r5uPXe8Cz0za2OW/6yxo4mwIRbUcnEjnNuWEU53s/XZ+Fi3/vp2X/rStet63BhPEDght3ici7PnJmNFef8OGOtB7seXgbsmMXHfmWb3Z2Ry947GGuQOzV+BCCgdna+88WxX9muOa0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRBFSVj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRBFSVj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50ECA1F000E9;
	Tue, 21 Jul 2026 17:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654147;
	bh=vq3WtoOvsgwvNm3WuZE6Jbgkl7MQIax1ZG8ahupyKaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRBFSVj+U+anpS3NQ1xGKucoq64pVbZ5i6NEiX72l/aCALrWxLT17ucOcgR458avb
	 cob5Zq/oA2XFtA1Y8ep4tnH6uUs+qPjBmmhCGiYf8PSyhyrccWFY5gG+Zgw9FQn/FN
	 3AC3Aj1/UPUchTvN0tPou5q1vkXc9bnwgGPyV5C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 1595/2077] ASoC: SOF: ipc3-control: Validate size in snd_sof_update_control
Date: Tue, 21 Jul 2026 17:21:08 +0200
Message-ID: <20260721152630.393467394@linuxfoundation.org>
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
@@ -555,6 +555,15 @@ static void snd_sof_update_control(struc
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


