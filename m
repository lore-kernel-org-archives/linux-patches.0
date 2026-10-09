Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACE73BED42;
	Fri,  9 Oct 2026 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557490; cv=none; b=LjDkrGSWjYA20mS7Vg2VidVJf4BDe7D8oRyg3TjuZE9sNNYC6ngaI2XgYmZ/LoOaHq1/HGg9COKTMjRO98SVB8pcEDBZMrmna1kVNOE3mARcaaXbEx5UcpyZhDjJ89XKEu8sysq6+p/2fsgZugPmy4VIx2ApUFmZDGar55zjayo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557490; c=relaxed/simple;
	bh=Wbln3EXkVBwkFERFPNvinDoStm9Amw5GYxf7H9Mq63c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzPz+yTpvxYcb1R6GDcBcitkj3HDtO0BwsIClvl5Okod7UNDfpEGMxAhPRUxKlkoVVyKcuOJn0KG/3oldCm8Opp70hKl2AGRRRLun6RuhW+QEx3qO3zrRfi/s3to0iCytEUZdvrrq9BNdLyRc5TIeNhnJ8mLdhuLcNRlAvXfv7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6E21Dep; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6E21Dep"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D3E1F000FF;
	Fri,  9 Oct 2026 14:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557489;
	bh=hA7l2QtgKbHobZpZ1tktWxF8LuipJO32P1nbjYIXxjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6E21DepgCo2G/DCsCzx25qu5JPk2RN+KVqilNOBnZpShEaDQVwzQFmOK+Zix9S+i
	 nLni/qLAFGUi4Qfkn38iOw1NK/mCPExVo5Co27fKqBxYU0m3qGIOtrhIsBl6HlGb70
	 Ld/DzY3Yz5k88ViWQz1GX4qVxc17l/jBVLIepY14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 377/428] iio: adc: ade9000: fix overlapping scan_index for current and voltage channels
Date: Fri,  9 Oct 2026 16:11:54 +0200
Message-ID: <20261009140954.471024422@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit d01f63f673e18f3a99ce8d6fbf1a5f58b70990f7 upstream.

Current channels used scan_index "num" and voltage "num + 1", so with
phases 0, 1 and 2 the indices overlapped and no longer matched the
IA=0, VA=1, IB=2, VB=3, IC=4, VC=5 layout expected by
ade9000_waveform_buffer_config(). Phase B and C buffers were configured
incorrectly.

Use "num * 2" for current and "num * 2 + 1" for voltage to get the
non-overlapping 0/1, 2/3, 4/5 layout.

Fixes: 81de7b4619fc ("iio: adc: add ade9000 support")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ade9000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ade9000.c
+++ b/drivers/iio/adc/ade9000.c
@@ -444,7 +444,7 @@ static const struct iio_chan_spec_ext_in
 			      BIT(IIO_CHAN_INFO_CALIBSCALE),		\
 	.event_spec = ade9000_current_events,				\
 	.num_event_specs = ARRAY_SIZE(ade9000_current_events),		\
-	.scan_index = num,						\
+	.scan_index = num * 2,						\
 	.indexed = 1,							\
 	.scan_type = {							\
 		.sign = 's',						\
@@ -464,7 +464,7 @@ static const struct iio_chan_spec_ext_in
 			      BIT(IIO_CHAN_INFO_FREQUENCY),		\
 	.event_spec = ade9000_voltage_events,				\
 	.num_event_specs = ARRAY_SIZE(ade9000_voltage_events),		\
-	.scan_index = num + 1,	/* interleave with current channels */	\
+	.scan_index = num * 2 + 1, /* interleave with current channels */	\
 	.indexed = 1,							\
 	.scan_type = {							\
 		.sign = 's',						\


