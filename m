Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB523B05A2;
	Thu, 30 Jul 2026 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425784; cv=none; b=fyx8pujM8AhhVXm3ogvqA9E6/d00XmAEqyOfoFg6KxsykIWquipDO7KfJRcAkKUZldhxiqht606NkFgz1ylNDkP+SqCEXIc+bNHgXZ+YE4MRY8A+KSQaZAac/+3Z3M0Dr34P5g1TRTlIUxMf29usXNZ82+KntchvXZjW9seVcFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425784; c=relaxed/simple;
	bh=z91vHCxGeuGAFc98Q3taT8bVbwkhl3nKOSvLFrSg6pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4cw6J3ae3PFDQftKp1UVH3YjgpKTwwvM0JAwGJOALE05n5vQKAU5AekiBkszZnM/E8mwBWD7PbwerM2E8ozZiis2oUyFNkzparQF37tdrM1hNsF+4z8DEm2V95rO+cdiiuH9K5y5LgqNRW4e8h1+JrgQoCPy8UDQsPDFnwNaCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R9zGGmDr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R9zGGmDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A881F00A3E;
	Thu, 30 Jul 2026 15:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425783;
	bh=s3Trt21PZsCms6/+IyGMOK9XjHLEb1fTlS6DoFcmP68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R9zGGmDr6VIGg9qitPjMDfb+Qtfzo9TL/tm0eu87KK1LCFUrfl/JJu1XpOa3FTHDR
	 N9rHHPdAyyYrlUN0Bne9tLFeSnmaBP8Ukpo+zeSZQimyvxk1rjiB4aHum3jMgrtC/+
	 AEqzxOg6ZVdQw6P5xz60xBDJc0yOn5OAjJhe4ta4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/602] wifi: ath6kl: fix OOB read from firmware num_msg in TX complete handler
Date: Thu, 30 Jul 2026 16:08:58 +0200
Message-ID: <20260730141439.048491389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 3a21c89215cc18f1a97c5e5bfd1da6d4f3d44495 ]

The firmware-controlled num_msg field (u8, 0-255) drives the loop in
ath6kl_wmi_tx_complete_event_rx() without validation against the buffer
length. This allows out-of-bounds reads of up to 1020 bytes past the
WMI event buffer when the firmware sends an inflated num_msg.

Add a check that the buffer is large enough to hold the fixed struct
and the num_msg variable-length entries.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260625232907.3620746-1-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/wmi.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index 3787b9fb007559..a572952dd4b903 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -484,6 +484,18 @@ static int ath6kl_wmi_tx_complete_event_rx(u8 *datap, int len)
 
 	evt = (struct wmi_tx_complete_event *) datap;
 
+	if (len < sizeof(*evt)) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "tx complete: invalid len %d\n",
+			   len);
+		return -EINVAL;
+	}
+
+	if (len < sizeof(*evt) + evt->num_msg * sizeof(struct tx_complete_msg_v1)) {
+		ath6kl_dbg(ATH6KL_DBG_WMI, "tx complete: invalid len %d for %u msgs\n",
+			   len, evt->num_msg);
+		return -EINVAL;
+	}
+
 	ath6kl_dbg(ATH6KL_DBG_WMI, "comp: %d %d %d\n",
 		   evt->num_msg, evt->msg_len, evt->msg_type);
 
-- 
2.53.0



