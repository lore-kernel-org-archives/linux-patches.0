Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12DC384CD6;
	Tue, 21 Jul 2026 17:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654027; cv=none; b=kEmDn0zHcpVIWITrecoHK0HC/pVmAJAOxs5roMVZdKQXp57W3EzG/OxNqm1xBuNq1c93d1lY+8hHJOe99wgpcZIlQ5BvyttjnYPndPGrC1Hl56LtIj0+6RQfk4Mr2iJ6iTpVZIe5hGUKp3S+ZmSNf2x0i/mgEb68IwaoBzyo3Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654027; c=relaxed/simple;
	bh=rBGghZuGjcHqC4hN9YnvUOmol891hvmxrlrITCMoptQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk8CBW3RlWkb2sZrQlyjVHaD9b+qO2TeTbeDpKJv9jeJAIf9Jp6bnmOES0wI0qWhG0KWL9TVMad35Ui33FzSb3BE1Y5woGk+bbhwD7/9oEpftU4Hu2gcYglsfwzunFPGWTne+Pd+4maAFGdgA9AcvMnduO5+FEnwpflVFUbHgdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO9rnGQ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO9rnGQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647011F000E9;
	Tue, 21 Jul 2026 17:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654025;
	bh=H/91L5dZgkIJlwMiPB88bWs0VDvpRpZ/mW+UKnI5Bz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YO9rnGQ+6I8pWv5QCXOZdJ0Nl8b0pCFGn/qOoO4iQkIqhjOpnpbf3lDQUM0ecB8DL
	 7qgEb0eofqEN8MPjQ1PH3nPejvdusKuu5Rjomv9WeqzRtrmdATGc/itZDZql2Eh6ov
	 KA4K9lfj3ElCCwoV9OQzLPkbvBrRddrkvZafh5+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.1 1522/2077] ASoC: SOF: ipc3-control: Use overflow checks in control_update size calc
Date: Tue, 21 Jul 2026 17:19:55 +0200
Message-ID: <20260721152628.683088910@linuxfoundation.org>
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

commit 8791977d7289f6e9d2b014f60a5455f053a7bc04 upstream.

In sof_ipc3_control_update(), the expected_size calculation uses
firmware-provided cdata->num_elems in arithmetic that could overflow
on 32-bit platforms, wrapping to a small value. This would allow the
cdata->rhdr.hdr.size comparison to pass with mismatched sizes,
potentially leading to out-of-bounds access in snd_sof_update_control.

Use check_mul_overflow() and check_add_overflow() to detect and reject
overflowed size calculations.

Fixes: 10f461d79c2d ("ASoC: SOF: Add IPC3 topology control ops")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260609083458.31193-4-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc3-control.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/sound/soc/sof/ipc3-control.c
+++ b/sound/soc/sof/ipc3-control.c
@@ -626,16 +626,28 @@ static void sof_ipc3_control_update(stru
 		return;
 	}
 
-	expected_size = sizeof(struct sof_ipc_ctrl_data);
 	switch (cdata->type) {
 	case SOF_CTRL_TYPE_VALUE_CHAN_GET:
 	case SOF_CTRL_TYPE_VALUE_CHAN_SET:
-		expected_size += cdata->num_elems *
-				 sizeof(struct sof_ipc_ctrl_value_chan);
+		if (check_mul_overflow((size_t)cdata->num_elems,
+				       sizeof(struct sof_ipc_ctrl_value_chan),
+				       &expected_size))
+			return;
+		if (check_add_overflow(expected_size,
+				       sizeof(struct sof_ipc_ctrl_data),
+				       &expected_size))
+			return;
 		break;
 	case SOF_CTRL_TYPE_DATA_GET:
 	case SOF_CTRL_TYPE_DATA_SET:
-		expected_size += cdata->num_elems + sizeof(struct sof_abi_hdr);
+		if (check_add_overflow((size_t)cdata->num_elems,
+				       sizeof(struct sof_abi_hdr),
+				       &expected_size))
+			return;
+		if (check_add_overflow(expected_size,
+				       sizeof(struct sof_ipc_ctrl_data),
+				       &expected_size))
+			return;
 		break;
 	default:
 		return;


