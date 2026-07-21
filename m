Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D073B6C1C;
	Tue, 21 Jul 2026 20:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666301; cv=none; b=h7TuX58GouR0mvhcE+eSNgyvlKvecbac8pYO76FAYbyqsBR78x+zmO5lRoQABBeRTLqAasiBYUxzIUUZI/lE9Thi+S/98uDHVx8TlIi9oN8Z83qwa45C+34E8ZRiVsmhnoZIorSDpPpwO6+j4v0nxOZ675dbyvwp4UZUVI1KZtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666301; c=relaxed/simple;
	bh=9YnS/t0RO+tCQEUr/z3K+LEoYpZtK5+gFxGCghzoLSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBoVpbbtdpvwLnuzWBdl2BbObyY6/0Rb3V06gAPCrBLCGfN0nEd842wnbrgeEcHCz+qOxZpx73alDQ8GPSg5b70APcSZErKXQko8Kh8DUZ/+lu+jnT8yFlEerRVMPCyYxamGYR87lAPLCrGaWLYwQ9BmwOr2hVOafGCE3SDptxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bNEOYZK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bNEOYZK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152071F00A3D;
	Tue, 21 Jul 2026 20:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666290;
	bh=CQQWVelaYvvpeLDrmi5L6bqQ0uhs+TIeCWPFsTfinps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNEOYZK9IRI73pIH4TsPpywBdgE7phXxXr0Qi/Wobj6K29aYdW+ZblLFbyY+Qw3V0
	 ZA3+lJjBLmw9CJwHpuvA3q+LeqOXBvmky3J3n9LlJ/uozQo9nBGQPmWBZGEdp8D6eZ
	 sfNjthBkD3AaHV1RixfWk0IW7bRk1jK4tv+ts++E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guilherme Ivo Bozi <guilherme.bozi@usp.br>,
	Salih Erim <salih.erim@amd.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0626/1266] iio: adc: xilinx-ams: fix out-of-bounds channel lookup in event handling
Date: Tue, 21 Jul 2026 17:17:43 +0200
Message-ID: <20260721152455.870411632@linuxfoundation.org>
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
index 5de86a953d4182..b704f76592eab6 100644
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



