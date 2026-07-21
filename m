Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AEBF43CECB;
	Tue, 21 Jul 2026 21:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669866; cv=none; b=HeWoDCS1/Ti4JhlHP4Z5GtrWTpYYdtpZbdBpZ08k0AF6IXIvceQTV9KSBmJOp7MusiyiLc5MQJmeMiNEtvAwyFaIxUVawsBYMsqxArmXcQV6dcNWlV7FCj5xKUXVRP3U22F48kaP/u//0Dcc4JTROScyIRnSF7D/Tzh/LlzGjxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669866; c=relaxed/simple;
	bh=sJF3Z3SIgonNzhywSkZRnSvQnT5f1og/WaeWQLlGlqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=flhqsLlzbkUZIvqYHkQbkhBt1cmlKVHfG7LlXDxsftf84YsgHEUkh7lExO8SjuskoZ9fBqMH42rvVJGF6g0qQUbwFIPXqCinh9VDM9KRIV2eIdW11k6opNrYbrjNRVSVHhWr78zEli6lP/7tBDFSJr8EVvr8MwPNSGrTyQnGBFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cz5RwTZb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cz5RwTZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F18E1F000E9;
	Tue, 21 Jul 2026 21:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669865;
	bh=hDzRumgBsaY1SGrToSnHBDv8t5oeylolviVbDv2Ntuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cz5RwTZbuBu6KsABgoGKBdmDzkxuB1ExQDe5XU8SUmSFbBcCFFYGvYbdyV1wc5xAk
	 djih44hBewPbFC7TfvRhvh7S5A9eI1bgHWBEREI+yB15oUtrcLsvxZh/clysc+l0SD
	 eQZ7Jv3bFKkoo0/PjIaerO78e0u0vaopp3biycXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 0717/1067] ASoC: SOF: ipc3-control: Use overflow checks in control_update size calc
Date: Tue, 21 Jul 2026 17:21:58 +0200
Message-ID: <20260721152440.627200385@linuxfoundation.org>
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
@@ -604,16 +604,28 @@ static void sof_ipc3_control_update(stru
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


