Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0292B35CB6B;
	Mon,  9 Feb 2026 14:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647326; cv=none; b=fKUXCBJVX+oNCe+/g8lMedTURuRAbc3vcFnl4sWE69fz8es/bxd066llsQfmJQaO471SsOTB9i8/N6W1M4SHyKGI+zi8Z++FvNtVLaJXC+i+fFXxGYGXjT537RiC+xVAyhJTByNhFIJ9mtCGcz6j+j16wtYqdMWKwcRo7h37nkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647326; c=relaxed/simple;
	bh=BZq+RRC/acpkCCdKvVsCyhp0tmpxsZoSjPjBPgjZxOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sNUPn+BUL9uUks/h7qmC+zfrW8EXUad5xD8oooNvWoQINpiJA7ibAjunA9P3COukMnowFHWk+hgnrMB+LyUVc2lhlXAp5RTgsfS0H5vqcGqC5H4l1ISk4K7TTDW/iQbqtBNU/HbOA6e5B7XQ+mrlRjiWtOs+Qrpu41k+Pm4Mwr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtizyRCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtizyRCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63292C116C6;
	Mon,  9 Feb 2026 14:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647325;
	bh=BZq+RRC/acpkCCdKvVsCyhp0tmpxsZoSjPjBPgjZxOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtizyRCM0mVujFhLaAfrd6JJMDEK6fdJQvznJHChy6DOigt9TwcsN2Z12kpVvlp6v
	 AAtCuHMB5FH+mOv3I8KWsW4UHg/86ylOVCFIlZpM/04NTfeZEDFAnLixVzprlNqfH0
	 2ARkxq+mTngYzCk/excOTgf5tn9p1FwAHgsD569U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/175] HID: intel-ish-hid: Reset enum_devices_done before enumeration
Date: Mon,  9 Feb 2026 15:22:20 +0100
Message-ID: <20260209142322.866257491@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 56e230723e3a818373bd62331bccb1c6d2b3881b ]

Some systems have enabled ISH without any sensors. In this case sending
HOSTIF_DM_ENUM_DEVICES results in 0 sensors. This triggers ISH hardware
reset on subsequent enumeration after S3/S4 resume.

The enum_devices_done flag was not reset before sending the
HOSTIF_DM_ENUM_DEVICES command. On subsequent enumeration calls (such as
after S3/S4 resume), this flag retains its previous true value, causing the
wait loop to be skipped and returning prematurely to hid_ishtp_cl_init().
If 0 HID devices are found, hid_ishtp_cl_init() skips getting HID device
descriptors and sets init_done to true. When the delayed enumeration
response arrives with init_done already true, the driver treats it as a bad
packet and triggers an ISH hardware reset.

Set enum_devices_done to false before sending the enumeration command,
consistent with similar functions like ishtp_get_hid_descriptor() and
ishtp_get_report_descriptor() which reset their respective flags.

Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-ish-hid/ishtp-hid-client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/intel-ish-hid/ishtp-hid-client.c b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
index f61add862b6b3..12a43c64e8156 100644
--- a/drivers/hid/intel-ish-hid/ishtp-hid-client.c
+++ b/drivers/hid/intel-ish-hid/ishtp-hid-client.c
@@ -495,6 +495,7 @@ static int ishtp_enum_enum_devices(struct ishtp_cl *hid_ishtp_cl)
 	int rv;
 
 	/* Send HOSTIF_DM_ENUM_DEVICES */
+	client_data->enum_devices_done = false;
 	memset(&msg, 0, sizeof(struct hostif_msg));
 	msg.hdr.command = HOSTIF_DM_ENUM_DEVICES;
 	rv = ishtp_cl_send(hid_ishtp_cl, (unsigned char *)&msg,
-- 
2.51.0



