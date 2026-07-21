Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4F9471259;
	Tue, 21 Jul 2026 18:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657064; cv=none; b=CVxcvArA3actAsX4hUoScRR0SRkt9cOHjXnrMeoN/lkd97QO8EOfd4pmPhyiAUDUlGtNTRed4KeC6IJPMTwfCPz9HuM9fWtAloziD0Bj7TySstjpA3vnx2G/2G7upZHzI3WOFKnXzw6E3DSIVvyhx1k6kjqsfr22/M3My2XRc3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657064; c=relaxed/simple;
	bh=MjRwZ44QDFpmjT2zRyfwQumw7sHKbYJoFlOgany28kY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGPH4XrH80b7Aq/E2oPqZJrb2ES6Tcn5WbHsaX/l7Mlj3jNwChmPhj4rtavDcODtpJy6p6BWcXDGDaYk+QEAAgQTcFwfSZjHYuOLVQNU4vLcp7qyeZ2vccUvgW10eS9z1JPr97bswWcqYzce4Gr3aj7LQX1vR4mRMzGApdt8m+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmSkaIUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmSkaIUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06B31F00A3D;
	Tue, 21 Jul 2026 18:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657063;
	bh=WLtPjXHbOS7rLwbGq1ftJ0i312HK+ZGE5hIkfspYgto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmSkaIUdH/6Btvy8MiGeBS6pjvcJD+sUxyIfbtfiPvH3ZoXccXnKQ3RWmNXH9Usm2
	 QsX4+EcICLCAKVLE2CjEZ6BEe8Z6MVZsdoXVmuWa1SeUbh5vpY7m5azBh95MqwEj8u
	 EfzaXbac9GMyJ1a0POfDS64jGf5qJv7Ejy6TllMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guilherme Ivo Bozi <guilherme.bozi@usp.br>,
	Salih Erim <salih.erim@amd.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0623/1611] iio: adc: xilinx-ams: fix out-of-bounds channel lookup in event handling
Date: Tue, 21 Jul 2026 17:12:19 +0200
Message-ID: <20260721152529.400722743@linuxfoundation.org>
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
index 124470c9252978..6191cd1b29a510 100644
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



