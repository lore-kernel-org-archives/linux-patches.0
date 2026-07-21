Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C3440803D;
	Tue, 21 Jul 2026 20:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667203; cv=none; b=nK+WJunL+5RIUQkEPP+DHvC/31j0kk/PvaVUWrKVwnmVmr54JU8pyqN+/KcWWWgto1ak8h5FqLvxOpSdR2hurBzjwuZsZczgG2ev6hw1dIYuq10gN9xxOu9xLE7ENuLjxNjyiZ3r/etlthWcYZbRdrG5axNqr80IZRyV2JlPgck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667203; c=relaxed/simple;
	bh=Ow8MTggoHTAWzeR/A0+Qigef+sVF940luKX4SoWNlOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKZ1Q+5WLFtrpTd1RCO0nBpSvCM/rDOyAcRqQ8NMB3PR0YfYFdrFTdyEvY6OFpyFyvbMOdBgFgjRjBjPJWktyKh1J1xROq/PlG/69ur0igmLBIegZvcxKLnngf/p5ClGACaJJo1R4wF3CpS3dQBvLPkc796kDtpaa7/pg/9t6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejunNxZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejunNxZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC541F000E9;
	Tue, 21 Jul 2026 20:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667202;
	bh=q8TSllB3TdY+KhBfJB4UOcPh34scDPDoKY+lSZ+HP74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejunNxZDDnyY5ubfiByWQn2enrLS4vh7IDTTlkjhazAxHmD82ee4+v6fRsOPBvHxC
	 XN/QlkMsAHXdKfMss0GdBAVYMlwZgQZ1rK6kB4HLqyrGSBPr7vmsXkUQoJkadVb3JX
	 mmcMOIu/NjyWYMxFx/XLCBaMtH/t/N17LD6lIwys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0919/1266] ASoC: SOF: ipc3-control: Validate size in snd_sof_update_control
Date: Tue, 21 Jul 2026 17:22:36 +0200
Message-ID: <20260721152502.405419317@linuxfoundation.org>
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


