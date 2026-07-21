Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7479415F3C;
	Tue, 21 Jul 2026 18:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658498; cv=none; b=SjPGDsf2o/uapxmrQYKz8n16al6lMOmg6c3G4yGG/L3rBGH7eRhGefy+lfHLzjbFSZgnrp/8c6AfJBIYCcjYd2vJrqQGcAWPmb724Umr9ZwHt7ttvTjCQ4/wrR8eb50PnBpnrIx1R7dblYpW0z7kG8aFUfss4RQc9xBxtEVRgMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658498; c=relaxed/simple;
	bh=x8WZWmRVS6LlPbSGRmY5KwN2CUyIjEpKdYxFrzBoGMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nS2Q6Z/8GopJZIBv5KlG7QkRKRw4+BlqAtcKjQps7+dGMD21Abe9vCuCXxQ6QKW/E4Dxr8CWy2KbF+lxnjgqk5HAiwxnn9+u/DWUgIg2QFJC7xhK43ESwNXA7+3eThcU8N2QUuW2S/1tYVmdL5csELvupz1qfjPFt9Bdbi8Ei6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfNk6O6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfNk6O6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0221F000E9;
	Tue, 21 Jul 2026 18:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658497;
	bh=bJOYDefgyb8uoYa+DVZQPOD4NiefPRP57sZJZ4USn3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BfNk6O6s/ukQSocWXayfIbquWgKnIG5rH628D9mMsDhfrmZJfSDJBxnQBJKRHNrua
	 4jbanTPUNffTb81x9dvJSiP2CeBP2N5GnD6LdxGutAHnGB1nxqXozsSTpJD3ArkXtr
	 5VeKTZd/lYYcV9J2FiOs7uGwYEbHgKR2hYdoL9D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 1159/1611] ASoC: SOF: ipc3-control: Validate size in snd_sof_update_control
Date: Tue, 21 Jul 2026 17:21:15 +0200
Message-ID: <20260721152541.492842384@linuxfoundation.org>
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


