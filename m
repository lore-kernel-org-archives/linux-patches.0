Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9944C356A12;
	Tue, 21 Jul 2026 19:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662447; cv=none; b=q1exlk8400qnx8Uc3PThlIGE0aOz+g+bWI8q+q9WxHOQt1iiiI3k5QYQVnEVdcOAxcNG4aD/DPV/4KVw17GwplOJg7/RkSRXDwENC+TZ6Vej+/6ARmGEU3g+WAQM8vV49XI9rs2jTo3sFKBxK2atuLPm4S0eYf4LAUeF9x/KURU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662447; c=relaxed/simple;
	bh=+Dyk9z1HcRFVu+dCWIvW5DpYAY3nBaVrNsDN9ViHsLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW0f93oQEhxcxbLVV58Ug1BwELaB5kbVNvu7kJLVtbwmVmny21AWev6ridxLIUZf15qGL/hnbrzY9GmHCrGf7kScH2cr124P3CoLI8l/DwuRKzdZWHQ8gJvbBpN5WloVYvbvTY6A2TgGEtc7FM50dC9qF7h7fSBE5AG09O71bjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7FtFX10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7FtFX10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF891F000E9;
	Tue, 21 Jul 2026 19:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662446;
	bh=e9s4tFdmUVkghYGKr+71+ZsIpF+c+RwKoqhclUcP5y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7FtFX10X0c/Egr5bvvfREOOPaKdJgTgtML6S16gagWiChFlGLIi6yfZY3UCHItmn
	 9Rc/2gkAbggu6YOptdXghoQIY2YJpMDCq+Iq+MQcdswZ++ljIiokhouiO7t1sfwKSW
	 I9lCAVJgbvMnGcXeOSQyxkwUdzFJRuDWefGp4WHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guilherme Ivo Bozi <guilherme.bozi@usp.br>,
	Salih Erim <salih.erim@amd.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0447/1276] iio: adc: xilinx-ams: fix out-of-bounds channel lookup in event handling
Date: Tue, 21 Jul 2026 17:14:50 +0200
Message-ID: <20260721152456.105967100@linuxfoundation.org>
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

From: Guilherme Ivo Bozi <guilherme.bozi@usp.br>

[ Upstream commit 947eb6f0a274f8b15a0248051a65b069effd5057 ]

ams_event_to_channel() may return a pointer past the end of
dev->channels when no matching scan_index is found. This can lead
to invalid memory access in ams_handle_event().

Add a bounds check in ams_event_to_channel() and return NULL when
no channel is found. Also guard the caller to safely handle this
case.

Fixes: d5c70627a794 ("iio: adc: Add Xilinx AMS driver")
Signed-off-by: Guilherme Ivo Bozi <guilherme.bozi@usp.br>
Reviewed-by: Salih Erim <salih.erim@amd.com>
Tested-by: Salih Erim <salih.erim@amd.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/xilinx-ams.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/iio/adc/xilinx-ams.c b/drivers/iio/adc/xilinx-ams.c
index e12eb7137b06a3..7d6820c6ea7fc6 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -871,6 +871,9 @@ static const struct iio_chan_spec *ams_event_to_channel(struct iio_dev *dev,
 		if (dev->channels[i].scan_index == scan_index)
 			break;
 
+	if (i == dev->num_channels)
+		return NULL;
+
 	return &dev->channels[i];
 }
 
@@ -1012,6 +1015,8 @@ static void ams_handle_event(struct iio_dev *indio_dev, u32 event)
 	const struct iio_chan_spec *chan;
 
 	chan = ams_event_to_channel(indio_dev, event);
+	if (!chan)
+		return;
 
 	if (chan->type == IIO_TEMP) {
 		/*
-- 
2.53.0



