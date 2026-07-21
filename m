Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ABB35C68D;
	Tue, 21 Jul 2026 21:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669286; cv=none; b=mC5ey/RHDXFFKKn/9eVtBhwcbX6HHxBrF02S9JPTBxdarJsWAO9DcH99jtkDapSl6Ue86fjJlSVErmU0OiglcQ1nkVj5FwzfxXejdFIkdajKRRHwecjdAol4Y2yIdwTHNOcsxEm2czSA5t3I0ckOy3r7K/G9z6D1SA851N+g7zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669286; c=relaxed/simple;
	bh=cBeByIKrYgi9AbnwgYY2TvF3d6N4xBc1bCm+WBTcNb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YH1Yd56jBdwHjss+XIveh1pjgYZri7XIxMHLram5ccIJKJKy7FdzfkUWCWEcyUBQvIMV32d2hfWQiad3hp00mgulpZ7tldqje3fl+d+aTklHvwWWrC3+omoHTYX4gFilAEgMGUgnZcRdRvzGsZ3L17sJ4sTXJdJUSn/2tonTiDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLYKEuCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLYKEuCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A5F1F00A3D;
	Tue, 21 Jul 2026 21:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669274;
	bh=/LNCOXWey1/VdIREH9ItCQwTTSBvQDBgo5kyZ9EG1qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLYKEuCbC1+qR9nZidfMsbnGPp/apBtDrxsBYzl7mdc8ckToidMtAVwZMPZpG2fEU
	 cgPWTmjkCL9ib5xh4a1MDz4Q8NZvk9akzQCsT/Q8gW1ERCDYbcmqL/b4092V1i2EW4
	 ZiZPRhchAz/eFj8kgmEVd9uqiPQx8PMWEaDuNJ5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guilherme Ivo Bozi <guilherme.bozi@usp.br>,
	Salih Erim <salih.erim@amd.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0493/1067] iio: adc: xilinx-ams: fix out-of-bounds channel lookup in event handling
Date: Tue, 21 Jul 2026 17:18:14 +0200
Message-ID: <20260721152435.641610257@linuxfoundation.org>
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
index e1a1f50b4885f4..9045e2fa1154d8 100644
--- a/drivers/iio/adc/xilinx-ams.c
+++ b/drivers/iio/adc/xilinx-ams.c
@@ -861,6 +861,9 @@ static const struct iio_chan_spec *ams_event_to_channel(struct iio_dev *dev,
 		if (dev->channels[i].scan_index == scan_index)
 			break;
 
+	if (i == dev->num_channels)
+		return NULL;
+
 	return &dev->channels[i];
 }
 
@@ -1002,6 +1005,8 @@ static void ams_handle_event(struct iio_dev *indio_dev, u32 event)
 	const struct iio_chan_spec *chan;
 
 	chan = ams_event_to_channel(indio_dev, event);
+	if (!chan)
+		return;
 
 	if (chan->type == IIO_TEMP) {
 		/*
-- 
2.53.0



