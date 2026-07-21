Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38B133689F;
	Tue, 21 Jul 2026 17:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653998; cv=none; b=TvX8L7jXzD8TBIUfxfnRudyf1lMa0o4XFnKyZaTJ0jkn3W2uTFGj/GhCkrOYlmxXGyd/dkHi2aXq46ytqzZXU7RpIp4DahbUK9XFf1+YkySH/HW8EO6ljc3j0Mi/ObSReQrLViiOK5DFtotvXFzzzUG9ngVylySZDEeA5myjL8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653998; c=relaxed/simple;
	bh=qmlpsa3eCHXtNU5zhehSS+Odw1A5CvDcRgf5+LF5E3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCcmNfpHQeb0IrCHNIQ+4Beh8Y+XAFDAjYAlgtliUCuzgYQMjjvWDXqqmXAj6zLHqHkny6JY+Hvw/M5C1jBouSlAndDNrfJxq54qivg3fSFIYogPSxx5C7fpGDJkoQhgx9ElAuu28xP6Qam8OOWut2VM3QTJMmYOC2QjOKCCals=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYskqaL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYskqaL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560CA1F000E9;
	Tue, 21 Jul 2026 17:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653996;
	bh=FRrQ9jhUpOJd2xFdoXe4s5gA0z15Tx2WshoJbimKVUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cYskqaL8lB+/zSqFhcXg29wVeI8pnDNHBBzYz2VxJ7kXJQLteQTrhqnIT4ktV8Jcu
	 NCOIf57m/hv/jDkfBI1oJYMo3S9D9eb1lTd8Ev3g9opNYKniqjk5h+ARGQ5m+5GcYa
	 XRUwEWsdcdEsY5Cn6SbdowuH2IwrQspOicOT27Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 1521/2077] ASoC: SOF: ipc4-control: Validate notification payload size
Date: Tue, 21 Jul 2026 17:19:54 +0200
Message-ID: <20260721152628.656898785@linuxfoundation.org>
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

commit 5bdfeccb7fbf6e000fc783cd8412732e67c1ad0c upstream.

Validate MODULE_NOTIFICATION payload length before reading
bytes/channel data in control update handling.

Fixes: 2a28b5240f2b ("ASoC: SOF: ipc4-control: Add support for generic bytes control")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260609083458.31193-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-control.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/sound/soc/sof/ipc4-control.c
+++ b/sound/soc/sof/ipc4-control.c
@@ -883,6 +883,16 @@ static void sof_ipc4_control_update(stru
 		 */
 		if (type == SND_SOC_TPLG_TYPE_BYTES) {
 			struct sof_abi_hdr *data = cdata->data;
+			size_t source_size = struct_size(msg_data, data, msg_data->num_elems);
+
+			if (source_size > ndata->event_data_size) {
+				dev_warn(sdev->dev,
+					 "%s: invalid bytes notification size for %s (%zu, %u)\n",
+					 __func__, scontrol->name, source_size,
+					 ndata->event_data_size);
+				scontrol->comp_data_dirty = true;
+				goto notify;
+			}
 
 			if (msg_data->num_elems > scontrol->max_size - sizeof(*data)) {
 				dev_warn(sdev->dev,
@@ -895,6 +905,17 @@ static void sof_ipc4_control_update(stru
 				scontrol->size = sizeof(*cdata) + sizeof(*data) + data->size;
 			}
 		} else {
+			size_t source_size = struct_size(msg_data, chanv, msg_data->num_elems);
+
+			if (source_size > ndata->event_data_size) {
+				dev_warn(sdev->dev,
+					 "%s: invalid channel notification size for %s (%zu, %u)\n",
+					 __func__, scontrol->name, source_size,
+					 ndata->event_data_size);
+				scontrol->comp_data_dirty = true;
+				goto notify;
+			}
+
 			for (i = 0; i < msg_data->num_elems; i++) {
 				u32 channel = msg_data->chanv[i].channel;
 
@@ -922,6 +943,8 @@ static void sof_ipc4_control_update(stru
 		scontrol->comp_data_dirty = true;
 	}
 
+notify:
+
 	/*
 	 * Look up the ALSA kcontrol of the scontrol to be able to send a
 	 * notification to user space


