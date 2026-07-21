Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954C747604A;
	Tue, 21 Jul 2026 19:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663518; cv=none; b=qZoghdUZYC9uaxUmD0QjPoOcIDkrFV6b2F5KkvO+EewvD88vPlkC7MF77lL5YWM/ui2FywtfkDMP1LBsncmrmB1oT9uBbP7STmuGrEBUMdgl+8Z6yK6fbBVrWIDuHRd0h2Hl6YevHwT9Lur6NTg7TjczyxJqLok4wr2SPUelv4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663518; c=relaxed/simple;
	bh=ycjUZeogYJhQHWLJsjtH5HhFOooTl1yQwVQWelalLf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnfVwfB1cCO+EBjdsEr1E69ymzKmJezFYkhJZ6NIzgmAc0GGWizP1ZevBQ00UrlC8NR6KUGkbdubmYp8AX8a9V0ecHWI4oooZVgGK2hhOVpyjQhOku3u78EBabYscWj+Kge4ziHE2E6xrdzOto7WqNxfPPIbY34qX1CcljuLi9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v8YgDvcR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v8YgDvcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FDC1F000E9;
	Tue, 21 Jul 2026 19:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663517;
	bh=bnt2XHuqZUKr9ZtsQMyn7QlsElW4Z59pqRsmdjastgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v8YgDvcRChcrZwpiPuEhiLSq6ZTg9OqUCZ4JSN7JDhmeYjAtPNR4uGZ0WL9/8hAmU
	 rVrdnm6ZBN5U/qOioMcTTrqGazxVk7kvqdqUaZO3KfflqUcHy0U/cSQYnJ+YQo4wB/
	 gcM5pfCYuGeVaohowTBHE9aFoNlTLrdq0nNE7nRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 0853/1276] ASoC: SOF: ipc3-control: Validate size in snd_sof_update_control
Date: Tue, 21 Jul 2026 17:21:36 +0200
Message-ID: <20260721152505.139626148@linuxfoundation.org>
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


